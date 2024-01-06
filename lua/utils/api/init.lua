require('utils.api.stc').setup()
require('utils.api.fold')

local map = require('keymap')
local quickrun = require('utils.api.quickrun')
local flip_word = require('utils.api.flip-word')
local mini_files = require('utils.api.mini-files')
local im = require('utils.api.import')

map.n({
  [',r'] = im.run,
  ['<leader>r'] = quickrun.run,
  ['<leader>R'] = quickrun.run_file,
  ['ta'] = flip_word.toggle,
  ['<leader>t'] = function()
    if not _G.MiniFiles then
      mini_files.setup()
    end
    mini_files.open()
  end,
})
