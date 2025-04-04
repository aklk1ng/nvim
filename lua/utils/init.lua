local quickrun = require('utils.quickrun')
local swap = require('utils.treesitter.swap')
local map = vim.keymap.set

require('utils.stl').setup()

map('n', 'ts', swap.act)
map('n', '<leader>r', quickrun.run)
