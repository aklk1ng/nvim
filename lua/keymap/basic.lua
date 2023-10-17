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
  { 'n', ';c', '@:', opt },
  -------------------------- friendly scroll
  { 'n', '<C-d>', '<C-d>zz', opt },
  { 'n', '<C-u>', '<C-u>zz', opt },
  -------------------------- select all
  { 'n', ';a', 'ggVG', opt },

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
  { 'i', '<C-c>', '<Esc>', opt },
  { 'i', '<S-CR>', '<CR><Esc>O', opt },
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
  { 'n', '<leader>cc', cmd('!rm ./%<'), opt },
  -------------------------- add undo break-points
  { 'i', ',', ',<C-g>u', opt },
  { 'i', '.', '.<C-g>u', opt },
  { 'i', ';', ';<C-g>u', opt },
  ---------------------------- for brackets
  { { 'n', 'v' }, ',.', '%', opt },

  --------------------------- useful remap
  { 'n', 'j', 'gj', opt },
  { 'n', 'k', 'gk', opt },

  { 'n', '<Tab>', 'za', opt },
  { 'i', '<Tab>', '<Tab>', opt },

  { 'i', '<C-s>', '<Esc>:w<CR>', opt },
  { 'n', '<C-s>', cmd('write'), opt },

  { { 'i', 'c' }, '<C-h>', '<Left>', opt },
  { { 'i', 'c' }, '<C-l>', '<Right>', opt },
  { 'i', '<C-a>', '<esc>^i', opt },
  { 'i', '<C-t>', '<C-o>d$', opt },

  { { 'n', 'v' }, '<', '<<<esc>', opt },
  { { 'n', 'v' }, '>', '>><esc>', opt },

  { 'n', '\\', cmd('nohlsearch'), opt },
  -------------------------- file preview
  { 'n', ',g', cmd('! google-chrome-stable % &'), opt },

  -------------------------- window's map
  { 'n', 'te', cmd('tabnew'), opt },
  { 'n', '<leader>s', cmd('split'), opt },
  { 'n', '<leader>v', cmd('vsplit'), opt },
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
  { 'n', '<leader>d', cmd('bdelete'), opt },

  -------------------------- directly move lines in visual mode
  { 'v', '<C-j>', ":m '>+1<CR>gv=gv", opt },
  { 'v', '<C-k>', ":m '<-2<CR>gv=gv", opt },

  -------------------------- some local plugin api keymap
  { 'n', '<leader>r', quickrun.QuickRun, opt },
  { 'n', 'ta', flip_word.toggleAlternate, opt },
  { 'n', '<leader>t', minifile.open, opt },

  -------------------------- built-in lua function
  { 'n', '<leader>i', cmd('lua vim.lsp.inlay_hint(0, true)'), opt },
  { 'n', '<leader>u', cmd('lua vim.lsp.inlay_hint(0, false)'), opt },
  { 'n', ';u', cmd('lua vim.diagnostic.hide()'), opt },
  { 'n', ';i', cmd('lua vim.diagnostic.show()'), opt },
})
