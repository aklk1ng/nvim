local pack = require('core.pack').add_plugin
local tools = require('modules.tools')

pack({
  'nvimdev/lspsaga.nvim',
  event = 'LspAttach',
  branch = 'main',
  config = tools.lspsaga,
})

pack({
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufRead', 'BufNewfile' },
  build = ':TSUpdate',
  config = tools.treesitter,
})

pack({
  'folke/noice.nvim',
  event = { 'BufRead', 'BufNewfile' },
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  config = tools.noice,
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
  keys = { 'cs', 'ds', 'ys' },
  config = tools.surround,
})

pack({
  'nvimdev/guard.nvim',
  cmd = 'GuardFmt',
  dependencies = {
    'nvimdev/guard-collection',
  },
  config = tools.guard,
})

pack({
  'mbbill/undotree',
  cmd = 'UndotreeToggle',
})

pack({
  'nvimdev/indentmini.nvim',
  event = { 'BufRead', 'BufNewfile' },
  config = tools.indentmini,
})

pack({ 'nvim-lua/plenary.nvim', lazy = true })
