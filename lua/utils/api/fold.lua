local o, api = vim.o, vim.api
_G.foldtext = function()
  local start, foldend = vim.v.foldstart, vim.v.foldend
  local line = api.nvim_buf_get_lines(0, start - 1, start, false)[1]
  local decorator = '  ' .. (foldend - start + 1) .. ' ↙'
  return line .. decorator
end
o.foldtext = 'v:lua.foldtext()'
