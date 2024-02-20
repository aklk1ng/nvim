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
  'lewis6991/gitsigns.nvim',
  event = { 'BufRead', 'BufNewfile' },
  config = tools.gitsigns,
})

packadd({
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope-fzy-native.nvim' },
    {
      'LukasPietzschmann/telescope-tabs',
      config = tools.tabs,
    },
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
  event = { 'BufRead', 'BufNewfile' },
  config = tools.files,
})

packadd({
  'NvChad/nvim-colorizer.lua',
  cmd = 'ColorizerToggle',
  config = tools.colorizer,
})

packadd({ 'nvim-lua/plenary.nvim', lazy = true })
