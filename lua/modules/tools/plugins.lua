local pack = require('core.pack').add_plugin
local tools = require('modules.tools')

pack({
  'nvimdev/lspsaga.nvim',
  ft = _G.lsp_ft,
  branch = 'main',
  config = tools.lspsaga,
})

pack({
  'folke/flash.nvim',
  keys = {
    {
      ';w',
      mode = { 'n', 'o', 'x' },
      function()
        require('flash').jump()
      end,
    },
  },
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
  'xeluxee/competitest.nvim',
  cmd = 'CompetiTest',
  dependencies = 'MunifTanjim/nui.nvim',
  config = tools.competitest,
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
  },
  config = tools.telescope,
})

pack({
  'nvimdev/dbsession.nvim',
  cmd = { 'SessionSave', 'SessionLoad', 'SessionDelete' },
  config = tools.dbsession,
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
  event = { 'BufRead', 'BufNewFile' },
  ft = _G.format_ft,
  config = tools.guard,
  dependencies = {
    'nvimdev/guard-collection',
  },
})

pack({ 'nvim-lua/plenary.nvim', lazy = true })
