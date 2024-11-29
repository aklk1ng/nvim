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
  config = mod.lspconfig,
})

packadd({
  'ibhagwan/fzf-lua',
  cmd = 'FzfLua',
  config = mod.fzflua,
})

packadd({
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufRead', 'BufNewfile' },
  build = ':TSUpdate',
  config = mod.treesitter,
})

packadd({
  'lewis6991/gitsigns.nvim',
  event = 'BufEnter */*',
  config = mod.gitsigns,
})

packadd({
  'kylechui/nvim-surround',
  event = { 'BufRead', 'BufNewfile' },
  config = mod.surround,
})

packadd({
  'stevearc/conform.nvim',
  event = 'BufWritePre',
  keys = {
    {
      'gqq',
      function()
        require('conform').format(
          { async = true, lsp_fallback = 'fallback', quiet = true },
          function(err)
            if not err then
              local mode = vim.api.nvim_get_mode().mode
              if vim.startswith(string.lower(mode), 'v') then
                vim.api.nvim_feedkeys(
                  vim.api.nvim_replace_termcodes('<Esc>', true, false, true),
                  'n',
                  true
                )
              end
            end
          end
        )
      end,
      mode = '',
      desc = 'Format buffer',
    },
  },
  config = mod.conform,
})

packadd({
  'stevearc/oil.nvim',
  cmd = 'Oil',
  config = mod.oil,
})

packadd({
  'NvChad/nvim-colorizer.lua',
  cmd = 'ColorizerToggle',
  config = mod.colorizer,
})
