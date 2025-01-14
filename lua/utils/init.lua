local quickrun = require('utils.quickrun')
local flip_word = require('utils.flip-word')
local swap = require('utils.treesitter.swap')
local map = vim.keymap.set

require('utils.stl').setup()
require('utils.terminal')

map('n', 'ts', swap.act)
map('n', '<leader>r', quickrun.run)
map('n', 'ta', flip_word.toggle)

map({ 'n', 't' }, '<A-i>', function()
  _G.Terms.toggle({ float = true, id = 'Float Term' })
end)
map({ 'n', 't' }, '<C-x>]', function()
  _G.Terms.toggle({ id = 'VSP Term' })
end)
map({ 'n', 't' }, '<C-x>h', function()
  _G.Terms.hide()
end)
map({ 'n', 't' }, '<C-x>l', function()
  _G.Terms.resume()
end)
