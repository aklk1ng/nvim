-- Copy from Nvchad.

local api, fn = vim.api, vim.fn
local g = vim.g
local Terms = {}

_G.Terms = Terms

g.terms = {}

local config = {
  relative = 'editor',
  row = 0.06,
  col = 0.06,
  width = 0.85,
  height = 0.85,
  border = 'single',
}

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
  local opts = vim.tbl_deep_extend('force', config, float_opts or {})

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
  create_float(opts.buf, opts.float_opts)
  local win = api.nvim_get_current_win()
  opts.win = win

  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.bo[opts.buf].buflisted = false
  vim.cmd('startinsert')

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
end

--------------------------- user api -------------------------------
Terms.toggle = function(opts)
  local x = opts_to_id(opts.id)
  opts.buf = x and x.buf or nil

  if (x == nil or not api.nvim_buf_is_valid(x.buf)) or fn.bufwinid(x.buf) == -1 then
    create(opts)
  else
    api.nvim_win_close(x.win, true)
  end
end

--------------------------- autocmds -------------------------------
api.nvim_create_autocmd('TermClose', {
  callback = function(args)
    save_term_info(args.buf, nil)
  end,
})
