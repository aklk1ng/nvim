require('ccc').setup({
  highlighter = {
    auto_enable = false,
    lsp = true,
  },
})

vim.keymap.set('n', '<leader>o', _G._cmd('CccHighlighterToggle'))
