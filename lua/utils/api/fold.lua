local o, api = vim.o, vim.api
_G.foldtext = function()
  local start, foldend = vim.v.foldstart, vim.v.foldend
  local linenr = start
  local line = api.nvim_buf_get_lines(0, linenr - 1, linenr, false)[1]
  while line == '' do
    linenr = linenr + 1
    line = api.nvim_buf_get_lines(0, linenr - 1, linenr, false)[1]
  end
  local decorator = '  ' .. (foldend - start + 1) .. ' ↙'

  local parser = vim.treesitter.get_parser(0, vim.treesitter.language.get_lang(vim.bo.ft))
  local query = vim.treesitter.query.get(parser:lang(), 'highlights')
  if not query then
    return line .. decorator
  end
  local tree = parser:parse({ start - 1, start })[1]
  local result = {}
  local line_pos = 0
  local prev_range = nil
  for id, node, _ in query:iter_captures(tree:root(), 0, start - 1, start) do
    local name = query.captures[id]
    local start_row, start_col, end_row, end_col = node:range()
    if start_row == start - 1 and end_row == start - 1 then
      local range = { start_col, end_col }
      if start_col > line_pos then
        table.insert(result, { line:sub(line_pos + 1, start_col), 'Folded' })
      end
      line_pos = end_col
      local text = vim.treesitter.get_node_text(node, 0)
      if prev_range ~= nil and range[1] == prev_range[1] and range[2] == prev_range[2] then
        result[#result] = { text, '@' .. name }
      else
        table.insert(result, { text, '@' .. name })
      end
      prev_range = range
    end
  end
  table.insert(result, { decorator, 'Function' })
  return result
end
o.foldtext = 'v:lua.foldtext()'
