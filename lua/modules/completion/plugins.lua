local pack = require('core.pack').add_plugin
local completion = require('modules.completion')

pack({
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'hrsh7th/cmp-buffer' },
  },
  config = completion.cmp,
})

pack({
  'L3MON4D3/LuaSnip',
  event = 'InsertEnter',
  config = completion.lua_snip,
})

-- pack({
--   'nvimdev/epo.nvim',
--   event = 'LspAttach',
--   config = function()
--     local helper = require('core.helper')
--     local kind_icons = require('utils.icons')
--     require('epo').setup({
--       fuzzy = false,
--       debounce = 50,
--       signature = false,
--       snippet_path = helper.get_config_path() .. '/lua/snippets/',
--       kind_format = function(k)
--         -- return kind_icons.get(k, false)
--         return k
--       end,
--     })
--   end,
--   vim.keymap.set('i', '<C-space>', function()
--     if vim.fn.pumvisible() == 1 then
--       return vim.api.nvim_replace_termcodes('<C-y>', true, true, true)
--     end
--     return '<C-space>'
--   end, { expr = true, noremap = true }),
-- })

pack({
  'neovim/nvim-lspconfig',
  event = { 'BufRead', 'BufNewfile' },
  config = completion.lspconfig,
})
