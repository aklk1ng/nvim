function ToggleTodoStatus()
  local line = vim.api.nvim_get_current_line()
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  if string.match(line, '%[%s%]', 1) then
    vim.fn.setline(lnum, vim.fn.substitute(line, '\\[ \\]', '[x]', ''))
  elseif string.match(line, '%[%w%]', 1) then
    vim.fn.setline(lnum, vim.fn.substitute(line, '\\[x\\]', '[ ]', ''))
  end
  vim.cmd('silent! write')
end

_G.map('n', '<2-LeftMouse>', ToggleTodoStatus, { buffer = true })
_G.map('n', '<CR>', ToggleTodoStatus, { buffer = true })
