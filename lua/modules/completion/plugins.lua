local pack = require('core.pack').add_plugin
local completion = require('modules.completion')

pack({
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-buffer' },
  },
  config = completion.cmp,
})

pack({
  'L3MON4D3/LuaSnip',
  event = 'InsertEnter',
  config = completion.lua_snip,
})

pack({
  'neovim/nvim-lspconfig',
  event = { 'BufRead', 'BufNewfile' },
  config = completion.lspconfig,
  dependencies = {
    {
      'folke/neodev.nvim',
      config = completion.neodev,
    },
  },
})

pack({
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = completion.autopairs,
})
