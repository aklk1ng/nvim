vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2

---Toggle current todo line status.
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

vim.keymap.set('n', '<2-LeftMouse>', ToggleTodoStatus, { buffer = true })
vim.keymap.set('n', '<CR>', ToggleTodoStatus, { buffer = true })
