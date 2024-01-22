local ts_utils = require('nvim-treesitter.ts_utils')
local parsers = require('nvim-treesitter.parsers')

local M = {}
local tbl = {
  ['function'] = {
    'function_definition',
    'function_declaration',
  },
  ['class'] = {
    'class_specifier',
  },
}

local function find_node(node, predicates)
  if not node then
    return
  end

  for _, v in pairs(predicates) do
    if node:type() == v then
      return node
    end
  end
  node = node:parent()
  return find_node(node, predicates)
end

local function execute(node, space)
  local mode = vim.api.nvim_get_mode()
  if mode.mode ~= 'V' then
    vim.api.nvim_replace_termcodes('V', true, true, true)
    vim.api.nvim_cmd({ cmd = 'normal', bang = true, args = { 'V' } }, {})
  end

  local sr, sc, er, ec = node:range()
  -- remove comment if exists
  local prev = node:prev_sibling()
  if space and prev:type() == 'comment' then
    sr, sc, _, _ = prev:range()
  end
  if space then
    vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
    vim.cmd('normal! o')
    vim.api.nvim_win_set_cursor(0, { er + 1, ec })
  else
    vim.api.nvim_win_set_cursor(0, { sr + 2, sc })
    vim.cmd('normal! o')
    vim.api.nvim_win_set_cursor(0, { er, ec })
  end
end

function M.select(space, predicate)
  local bufnr = vim.api.nvim_get_current_buf()
  local lang = parsers.get_buf_lang(bufnr)

  if not parsers.has_parser(lang) then
    vim.notify('No treesitter parser for current language')
    return
  end

  local node = ts_utils.get_node_at_cursor(0)
  node = find_node(node, tbl[predicate])

  if not node then
    vim.notify('No expression found')
    return
  end

  execute(node, space)
end

return M
