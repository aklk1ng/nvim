local quickrun = require('utils.quickrun')
local flip_word = require('utils.flip-word')
local swap = require('utils.treesitter.swap')
local select = require('utils.treesitter.select')
require('utils.stl').setup()
require('utils.terminal')
require('utils.input')
require('utils.qf')

_G.map('n', 'ts', swap.act)
_G.map({ 'x', 'o' }, 'if', function()
  select.act('function', false)
end)
_G.map({ 'x', 'o' }, 'af', function()
  select.act('function', true)
end)
_G.map({ 'x', 'o' }, 'ic', function()
  select.act('class', false)
end)
_G.map({ 'x', 'o' }, 'ac', function()
  select.act('class', true)
end)
_G.map({ 'x', 'o' }, 'il', function()
  select.act('loop', false)
end)
_G.map({ 'x', 'o' }, 'al', function()
  select.act('loop', true)
end)

_G.map('n', '<leader>r', quickrun.run)
_G.map('n', 'ta', flip_word.toggle)

_G.map({ 'n', 't' }, '<A-i>', function()
  _G.Terms.toggle({ pos = 'float', id = 'floatTerm' })
end, { desc = 'terminal toggle floating term' })
