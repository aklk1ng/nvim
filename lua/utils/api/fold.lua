local o, api = vim.o, vim.api
local ns_id = api.nvim_create_namespace('FoldMark')
local map = require('keymap')

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

-- a very simple mark for fold with manual method
map.v('zf', function()
  api.nvim_feedkeys('zf', 'n', false)
  local sl = vim.fn.getpos('v')[2]
  local el = vim.fn.getpos('.')[2]
  if el < sl then
    local tmp = sl
    sl = el
    el = tmp
  end
  api.nvim_buf_set_extmark(0, ns_id, sl - 1, -1, {
    number_hl_group = 'Function',
  })
end)
