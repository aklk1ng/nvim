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
  'folke/noice.nvim',
  event = { 'BufRead', 'BufNewfile' },
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  config = tools.noice,
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
  'nvimdev/indentmini.nvim',
  event = { 'BufRead', 'BufNewfile' },
  config = tools.indentmini,
})

packadd({
  'stevearc/oil.nvim',
  cmd = 'Oil',
  config = tools.oil,
})

packadd({
  'echasnovski/mini.hipatterns',
  event = { 'BufRead', 'BufNewfile' },
  version = '*',
  config = function()
    require('modules.tools').hipatterns()
  end,
})

packadd({
  'tpope/vim-scriptease',
  event = { 'BufRead', 'BufNewfile' },
  config = tools.scriptease,
})

packadd({ 'nvim-lua/plenary.nvim', lazy = true })
