local map = require('keymap')
local cmd = map.cmd

map.i({
  ['<C-c>'] = '<Esc>',
  ['<S-CR>'] = '<CR>',
  [','] = ',<C-g>u',
  ['.'] = '.<C-g>u',
  ['<C-s>'] = '<Esc>:silent! write<CR>',
  ['<C-h>'] = '<Left>',
  ['<C-l>'] = '<Right>',
  ['<C-a>'] = '<Esc>^i',
  ['<C-e>'] = '<End>',
  ['<C-t>'] = '<C-o>d$',
})

map.n({
  ['x'] = '"_x',
  ['X'] = '"_X',
  ['c'] = '"_c',
  ['C'] = '"_C',
  ['s'] = '"_s',
  ['S'] = '"_S',
  -- paste with correct indent
  ['p'] = function()
    local text = vim.fn.getreg('"')
    -- if have mulitple \n assume before copy from the visual mode
    local count = #vim.split(text, '\n', { trimempty = true })
    vim.cmd('normal! ' .. ('p%s'):format((count == 1 and '==' or ('v%sj=='):format(count))))
  end,

  ['?'] = 'o<ESC>k',
  ['<leader>q'] = cmd('q'),
  ['<C-q>'] = cmd('qa!'),
  ['<leader>x'] = cmd('silent !chmod +x %'),
  ['<leader>C'] = cmd('silent !rm ./%<'),
  ['|'] = cmd('Inspect'),

  ['j'] = 'gj',
  ['k'] = 'gk',
  ['<C-s>'] = cmd('silent! write'),
  ['<'] = '<<',
  ['>'] = '>>',

  ['\\'] = cmd('nohlsearch'),
  [',g'] = cmd('silent ! google-chrome-stable % &'),

  ['<leader>s'] = cmd('split'),
  ['<leader>v'] = cmd('vsplit'),
  ['<C-h>'] = '<C-w>h',
  ['<C-j>'] = '<C-w>j',
  ['<C-k>'] = '<C-w>k',
  ['<C-l>'] = '<C-w>l',
  ['<A-[>'] = '<C-w><',
  ['<A-]>'] = '<C-w>>',
  ['<A-,>'] = '<C-w>-',
  ['<A-.>'] = '<C-w>+',
  ['<leader>t'] = cmd('tabnew'),
  ['<leader>c'] = cmd('tabclose'),
  ['<leader>n'] = cmd('bnext'),
  ['<leader>p'] = cmd('bprevious'),
  ['<leader>d'] = cmd(vim.bo.buftype == 'terminal' and 'q!' or 'bdelete!'),
  ['[t'] = cmd('vs new | vertical resize -5 | terminal'),
  [']t'] = cmd('set splitbelow | sp new | set nosplitbelow | resize -5 | terminal'),

  -------------------------- built-in lua api
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
  [';u'] = vim.diagnostic.hide,
  [';i'] = vim.diagnostic.show,
})

map.x({
  -------------------------- better indenting
  ['<'] = '<gv',
  ['>'] = '>gv',

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
  ['<C-b>'] = '<Left>',
  ['<C-f>'] = '<Right>',
  ['<C-a>'] = '<Home>',
  ['<C-e>'] = '<End>',
  ['<C-h>'] = '<C-Left>',
  ['<C-l>'] = '<C-Right>',
  ['<C-o>'] = '<BS>',
  -- pwd
  ['%d'] = "<C-R>=expand('%:p:h')<CR>",
  -- filename
  ['%t'] = "<C-R>=expand('%:t')<CR>",
  -- full path
  ['%p'] = "<C-R>=expand('%:p')<CR>",
})

map.t({
  ['<A-Esc>'] = '<C-\\><C-n>',
  -- easy moving between terminal and buffers
  ['<A-h>'] = '<C-\\><C-n><C-w>h',
  ['<A-j>'] = '<C-\\><C-n><C-w>j',
  ['<A-k>'] = '<C-\\><C-n><C-w>k',
  ['<A-l>'] = '<C-\\><C-n><C-w>l',
})
