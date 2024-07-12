local mod = require('modules')

packadd({
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    {
      'garymjr/nvim-snippets',
      config = mod.snippet,
    },
  },
  config = mod.cmp,
})

packadd({
  'neovim/nvim-lspconfig',
  event = { 'BufRead', 'BufNewfile' },
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
  },
  config = mod.lspconfig,
})

packadd({
  'nvimdev/lspsaga.nvim',
  event = 'LspAttach',
  branch = 'main',
  config = mod.lspsaga,
})

packadd({
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufRead', 'BufNewfile' },
  build = ':TSUpdate',
  config = mod.treesitter,
})

packadd({
  'lewis6991/gitsigns.nvim',
  event = { 'BufEnter */*' },
  config = mod.gitsigns,
})

packadd({
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  config = mod.telescope,
})

packadd({
  'kylechui/nvim-surround',
  event = { 'BufRead', 'BufNewfile' },
  config = mod.surround,
})

packadd({
  'stevearc/conform.nvim',
  event = 'BufWritePre',
  config = mod.conform,
})

packadd({
  'echasnovski/mini.files',
  version = '*',
  event = { 'BufEnter */*' },
  config = mod.files,
})

packadd({
  'echasnovski/mini.move',
  version = '*',
  event = { 'BufEnter */*' },
  config = mod.move,
})

packadd({
  'NvChad/nvim-colorizer.lua',
  cmd = 'ColorizerToggle',
  config = mod.colorizer,
})
