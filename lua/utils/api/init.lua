require('utils.api.stl').setup()
require('utils.api.fold')

local map = require('keymap')
local quickrun = require('utils.api.quickrun')
local flip_word = require('utils.api.flip-word')
local im = require('utils.api.import')

map.n({
  [',r'] = im.run,
  ['<leader>r'] = quickrun.run,
  ['<leader>R'] = quickrun.run_file,
  ['ta'] = flip_word.toggle,
})
