local pack = require('core.pack').add_plugin
local tools = require('modules.tools')

pack({
  'glepnir/lspsaga.nvim',
  ft = _G.lsp_ft,
  branch = 'main',
  config = tools.lspsaga,
})

pack({
  'folke/flash.nvim',
  keys = tools.flash,
})

pack({
  'folke/noice.nvim',
  ft = _G.lsp_ft,
  config = tools.noice,
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
})

pack({
  'kevinhwang91/nvim-ufo',
  ft = _G.lsp_ft,
  config = tools.ufo,
  dependencies = {
    { 'kevinhwang91/promise-async' },
    {
      'luukvbaal/statuscol.nvim',
      config = tools.statuscol,
    },
  },
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
    { 'xiyaowong/telescope-emoji.nvim' },
  },
  config = tools.telescope,
})

pack({
  'glepnir/dbsession.nvim',
  cmd = { 'SessionSave', 'SessionLoad', 'SessionDelete' },
  config = tools.dbsession,
})

pack({
  'nvimdev/dyninput.nvim',
  event = { 'BufRead', 'BufNewFile' },
  ft = { 'go', 'rust' },
  config = tools.dyninput,
})

pack({
  'kylechui/nvim-surround',
  event = { 'BufRead', 'BufNewFile' },
  config = tools.surround,
})

pack({
  'numToStr/Comment.nvim',
  event = { 'BufRead', 'BufNewFile' },
  config = tools.comment,
})

pack({
  'nvimdev/guard.nvim',
  ft = _G.format_ft,
  config = tools.guard,
})

pack({ 'nvim-lua/plenary.nvim', lazy = true })
