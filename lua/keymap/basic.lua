local map = require('keymap')
local cmd = map.cmd

map.i({
  ['<C-c>'] = '<Esc>',
  ['<S-CR>'] = '<CR>',
  [','] = ',<C-g>u',
  ['.'] = '.<C-g>u',
  [';'] = ';<C-g>u',
  [':'] = ':<C-g>u',
  ['<C-s>'] = '<Esc>:silent! w<CR>',
  ['<C-h>'] = '<Left>',
  ['<C-l>'] = '<Right>',
  ['<C-a>'] = '<Esc>^i',
  ['<C-t>'] = '<C-o>d$',
})

map.n({
  ['x'] = '"_x',
  ['X'] = '"_X',
  ['c'] = '"_c',
  ['C'] = '"_C',
  ['s'] = '"_s',
  ['S'] = '"_S',
  -------------------------- friendly scroll
  ['<C-d>'] = '<C-d>zz',
  ['<C-u>'] = '<C-u>zz',

  ['<leader>q'] = cmd('q'),
  ['<C-q>'] = cmd('qa!'),
  ['<leader>x'] = cmd('!chmod +x %'),
  ['<leader>cc'] = cmd('!rm ./%<'),
  ['|'] = cmd('Inspect'),

  ['j'] = 'gj',
  ['k'] = 'gk',
  ['<C-s>'] = cmd('silent! write'),
  ['<'] = '<<<esc>',
  ['>'] = '>><esc>',

  ['\\'] = cmd('nohlsearch'),
  [',g'] = cmd('! google-chrome-stable % &'),

  --------------------------- window
  ['<leader>s'] = cmd('split'),
  ['<leader>v'] = cmd('vsplit'),
  ['<C-h>'] = '<C-w>h<CR>',
  ['<C-j>'] = '<C-w>j<CR>',
  ['<C-k>'] = '<C-w>k<CR>',
  ['<C-l>'] = '<C-w>l<CR>',
  ['<A-[>'] = cmd('vertical resize-5'),
  ['<A-]>'] = cmd('vertical resize+5'),
  ['<A-C-]>'] = cmd('resize+5'),
  ['<A-C-[>'] = cmd('resize-5'),
  ['<leader>n'] = cmd('bnext'),
  ['<leader>p'] = cmd('bprevious'),
  ['<leader>d'] = cmd(vim.bo.buftype == 'terminal' and 'q!' or 'bdelete!'),
  ['[t'] = cmd('vs new | vertical resize -5 | terminal'),
  [']t'] = cmd('set splitbelow | sp new | set nosplitbelow | resize -5 | terminal'),

  ['<leader><leader>i'] = function()
    local client = vim.lsp.get_clients({ bufnr = 0 })[1]
    if client and client.supports_method('textDocument/inlayHint', { bunr = 0 }) then
      vim.lsp.inlay_hint.enable(0, true)
    end
  end,
  ['<leader><leader>u'] = function()
    local client = vim.lsp.get_clients({ bufnr = 0 })[1]
    if client and client.supports_method('textDocument/inlayHint', { bunr = 0 }) then
      vim.lsp.inlay_hint.enable(0, false)
    end
  end,
  [';u'] = cmd('lua vim.diagnostic.hide()'),
  [';i'] = cmd('lua vim.diagnostic.show()'),
})

map.x({
  ['<'] = '<<<esc>',
  ['>'] = '>><esc>',

  ['x'] = '"_x',
  ['X'] = '"_X',
  ['c'] = '"_c',
  ['C'] = '"_C',
  ['s'] = '"_s',

  --------------------------- move line up or down
  ['<A-j>'] = ":m '>+1<CR>gv=gv",
  ['<A-k>'] = ":m '<-2<CR>gv=gv",
})

map.c({
  ['<C-j>'] = '<Left>',
  ['<C-k>'] = '<Right>',
  ['<C-a>'] = '<Home>',
  ['<C-e>'] = '<End>',
  ['<C-h>'] = '<BS>',
})
