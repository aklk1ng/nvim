local pack = require('core.pack').add_plugin
local ui = require('modules.ui')

pack({
  'glepnir/dashboard-nvim',
  event = 'VimEnter',
  config = ui.dashboard,
})

pack({
  'NvChad/nvim-colorizer.lua',
  cmd = 'ColorizerToggle',
  config = ui.colorizer,
})

pack({
  'aklk1ng/whiskyline.nvim',
  dev = true,
  event = { 'BufRead', 'BufNewfile' },
  config = ui.whiskyline,
})

pack({ 'kyazdani42/nvim-web-devicons', lazy = true })
