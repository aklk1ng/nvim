local keymap = require('keymap')
local map = keymap.map
local opt = keymap.default_opt
local cmd = keymap.cmd
local toggle_option = keymap.toggle_option

local quickrun = require('utils.api.quickrun')
local flip_word = require('utils.api.flip-word')
local minifile = require('utils.api.minifiles')

map({
  ---------------------------- last command
  {
    'n',
    ';c',
    function()
      return [[@:]]
    end,
    { noremap = true, expr = true },
  },
  {
    'n',
    '<S-j>',
    function()
      return "mzJ'z"
    end,
    { noremap = true, expr = true },
  },
  -------------------------- friendly scroll
  {
    'n',
    '<C-d>',
    function()
      return '<C-d>zz'
    end,
    { noremap = true, expr = true },
  },
  {
    'n',
    '<C-u>',
    function()
      return '<C-u>zz'
    end,
    { noremap = true, expr = true },
  },

  {
    'i',
    '<C-e>',
    function()
      if vim.fn.pumvisible() == 1 then
        return '<C-e>'
      end
    end,
    { expr = true },
  },
  {
    'i',
    '<C-c>',
    '<Esc>',
    opt,
  },
  {
    'i',
    '<S-CR>',
    function()
      return '<CR><Esc>O'
    end,
    { noremap = true, expr = true },
  },
  {
    'i',
    '<C-/>',
    function()
      return '~'
    end,
    { noremap = true, expr = true },
  },
  -------------------------- add undo break-points
  {
    'i',
    ',',
    ',<C-g>u',
  },
  {
    'i',
    '.',
    '.<C-g>u',
  },
  {
    'i',
    ';',
    ';<C-g>u',
  },
  -------------------------- toggle the spell option with the global variable
  {
    'n',
    '<leader>us',
    function()
      toggle_option('o', 'spell')
    end,
    opt,
  },
  -------------------------- toggle the cursor highlight option with the global variable
  {
    'n',
    '<leader>c',
    function()
      toggle_option('g', 'cursor_moved_enabled')
    end,
    opt,
  },
  -------------------------- toggle the wrap
  {
    'n',
    '<leader>w',
    function()
      toggle_option('o', 'wrap')
    end,
    opt,
  },
  { 'n', '<leader>q', cmd('q'), opt },
  { 'n', '<C-q>', cmd('qa!'), opt },
  {
    'n',
    '<leader>x',
    cmd('!chmod +x %'),
    opt,
  },
  ---------------------------- for brackets
  { { 'n', 'v' }, ',.', '%', opt },
  --------------------------- change letter case
  { 'n', '<leader>,', '~', opt },
  { 'n', '\\', cmd('nohlsearch'), opt },
  --------------------------- remap
  { 'n', 'j', 'gj', opt },
  { 'n', 'k', 'gk', opt },

  { 'n', '<Tab>', 'za', opt },
  { 'i', '<Tab>', '<Tab>', opt },

  { 'i', '<C-s>', '<Esc>:w<CR>', opt },
  { 'n', '<C-s>', cmd('write'), opt },

  { { 'i', 'c' }, '<C-h>', '<Left>', opt },
  { { 'i', 'c' }, '<C-l>', '<Right>', opt },
  { 'i', '<C-f>', '<BS>', opt },

  { { 'n', 'v' }, '<', '<<<esc>', opt },
  { { 'n', 'v' }, '>', '>><esc>', opt },

  -------------------------- file preview
  { 'n', ',g', cmd('! google-chrome-stable % &'), opt },
  { 'n', ',s', cmd('! surf % &'), opt },

  -------------------------- window's map
  { 'n', 'te', cmd('tabnew'), opt },
  { 'n', '<leader>s', cmd('split'), opt },
  { 'n', '<leader>v', cmd('vsplit'), opt },
  { 'n', ';', '<C-w>w<CR>', opt },
  { 'n', '<leader>h', '<C-w>h<CR>', opt },
  { 'n', '<leader>j', '<C-w>j<CR>', opt },
  { 'n', '<leader>k', '<C-w>k<CR>', opt },
  { 'n', '<leader>l', '<C-w>l<CR>', opt },
  { 'n', '<C-h>', cmd('vertical resize+5'), opt },
  { 'n', '<C-l>', cmd('vertical resize-5'), opt },
  { 'n', '<C-k>', cmd('resize+5'), opt },
  { 'n', '<C-j>', cmd('resize-5'), opt },
  { 'n', '<leader>n', cmd('bnext'), opt },
  { 'n', '<leader>p', cmd('bprevious'), opt },

  -------------------------- directly move lines in visual mode
  { 'v', '<S-j>', ":m '>+1<CR>gv=gv", opt },
  { 'v', '<S-k>', ":m '<-2<CR>gv=gv", opt },

  -------------------------- some local plugin api keymap
  { 'n', '<leader>r', quickrun.QuickRun, opt },
  { 'n', 'ta', flip_word.toggleAlternate, opt },
  { 'n', '<leader>t', minifile.open, opt },
})