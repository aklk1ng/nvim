-- Copy from Nvchad.

local api, fn = vim.api, vim.fn
local g = vim.g
local Terms = {}
local set_buf = api.nvim_set_current_buf

_G.Terms = Terms

g.terms = {}

local pos_data = {
  sp = { resize = 'height', area = 'lines' },
  vsp = { resize = 'width', area = 'columns' },
}

local config = {
  sizes = { sp = 0.4, vsp = 0.45 },
  float = {
    relative = 'editor',
    row = 0.07,
    col = 0.07,
    width = 0.85,
    height = 0.85,
    border = 'single',
  },
}

-- Used for initially resizing terms.
vim.g.nvhterm = false
vim.g.nvvterm = false

-------------------------- util funcs -----------------------------
local function save_term_info(index, val)
  local terms_list = g.terms
  terms_list[tostring(index)] = val
  g.terms = terms_list
end

local function opts_to_id(id)
  for _, opts in pairs(g.terms) do
    if opts.id == id then
      return opts
    end
  end
end

local function create_float(buffer, float_opts)
  local opts = vim.tbl_deep_extend('force', config.float, float_opts or {})

  opts.width = math.ceil(opts.width * vim.o.columns)
  opts.height = math.ceil(opts.height * vim.o.lines)
  opts.row = math.ceil(opts.row * vim.o.lines)
  opts.col = math.ceil(opts.col * vim.o.columns)

  api.nvim_open_win(buffer, true, opts)
end

local function format_cmd(cmd)
  return type(cmd) == 'string' and cmd or cmd()
end

local function display(opts)
  if opts.pos == 'float' then
    create_float(opts.buf, opts.float_opts)
  else
    vim.cmd(opts.pos)
  end

  local win = api.nvim_get_current_win()
  opts.win = win

  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.bo[opts.buf].buflisted = false
  vim.cmd('startinsert')

  -- Resize non floating wins initially + or only when they're toggleable.
  if
    (opts.pos == 'sp' and not vim.g.nvhterm)
    or (opts.pos == 'vsp' and not vim.g.nvvterm)
    or (opts.pos ~= 'float')
  then
    local pos_type = pos_data[opts.pos]
    local size = opts.size and opts.size or config.sizes[opts.pos]
    local new_size = vim.o[pos_type.area] * size
    api['nvim_win_set_' .. pos_type.resize](0, math.floor(new_size))
  end

  api.nvim_win_set_buf(win, opts.buf)
end

local function create(opts)
  local buf_exists = opts.buf
  opts.buf = opts.buf or api.nvim_create_buf(false, true)

  -- Handle cmd opt.
  local shell = vim.o.shell
  local cmd = shell

  if opts.cmd and opts.buf then
    cmd = { shell, '-c', format_cmd(opts.cmd) .. '; ' .. shell }
  else
    cmd = { shell }
  end

  display(opts)

  save_term_info(opts.buf, opts)

  local termopen_opts = {
    on_exit = function()
      if opts.win and api.nvim_win_is_valid(opts.win) then
        api.nvim_win_close(opts.win, true)
      end
    end,
  }

  if not buf_exists then
    fn.termopen(cmd, termopen_opts)
  end

  vim.g.nvhterm = opts.pos == 'sp'
  vim.g.nvvterm = opts.pos == 'vsp'
end

--------------------------- user api -------------------------------
Terms.new = function(opts)
  create(opts)
end

Terms.toggle = function(opts)
  local x = opts_to_id(opts.id)
  opts.buf = x and x.buf or nil

  if (x == nil or not api.nvim_buf_is_valid(x.buf)) or fn.bufwinid(x.buf) == -1 then
    create(opts)
  else
    api.nvim_win_close(x.win, true)
  end
end

-- Spawns term with *cmd & runs the *cmd if the keybind is run again.
Terms.runner = function(opts)
  local x = opts_to_id(opts.id)
  local clear_cmd = opts.clear_cmd or 'clear; '
  opts.buf = x and x.buf or nil

  -- If buf doesnt exist.
  if x == nil then
    create(opts)
  else
    -- Window isnt visible.
    if fn.bufwinid(x.buf) == -1 then
      display(opts)
    end

    local cmd = format_cmd(opts.cmd)

    if x.buf == api.nvim_get_current_buf() then
      set_buf(g.buf_history[#g.buf_history - 1])
      cmd = format_cmd(opts.cmd)
      set_buf(x.buf)
    end

    local job_id = vim.b[x.buf].terminal_job_id
    api.nvim_chan_send(job_id, clear_cmd .. cmd .. ' \n')
  end
end

--------------------------- autocmds -------------------------------
api.nvim_create_autocmd('TermClose', {
  callback = function(args)
    save_term_info(args.buf, nil)
  end,
})
