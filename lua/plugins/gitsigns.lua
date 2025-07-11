require('gitsigns').setup({})

vim.keymap.set('n', '<leader>g', _G._cmd('Gitsigns diffthis vertical=true'))
vim.keymap.set('n', ']c', function()
  if vim.wo.diff then
    vim.cmd.normal({ ']c', bang = true })
  else
    require('gitsigns').nav_hunk('next', { target = 'all' })
  end
end, { silent = true })
vim.keymap.set('n', '[c', function()
  if vim.wo.diff then
    vim.cmd.normal({ '[c', bang = true })
  else
    require('gitsigns').nav_hunk('prev', { target = 'all' })
  end
end, { silent = true })
vim.keymap.set('n', '<leader>b', _G._cmd('Gitsigns toggle_current_line_blame'))
