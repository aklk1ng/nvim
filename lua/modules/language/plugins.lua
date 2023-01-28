local pack = require('core.pack').add_plugin
local language = require('modules.language')

pack({
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufRead', 'BufNewfile' },
  build = ':TSUpdate',
  config = language.treesitter,
  dependencies = {
    -- { 'HiPhish/nvim-ts-rainbow2' },
    { 'nvim-treesitter/playground' },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
  },
})

pack({
  'iamcco/markdown-preview.nvim',
  build = 'cd app && npm install',
  ft = 'markdown',
  cmd = 'MarkdownPreview',
  config = language.markdown_preview,
  dependencies = {
    { 'mzlogin/vim-markdown-toc', cmd = 'MarkdownPreview' },
  },
})
