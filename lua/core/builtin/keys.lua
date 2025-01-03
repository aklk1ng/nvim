_G.map('i', '<C-c>', '<C-c>')

-- Useful undo break-point
_G.map('i', ',', ',<C-g>u')
_G.map('i', '.', '.<C-g>u')
_G.map('i', ';', ';<C-g>u')

_G.map('i', '<C-l>', '<C-x><C-l>')

-- Black hole registers
_G.map({ 'n', 'x' }, 'x', '"_x')
_G.map({ 'n', 'x' }, 'X', '"_X')
_G.map({ 'n', 'x' }, 'c', '"_c')
_G.map({ 'n', 'x' }, 'C', '"_C')
_G.map({ 'n', 'x' }, 's', '"_s')
_G.map({ 'n', 'x' }, 'S', '"_S')

_G.map('n', '<C-x>f', ":e <C-R>=expand('%:p:~:h')<CR>")
_G.map('n', '<C-x>k', ':bdelete ')

_G.map('n', '<leader>q', _G.cmd('q'))
_G.map('n', '<C-x>c', _G.cmd('confirm qa'))
_G.map('n', '|', _G.cmd('Inspect'))
_G.map('n', 'j', 'gj')
_G.map('n', 'k', 'gk')
_G.map({ 'i', 'n', 'x', 's' }, '<C-s>', _G.cmd('silent! write') .. '<ESC>')
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
_G.map('n', '<leader>tn', _G.cmd('tab split'))
_G.map('n', '<leader>tc', _G.cmd('silent! tabclose'))
_G.map('n', '<leader>d', _G.cmd(vim.bo.buftype == 'terminal' and 'q!' or 'Bdelete'))
_G.map('n', '<C-q>', vim.diagnostic.setloclist)

_G.map('n', '<C-x>[', _G.cmd('vnew | term'))
_G.map('n', '<C-x>]', _G.cmd('new | resize-5 | term'))

-- Move lines
_G.map('x', '<A-j>', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv")
_G.map('x', '<A-k>', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv")

-- Toggle the quickfix window.
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
-- Toggle the location-list window.
_G.map('n', '<C-\\>', function()
  if vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 then
    vim.cmd.lclose(silent_mods)
  elseif #vim.fn.getloclist(0) > 0 then
    local win = vim.api.nvim_get_current_win()
    vim.cmd.lopen(silent_mods)
    if win ~= vim.api.nvim_get_current_win() then
      vim.cmd.wincmd('p')
    end
  end
end)

-- Toggle the inlayHint
_G.map('n', '<leader><leader>i', function()
  local client = vim.lsp.get_clients({ bufnr = 0 })[1]
  if client and client:supports_method('textDocument/inlayHint', 0) then
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
  end
end)

-- Better indenting
_G.map('x', '<', '<gv')
_G.map('x', '>', '>gv')

-- Inside a snippet, use backspace to remove the placeholder
_G.map('s', '<BS>', '<C-O>s')

_G.map('c', '<C-b>', '<Left>')
_G.map('c', '<C-f>', '<Right>')
_G.map('c', '<C-a>', '<Home>')
_G.map('c', '<C-e>', '<End>')
_G.map('c', '<C-d>', '<Del>')
-- Cwd
_G.map('c', '%c', "<C-R>=expand('%:p:~:h')<CR>")
-- Filename
_G.map('c', '%t', "<C-R>=expand('%:t')<CR>")
-- Full path
_G.map('c', '%p', "<C-R>=expand('%:p:~')<CR>")
-- Terminal mappings
_G.map('t', '<A-Esc>', '<C-\\><C-n>')
_G.map('t', '<A-h>', '<C-\\><C-n><C-w>h')
_G.map('t', '<A-j>', '<C-\\><C-n><C-w>j')
_G.map('t', '<A-k>', '<C-\\><C-n><C-w>k')
_G.map('t', '<A-l>', '<C-\\><C-n><C-w>l')
