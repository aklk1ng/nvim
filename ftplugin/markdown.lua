function ToggleTodoStatus()
  local line = vim.api.nvim_get_current_line()
  if string.match(line, '%[%s%]', 1) then
    vim.fn.setline('.', vim.fn.substitute(line, '\\[ \\]', '[x]', ''))
  elseif string.match(line, '%[%w%]', 1) then
    vim.fn.setline('.', vim.fn.substitute(line, '\\[x\\]', '[ ]', ''))
  end
  vim.cmd('write')
end

vim.keymap.set('n', '<2-LeftMouse>', ToggleTodoStatus, { noremap = true, silent = true })
vim.keymap.set('n', '<CR>', ToggleTodoStatus, { noremap = true, silent = true })
