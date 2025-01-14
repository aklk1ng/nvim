-- https://github.com/NvChad/ui/blob/v3.0/lua/nvchad/term/init.lua

_G.Terms = {}

---@class Config
---@field cmd? string
---@field id string Identifier of the terminal
---@field float? boolean Position about the window, default is `false`
---@field size? number Size scale, between 0 to 1
---@field buf? integer
---@field win? integer
---@field job_id? integer
---@field float_opts? vim.api.keyset.win_config
---@field winopts? table<any, any>

---@type table<integer, Config>
vim.g.terms = {}

---Default config.
local config = {
  winopts = {
    number = false,
    relativenumber = false,
    scrolloff = 0,
    winfixheight = true,
    winfixwidth = true,
  },
  size = 0.4,
  ---@type vim.api.keyset.win_config
  float = {
    relative = 'editor',
    width = 0.85,
    height = 0.85,
  },
}

-------------------------- util funcs -----------------------------
---@param index integer
local function save_term_info(index, val)
  local terms_list = vim.g.terms
  terms_list[tostring(index)] = val
  vim.g.terms = terms_list
end

---@param id string
local function opts2id(id)
  for _, opts in pairs(vim.g.terms) do
    if opts.id == id then
      return opts
    end
  end
end

---@param opts Config
local function create_float(opts)
  opts.float_opts = vim.tbl_extend('force', config.float, opts.float_opts or {})
  opts.float_opts.width = math.ceil(config.float.width * vim.o.columns)
  opts.float_opts.height = math.ceil(config.float.height * vim.o.lines)
  opts.float_opts.row = math.ceil(vim.o.lines - opts.float_opts.height) / 2
  opts.float_opts.col = math.ceil(vim.o.columns - opts.float_opts.width) / 2

  vim.api.nvim_open_win(opts.buf, true, opts.float_opts)
end

---@param opts Config
local function display(opts)
  opts.float = opts.float and opts.float or false
  if opts.float then
    create_float(opts)
  else
    vim.cmd('split')
    -- resize non floating wins initially + or only when they're toggleable
    opts.size = opts.size and opts.size or config.size
    local new_size = vim.o.lines * opts.size
    vim.api.nvim_win_set_height(0, math.floor(new_size))
  end
  opts.win = vim.api.nvim_get_current_win()

  vim.bo[opts.buf].buflisted = true
  vim.bo[opts.buf].filetype = 'terminal'
  vim.cmd('startinsert')

  vim.api.nvim_win_set_buf(opts.win, opts.buf)
  opts.winopts = vim.tbl_deep_extend('force', config.winopts, opts.winopts or {})
  for k, v in pairs(opts.winopts) do
    vim.wo[opts.win][k] = v
  end

  save_term_info(opts.buf, opts)
end

---@param opts Config
local function create(opts)
  local buf_exists = opts.buf
  opts.buf = opts.buf or vim.api.nvim_create_buf(false, true)

  -- handle cmd opt
  local shell = vim.o.shell
  local cmd = nil

  if opts.cmd and opts.buf then
    cmd = { shell, '-c', opts.cmd .. '; ' .. shell }
  else
    cmd = { shell }
  end

  display(opts)

  if not buf_exists then
    opts.job_id = vim.fn.jobstart(cmd, {
      term = true,
      on_exit = function()
        if opts.win and vim.api.nvim_win_is_valid(opts.win) then
          vim.api.nvim_win_close(opts.win, true)
        end
      end,
    })
  end

  save_term_info(opts.buf, opts)
end

--------------------------- user api -------------------------------
---@param opts Config
_G.Terms.new = function(opts)
  create(opts)
end

---@param opts Config
_G.Terms.toggle = function(opts)
  local x = opts2id(opts.id)
  opts = x and x or opts
  opts.buf = x and x.buf or nil

  if x == nil or not vim.api.nvim_buf_is_valid(x.buf) then
    create(opts)
  elseif vim.fn.bufwinid(x.buf) == -1 then
    display(opts)
  else
    vim.api.nvim_win_hide(x.win)
  end
end

---Spawns term with `cmd` or runs the `cmd` if the term is running.
---@param opts Config
_G.Terms.runner = function(opts)
  local x = opts2id(opts.id)
  opts.buf = x and x.buf or nil

  -- if buf doesnt exist
  if x == nil then
    create(opts)
  else
    -- window isn't visible
    if vim.fn.bufwinid(x.buf) == -1 then
      display(opts)
    end

    vim.api.nvim_chan_send(x.job_id, 'clear; ' .. opts.cmd .. ' \n')
  end
end

---Hide a terminal window.
_G.Terms.hide = function()
  local ids = {}
  local terms = {}
  for _, info in pairs(vim.g.terms) do
    if vim.api.nvim_buf_is_valid(info.buf) and vim.fn.bufwinid(info.buf) ~= -1 then
      table.insert(ids, info.id)
      terms[info.id] = info.win
    end
  end
  if #ids == 0 then
    return
  end

  vim.ui.select(ids, {
    prompt = 'Select a term to hide> ',
  }, function(choice)
    if not choice then
      return
    end
    vim.api.nvim_win_hide(terms[choice])
  end)
end

---Resume a terminal window.
_G.Terms.resume = function()
  local ids = {}
  local terms = {}
  for _, info in pairs(vim.g.terms) do
    if vim.api.nvim_buf_is_valid(info.buf) and vim.fn.bufwinid(info.buf) == -1 then
      table.insert(ids, info.id)
      terms[info.id] = info
    end
  end
  if #ids == 0 then
    return
  end

  vim.ui.select(ids, {
    prompt = 'Select a term to resume> ',
  }, function(choice)
    if not choice then
      return
    end
    display(terms[choice])
  end)
end

--------------------------- autocmds -------------------------------
vim.api.nvim_create_autocmd('TermClose', {
  callback = function(args)
    save_term_info(args.buf, nil)
  end,
})
