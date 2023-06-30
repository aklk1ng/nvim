local pack = require('core.pack').add_plugin
local tools = require('modules.tools')

pack({
  'glepnir/lspsaga.nvim',
  event = 'LspAttach',
  branch = 'main',
  config = tools.lspsaga,
})

pack({
  'folke/flash.nvim',
  keys = tools.flash,
})

pack({
  'kevinhwang91/nvim-ufo',
  event = { 'BufRead', 'BufNewFile' },
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
  'nvim-neo-tree/neo-tree.nvim',
  cmd = { 'NeoTreeFocusToggle', 'NeoTreeFloatToggle' },
  branch = 'v2.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'kyazdani42/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  config = tools.neotree,
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
  'mhartington/formatter.nvim',
  cmd = 'Format',
  config = tools.formatter,
})

pack({
  'numToStr/Comment.nvim',
  event = { 'BufRead', 'BufNewFile' },
  config = tools.comment,
})

pack({
  'nvimdev/indentmini.nvim',
  event = { 'BufRead', 'BufNewFile' },
  config = tools.indentmini,
})

pack({ 'nvim-lua/plenary.nvim', lazy = true })
