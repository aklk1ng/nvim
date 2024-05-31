local keymap = vim.keymap

_G.map = function(mode, lhs, rhs, opts)
  keymap.set(mode, lhs, rhs, opts)
end

_G.cmd = function(str)
  return '<cmd>' .. str .. '<CR>'
end

_G.map('i', '<C-c>', '<Esc>')
_G.map('i', ',', ',<C-g>u')
_G.map('i', '.', '.<C-g>u')
_G.map('i', ';', ';<C-g>u')
_G.map('i', '<C-a>', '<Esc>^i')
_G.map('i', '<C-e>', '<End>')

_G.map('n', 'x', '"_x')
_G.map('n', 'X', '"_X')
_G.map('n', 'c', '"_c')
_G.map('n', 'C', '"_C')
_G.map('n', 's', '"_s')
_G.map('n', 'S', '"_S')

_G.map('n', '\\', 'o<ESC>k')
_G.map('n', '<leader>q', _G.cmd('q'))
_G.map('n', '<C-q>', _G.cmd('qa!'))
_G.map('n', '<leader>x', _G.cmd('silent !chmod +x %'))
_G.map('n', '|', _G.cmd('Inspect'))
_G.map('n', 'j', 'gj')
_G.map('n', 'k', 'gk')
_G.map({ 'i', 'n', 'x', 's' }, '<C-s>', _G.cmd('silent! write') .. '<ESC>')
_G.map('n', '<', '<<')
_G.map('n', '>', '>>')
_G.map('n', '<ESC>', _G.cmd('nohlsearch'))
_G.map('n', '<leader><leader>g', _G.cmd('silent! google-chrome-stable % &'))

_G.map('n', '<leader>s', _G.cmd('split'))
_G.map('n', '<leader>v', _G.cmd('vsplit'))
_G.map('n', '<C-h>', '<C-w>h')
_G.map('n', '<C-j>', '<C-w>j')
_G.map('n', '<C-k>', '<C-w>k')
_G.map('n', '<C-l>', '<C-w>l')
_G.map('n', '<A-[>', '<C-w><')
_G.map('n', '<A-]>', '<C-w>>')
_G.map('n', '<A-,>', '<C-w>-')
_G.map('n', '<A-.>', '<C-w>+')
_G.map('n', '<A-->', _G.cmd('resize | vertical resize'))
_G.map('n', '<A-=>', '<C-w>=')
_G.map('n', '<leader>t', _G.cmd('tabnew'))
_G.map('n', '<leader>cc', _G.cmd('tabclose'))
_G.map('n', '<leader>n', _G.cmd('bnext'))
_G.map('n', '<leader>p', _G.cmd('bprevious'))
_G.map('n', '<leader>d', _G.cmd(vim.bo.buftype == 'terminal' and 'q!' or 'bdelete!'))

-- Toggle the quickfix window.
-- When toggling these, ignore error messages and restore the cursor to the original window when opening the list.
local silent_mods = { mods = { silent = true, emsg_silent = true } }
_G.map('n', '<leader>C', function()
  if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
    vim.cmd.cclose(silent_mods)
  elseif #vim.fn.getqflist() > 0 then
    local win = vim.api.nvim_get_current_win()
    vim.cmd.copen(silent_mods)
    if win ~= vim.api.nvim_get_current_win() then
      vim.cmd.wincmd('p')
    end
  end
end)
_G.map('n', '[q', _G.cmd('cprev'))
_G.map('n', ']q', _G.cmd('cnext'))

_G.map('n', '<leader><leader>i', function()
  local client = vim.lsp.get_clients({ bufnr = 0 })[1]
  if client and client.supports_method('textDocument/inlayHint', { bunr = 0 }) then
    vim.lsp.inlay_hint.enable(true)
  end
end)
_G.map('n', '<leader><leader>u', function()
  local client = vim.lsp.get_clients({ bufnr = 0 })[1]
  if client and client.supports_method('textDocument/inlayHint', { bunr = 0 }) then
    vim.lsp.inlay_hint.enable(false)
  end
end)
_G.map('n', '<leader>u', vim.diagnostic.hide)
_G.map('n', '<leader>i', vim.diagnostic.show)

-------------------------- better indenting
_G.map('x', '<', '<gv')
_G.map('x', '>', '>gv')

_G.map('x', 'x', '"_x')
_G.map('x', 'X', '"_X')
_G.map('x', 'c', '"_c')
_G.map('x', 'C', '"_C')
_G.map('x', 's', '"_s')
--------------------------- move line up or dow
_G.map('x', '<A-j>', ":m '>+1<CR>gv=gv")
_G.map('x', '<A-k>', ":m '<-2<CR>gv=gv")

_G.map('c', '<C-b>', '<Left>')
_G.map('c', '<C-f>', '<Right>')
_G.map('c', '<C-a>', '<Home>')
_G.map('c', '<C-e>', '<End>')
_G.map('c', '<C-d>', '<Del>')
-- cwd
_G.map('c', '%c', "<C-R>=expand('%:p:h')<CR>")
-- filename
_G.map('c', '%t', "<C-R>=expand('%:t')<CR>")
-- full path
_G.map('c', '%p', "<C-R>=expand('%:p')<CR>")

_G.map('t', '<A-Esc>', '<C-\\><C-n>')
_G.map('t', '<A-h>', '<C-\\><C-n><C-w>h')
_G.map('t', '<A-j>', '<C-\\><C-n><C-w>j')
_G.map('t', '<A-k>', '<C-\\><C-n><C-w>k')
_G.map('t', '<A-l>', '<C-\\><C-n><C-w>l')
