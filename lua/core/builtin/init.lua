require('core.builtin.globals')
require('core.builtin.keys')
require('core.builtin.options')
require('core.builtin.event')
require('core.builtin.message')

-- just load lazily when not opening a file
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*',
  callback = function()
    require('core.builtin.stl').setup()
    require('core.builtin.lsp')
    require('utils')
  end,
})

require('keymap')
