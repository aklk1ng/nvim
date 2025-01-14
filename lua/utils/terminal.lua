_G.Terms = {}

---@class Term
---@field id? integer job id
---@field bufnr? integer buffnr of `Term`
---@field win? integer win of `Term`
---@field cmd? string command to execute
---@field float_opts? vim.api.keyset.win_config same as `nvim_open_win`

---@type table<integer,Term>
vim.g.terms = {}

---Default config for float terminal.
---@type vim.api.keyset.win_config
local config = {
  relative = 'editor',
  width = 0.85,
  height = 0.85,
}

---Save the `Term` info with tabnr.
---@param tabnr integer
---@param val Term?
local function save_term_info(tabnr, val)
  local terms_list = vim.g.terms
  terms_list[tabnr] = val
  vim.g.terms = terms_list
end

---Create a float window by buffer and opts.
---@param buffer integer
---@param float_opts vim.api.keyset.win_config
local function create_float(buffer, float_opts)
  local opts = vim.tbl_deep_extend('force', config, float_opts or {})

  opts.width = math.ceil(opts.width * vim.o.columns)
  opts.height = math.ceil(opts.height * vim.o.lines)
  opts.row = opts.row or math.ceil(vim.o.lines - opts.height) / 2
  opts.col = opts.col or math.ceil(vim.o.columns - opts.width) / 2

  vim.api.nvim_open_win(buffer, true, opts)
end

---Create float window and set some informations.
---@param opts Term
local function display(opts)
  create_float(opts.bufnr, opts.float_opts)
  local win = vim.api.nvim_get_current_win()
  opts.win = win

  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.bo[opts.bufnr].buflisted = false
  vim.cmd('startinsert')

  vim.api.nvim_win_set_buf(win, opts.bufnr)
end

---@param tabnr integer
---@param opts Term
local function create_term(tabnr, opts)
  local buf = opts.bufnr
  opts.bufnr = opts.bufnr or vim.api.nvim_create_buf(false, true)

  local cmd = {}

  -- Have created this term before, so just use `chansend`
  if opts.bufnr and opts.id and opts.cmd then
    cmd = { opts.cmd, '' }
    vim.fn.chansend(opts.id, cmd)
  end

  display(opts)

  -- Create the shell at initialization
  if not buf then
    local shell = vim.o.shell
    if opts.cmd then
      cmd = { shell, '-c', opts.cmd .. '; ' .. shell }
    else
      cmd = { shell }
    end

    opts.id = vim.fn.jobstart(cmd, {
      term = true,
      on_exit = function()
        if opts.win and vim.api.nvim_win_is_valid(opts.win) then
          vim.api.nvim_win_close(opts.win, true)
        end
      end,
    })
  end

  save_term_info(tabnr, opts)
end

---Toggle a term with current tabpage.
---@param cmd string? shell command
_G.Terms.toggle = function(cmd)
  local tabnr = vim.api.nvim_get_current_tabpage()

  local term = nil
  for tab, info in pairs(vim.g.terms) do
    if tab == tabnr then
      term = info
      break
    end
  end

  if not term or not vim.api.nvim_buf_is_valid(term.bufnr) or vim.fn.bufwinid(term.bufnr) == -1 then
    term = term or {}
    term.cmd = cmd
    term.bufnr = term.bufnr or nil
    create_term(tabnr, term)
  else
    vim.api.nvim_win_hide(term.win)
  end
end

-- Clean `Term` info
vim.api.nvim_create_autocmd('TabClosed', {
  callback = function()
    local tabnr = tonumber(vim.fn.expand('<afile>')) --[[@as integer]]
    local term = vim.g.terms[tabnr]
    if term then
      vim.api.nvim_buf_delete(term.bufnr, { force = true })
      if term.id then
        vim.fn.chanclose(term.id)
      end
    end
    save_term_info(tabnr, nil)
  end,
})
