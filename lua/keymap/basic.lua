local map = require('keymap')
local cmd = map.cmd

local quickrun = require('utils.api.quickrun')
local flip_word = require('utils.api.flip-word')
local mini_files = require('utils.api.mini-files')

map.i({
  ['<C-c>'] = '<Esc>',
  ['<S-CR>'] = '<CR>',
  [','] = ',<C-g>u',
  ['.'] = '.<C-g>u',
  [';'] = ';<C-g>u',
  [':'] = ':<C-g>u',
  ['<C-s>'] = '<Esc>:w<CR>',
  ['<C-h>'] = '<Left>',
  ['<C-l>'] = '<Right>',
  ['<C-a>'] = '<Esc>^i',
  ['<C-t>'] = '<C-o>d$',
})

map.n({
  ---------------------------- last command
  [';@'] = '@:',
  -------------------------- friendly scroll
  ['<C-d>'] = '<C-d>zz',
  ['<C-u>'] = '<C-u>zz',

  ['<leader>q'] = cmd('q'),
  ['<C-q>'] = cmd('qa!'),
  ['<leader>x'] = cmd('!chmod +x %'),
  ['<leader>cc'] = cmd('!rm ./%<'),
  ['?'] = cmd('Inspect'),
  [',.'] = '%',

  ['j'] = 'gj',
  ['k'] = 'gk',
  ['<Tab>'] = 'za',
  ['<C-s>'] = cmd('write'),
  ['<'] = '<<<esc>',
  ['>'] = '>><esc>',

  ['\\'] = cmd('nohlsearch'),
  [',g'] = cmd('! google-chrome-stable % &'),

  --------------------------- window
  ['<leader>s'] = cmd('split'),
  ['<leader>v'] = cmd('vsplit'),
  ['<C->h'] = '<C-w>h<CR>',
  ['<C->j'] = '<C-w>j<CR>',
  ['<C->k'] = '<C-w>k<CR>',
  ['<C->l'] = '<C-w>l<CR>',
  ['<A-[>'] = cmd('vertical resize-5'),
  ['<A-]>'] = cmd('vertical resize+5'),
  ['<A-C-]>'] = cmd('resize+5'),
  ['<A-C-[>'] = cmd('resize-5'),
  ['<leader>n'] = cmd('bnext'),
  ['<leader>p'] = cmd('bprevious'),
  ['<leader>d'] = cmd('bdelete'),

  -------------------------- local plugin api
  ['<leader>r'] = quickrun.run,
  ['<leader>R'] = quickrun.run_file,
  ['ta'] = flip_word.toggle,
  ['<leader>t'] = function()
    if not _G.MiniFiles then
      require('utils.api.mini-files').setup()
    end
    mini_files.open()
  end,

  -------------------------- built-in lua function
  ['<leader>i'] = cmd('lua vim.lsp.inlay_hint.enable(0, true)'),
  ['<leader>u'] = cmd('lua vim.lsp.inlay_hint.enable(0, false)'),
  [';u'] = cmd('lua vim.diagnostic.hide()'),
  [';i'] = cmd('lua vim.diagnostic.show()'),
})

map.x({
  [',.'] = '%',
  ['<'] = '<<<esc>',
  ['>'] = '>><esc>',

  --------------------------- move line up or down
  ['<A-j>'] = ":m '>+1<CR>gv=gv",
  ['<A-k>'] = ":m '<-2<CR>gv=gv",
})

map.c({
  ['<C-b>'] = '<Left>',
  ['<C-f>'] = '<Right>',
  ['<C-a>'] = '<Home>',
  ['<C-e>'] = '<End>',
  ['<C-h>'] = '<BS>',
})
