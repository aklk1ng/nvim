local o, api = vim.o, vim.api
_G.foldtext = function()
  local start, foldend = vim.v.foldstart, vim.v.foldend
  local linenr = start
  local line = api.nvim_buf_get_lines(0, linenr - 1, linenr, false)[1]
  while line == '' do
    linenr = linenr + 1
    line = api.nvim_buf_get_lines(0, linenr - 1, linenr, false)[1]
  end
  local decorator = '  ' .. '↙ ' .. (foldend - start + 1)
  return line .. decorator
end
o.foldtext = 'v:lua.foldtext()'
