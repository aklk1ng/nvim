local tools = require('modules.tools')

packadd({
  'nvimdev/lspsaga.nvim',
  event = 'LspAttach',
  branch = 'main',
  config = tools.lspsaga,
})

packadd({
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufRead', 'BufNewfile' },
  build = ':TSUpdate',
  config = tools.treesitter,
})

packadd({
  'kevinhwang91/nvim-ufo',
  event = { 'BufRead', 'BufNewfile' },
  dependencies = {
    'kevinhwang91/promise-async',
    {
      'luukvbaal/statuscol.nvim',
      config = tools.statuscol,
    },
  },
  config = tools.ufo,
})

packadd({
  'lewis6991/gitsigns.nvim',
  event = { 'BufEnter */*' },
  config = tools.gitsigns,
})

packadd({
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope-fzy-native.nvim' },
  },
  config = tools.telescope,
})

packadd({
  'kylechui/nvim-surround',
  event = { 'BufRead', 'BufNewfile' },
  config = tools.surround,
})

packadd({
  'nvimdev/guard.nvim',
  cmd = 'GuardFmt',
  dependencies = {
    'nvimdev/guard-collection',
  },
  config = tools.guard,
})

packadd({
  'echasnovski/mini.files',
  version = '*',
  event = { 'BufEnter */*' },
  config = tools.files,
})

packadd({
  'echasnovski/mini.move',
  version = '*',
  event = { 'BufEnter */*' },
  config = tools.move,
})

packadd({
  'NvChad/nvim-colorizer.lua',
  cmd = 'ColorizerToggle',
  config = tools.colorizer,
})

packadd({ 'nvim-lua/plenary.nvim', lazy = true })
