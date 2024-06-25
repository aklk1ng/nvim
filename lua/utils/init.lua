local quickrun = require('utils.quickrun')
local flip_word = require('utils.flip-word')
local swap = require('utils.treesitter.swap')
local select = require('utils.treesitter.select')
local func_jump = require('utils.treesitter.func_jump')
-- require('utils.cursorword')
require('utils.stl').setup()
require('utils.notify')
vim.defer_fn(function()
  require('utils.select')
  require('utils.root')
end, 1000)
require('utils.terminal')

_G.map('n', 'ts', swap.swap)
_G.map('x', 'if', function()
  select.select('function', false)
end)
_G.map('x', 'af', function()
  select.select('function', true)
end)
_G.map('x', 'ic', function()
  select.select('class', false)
end)
_G.map('x', 'ac', function()
  select.select('class', true)
end)
_G.map('x', 'il', function()
  select.select('loop', false)
end)
_G.map('x', 'al', function()
  select.select('loop', true)
end)
_G.map({ 'n', 'x' }, '[f', function()
  func_jump.jump_prev_func()
end)
_G.map({ 'n', 'x' }, ']f', function()
  func_jump.jump_next_func()
end)
_G.map({ 'n', 'x' }, '[c', function()
  func_jump.jump_prev_class()
end)
_G.map({ 'n', 'x' }, ']c', function()
  func_jump.jump_next_class()
end)

_G.map('n', '<leader>r', quickrun.run)
_G.map('n', 'ta', flip_word.toggle)

-- toggleable
_G.map({ 'n', 't' }, '[t', function()
  _G.Terms.toggle({ pos = 'vsp', id = 'vtoggleTerm' })
end, { desc = 'terminal toggleable vertical term' })

_G.map({ 'n', 't' }, ']t', function()
  _G.Terms.toggle({ pos = 'sp', id = 'htoggleTerm' })
end, { desc = 'terminal new horizontal term' })

_G.map({ 'n', 't' }, '<A-i>', function()
  _G.Terms.toggle({ pos = 'float', id = 'floatTerm' })
end, { desc = 'terminal toggle floating term' })
