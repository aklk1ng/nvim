local M = {}
local api, ts = vim.api, vim.treesitter

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

local function execute(node, space)
  local mode = api.nvim_get_mode()
  if mode.mode ~= 'V' then
    api.nvim_replace_termcodes('V', true, true, true)
    api.nvim_cmd({ cmd = 'normal', bang = true, args = { 'V' } }, {})
  end

  local sr, sc, er, ec = node:range()
  if space then
    -- Remove comment if exists.
    local prev = node:prev_sibling()
    while true do
      if prev and (prev:type() == 'comment' or prev:type() == 'doc_comment') then
        sr, sc, _, _ = prev:range()
        prev = prev:prev_sibling()
      else
        break
      end
    end

    api.nvim_win_set_cursor(0, { sr + 1, sc })
    vim.cmd('normal! o')
    api.nvim_win_set_cursor(0, { er + 1, ec })
  else
    for k, v in node:iter_children() do
      if v == 'body' then
        sr, sc, er, ec = k:range()
        break
      end
    end
    if vim.bo.filetype == 'python' then
      if sr ~= er then
        api.nvim_win_set_cursor(0, { sr + 1, sc })
        vim.cmd('normal! o')
        api.nvim_win_set_cursor(0, { er + 1, ec })
      else
        api.nvim_win_set_cursor(0, { sr + 1, sc })
      end
    else
      if sr ~= er then
        api.nvim_win_set_cursor(0, { sr + 2, sc })
        vim.cmd('normal! o')
        api.nvim_win_set_cursor(0, { er, ec })
      else
        api.nvim_win_set_cursor(0, { sr + 1, sc })
      end
    end
  end
end

function M.select(predicate, space)
  local bufnr = api.nvim_get_current_buf()
  if not ts.language.get_lang(vim.bo[bufnr].filetype) then
    vim.notify('No treesitter parser for current language')
    return
  end
  local node = ts.get_node({ bufnr })
  node = find_node(node, tbl[predicate])

  if not node then
    vim.notify('No expression found')
    return
  end

  execute(node, space)
end

return M
