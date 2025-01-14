local mod = require('plugins.config')

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
  'ibhagwan/fzf-lua',
  cmd = 'FzfLua',
  init = function()
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.select = function(items, opts, on_choice)
      local ui_select = require('fzf-lua.providers.ui_select')

      if not ui_select.is_registered() then
        ui_select.register()
      end

      if #items > 0 then
        return vim.ui.select(items, opts, on_choice)
      end
    end
  end,
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
  'echasnovski/mini.align',
  version = '*',
  event = { 'BufRead', 'BufNewfile' },
  config = mod.align,
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
              if vim.startswith(string.lower(vim.fn.mode()), 'v') then
                vim.api.nvim_feedkeys(vim.keycode('<Esc>'), 'n', true)
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
  event = 'VimEnter */*',
  cmd = 'Oil',
  config = mod.oil,
})

packadd({
  'catgoose/nvim-colorizer.lua',
  cmd = { 'ColorizerToggle' },
  config = mod.colorizer,
})
