local M = {}

local tbl = {
  ['function'] = {
    'function_definition',
    'function_declaration',
    'function_item',
  },
  ['class'] = {
    'class_specifier',
    'class_definition',
  },
  ['loop'] = {
    'for_statement',
    'for_range_loop',
    'while_statement',
    'do_statement',
    'for_expression',
    'loop_expresion',
  },
}

--- Find the node that satisfy the `predicate` in the language tree.
---@param node TSNode?
---@param predicate table<string>
---@return TSNode?
local function find_node(node, predicate)
  if not node then
    return
  end

  for _, v in pairs(predicate) do
    if node:type() == v then
      return node
    end
  end
  node = node:parent()
  return find_node(node, predicate)
end

--- Execute the select operation in `node`
---@param node TSNode
---@param space boolean
local function execute(node, space)
  local mode = vim.api.nvim_get_mode()
  if mode.mode ~= 'V' then
    vim.api.nvim_replace_termcodes('V', true, true, true)
    vim.api.nvim_cmd({ cmd = 'normal', bang = true, args = { 'V' } }, {})
  end

  local sr, sc, er, ec = node:range()
  if space then
    vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
    vim.cmd('normal! o')
    vim.api.nvim_win_set_cursor(0, { er + 1, ec })
  else
    for k, v in node:iter_children() do
      if v == 'body' then
        sr, sc, er, ec = k:range()
        break
      end
    end
    if vim.bo.filetype == 'python' then
      if sr ~= er then
        vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
        vim.cmd('normal! o')
        vim.api.nvim_win_set_cursor(0, { er + 1, ec })
      else
        vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
      end
    else
      if sr ~= er then
        vim.api.nvim_win_set_cursor(0, { sr + 2, sc })
        vim.cmd('normal! o')
        vim.api.nvim_win_set_cursor(0, { er, ec })
      else
        vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
      end
    end
  end
end

function M.act(predicate, space)
  local bufnr = vim.api.nvim_get_current_buf()
  if not vim.treesitter.language.get_lang(vim.bo[bufnr].filetype) then
    vim.notify('No treesitter parser for current language')
    return
  end
  local node = vim.treesitter.get_node({ bufnr })
  node = find_node(node, tbl[predicate])

  if not node then
    vim.notify('No expression found')
    return
  end

  execute(node, space)
end

return M
