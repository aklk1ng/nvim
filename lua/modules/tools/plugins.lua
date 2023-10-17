local pack = require('core.pack').add_plugin
local tools = require('modules.tools')

pack({
  'nvimdev/lspsaga.nvim',
  event = 'LspAttach',
  branch = 'main',
  config = tools.lspsaga,
})

pack({
  'folke/noice.nvim',
  event = 'LspAttach',
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  config = tools.noice,
})

pack({
  'skywind3000/asyncrun.vim',
  cmd = 'AsyncRun',
})

pack({
  'kevinhwang91/nvim-ufo',
  event = { 'BufRead', 'BufNewFile' },
  dependencies = {
    'kevinhwang91/promise-async',
    {
      'luukvbaal/statuscol.nvim',
      config = tools.statuscol,
    },
  },
  config = tools.ufo,
})

pack({
  'lewis6991/gitsigns.nvim',
  event = { 'BufRead', 'BufNewfile' },
  config = tools.gitsigns,
})

pack({
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope-fzy-native.nvim' },
  },
  config = tools.telescope,
})

pack({
  'kylechui/nvim-surround',
  event = { 'BufRead', 'BufNewFile' },
  config = tools.surround,
})

pack({
  'numToStr/Comment.nvim',
  event = { 'BufRead', 'BufNewFile' },
  config = tools.comment,
})

pack({
  'nvimdev/guard.nvim',
  event = { 'BufRead', 'BufNewFile' },
  dependencies = {
    'nvimdev/guard-collection',
  },
  config = tools.guard,
})

pack({ 'nvim-lua/plenary.nvim', lazy = true })
