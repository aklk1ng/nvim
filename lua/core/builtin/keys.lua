_G.map('i', '<C-c>', '<Esc>')

-- Useful undo break-point
_G.map('i', ',', ',<C-g>u')
_G.map('i', '.', '.<C-g>u')
_G.map('i', ';', ';<C-g>u')

-- Black hole registers
_G.map({ 'n', 'x' }, 'x', '"_x')
_G.map({ 'n', 'x' }, 'X', '"_X')
_G.map({ 'n', 'x' }, 'c', '"_c')
_G.map({ 'n', 'x' }, 'C', '"_C')
_G.map({ 'n', 'x' }, 's', '"_s')
_G.map({ 'n', 'x' }, 'S', '"_S')

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
_G.map('n', '<leader><leader>g', function()
  vim.fn.system('xdg-open ' .. vim.fn.expand('%:p'))
end)

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
_G.map('n', '<leader>c', _G.cmd('tabclose'))
_G.map('n', '<Tab>', vim.cmd.bnext, { silent = true })
_G.map('n', '<S-Tab>', vim.cmd.bprev, { silent = true })
_G.map('n', '<leader>d', _G.cmd(vim.bo.buftype == 'terminal' and 'q!' or 'confirm bdelete'))

-- Toggle the quickfix window.
-- When toggling these, ignore error messages and restore the cursor to the original window when opening the list.
local silent_mods = { mods = { silent = true, emsg_silent = true } }
_G.map('n', '\\', function()
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

_G.map('n', '<leader><leader>i', function()
  local client = vim.lsp.get_clients({ bufnr = 0 })[1]
  if client and client.supports_method('textDocument/inlayHint', { bunr = 0 }) then
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
  end
end)
_G.map('n', '<leader>u', vim.diagnostic.hide)
_G.map('n', '<leader>i', vim.diagnostic.show)

-- Move lines
_G.map('x', '<A-j>', "<Esc><Cmd>'<,'>move'>+1<CR>gv=gv")
_G.map('x', '<A-k>', "<Esc><Cmd>'<,'>move'<-2<CR>gv=gv")

-- Better indenting
_G.map('x', '<', '<gv')
_G.map('x', '>', '>gv')

_G.map('c', '<C-b>', '<Left>')
_G.map('c', '<C-f>', '<Right>')
_G.map('c', '<C-a>', '<Home>')
_G.map('c', '<C-e>', '<End>')
_G.map('c', '<C-d>', '<Del>')
-- Cwd
_G.map('c', '%c', "<C-R>=expand('%:p:h')<CR>")
-- Filename
_G.map('c', '%t', "<C-R>=expand('%:t')<CR>")
-- Full path
_G.map('c', '%p', "<C-R>=expand('%:p')<CR>")
-- Terminal mappings
_G.map('t', '<A-Esc>', '<C-\\><C-n>')
_G.map('t', '<A-h>', '<C-\\><C-n><C-w>h')
_G.map('t', '<A-j>', '<C-\\><C-n><C-w>j')
_G.map('t', '<A-k>', '<C-\\><C-n><C-w>k')
_G.map('t', '<A-l>', '<C-\\><C-n><C-w>l')
