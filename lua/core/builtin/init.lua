require('core.builtin.globals')
require('core.builtin.keys')
require('core.builtin.options')

-- autocmds can be loaded lazily when not opening a file
local lazy_autocmds = vim.fn.argc(-1) == 0
if not lazy_autocmds then
  require('core.builtin.event')
end

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    if lazy_autocmds then
      require('core.builtin.event')
    end
    require('core.builtin.stl').setup()
    require('core.builtin.lsp')
    require('core.builtin.message')
    require('keymap')
    require('utils')
  end,
})
