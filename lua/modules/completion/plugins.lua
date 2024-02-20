local completion = require('modules.completion')

packadd({
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'hrsh7th/cmp-buffer' },
  },
  config = completion.cmp,
})

packadd({
  'L3MON4D3/LuaSnip',
  event = 'InsertEnter',
  config = completion.lua_snip,
})

packadd({
  'neovim/nvim-lspconfig',
  event = { 'BufRead', 'BufNewfile' },
  config = completion.lspconfig,
})
