local map = vim.keymap.set

-- Useful undo break-point
map('i', ',', ',<C-g>u')
map('i', '.', '.<C-g>u')
map('i', ';', ';<C-g>u')

map(
  'i',
  '<C-x>t',
  [[<C-R>=repeat(complete(col('.'),map(["%Y-%m-%d %H:%M:%S","%a, %d %b %Y %H:%M:%S %z","%Y %b %d","%a %b %d %T %Z %Y","%Y%m%d"],'strftime(v:val)')),0)<CR>]],
  { silent = true, noremap = true, desc = 'Provide formatted datetime in completion menu' }
)

map({ 'n', 'x' }, 'x', '"_x')
map({ 'n', 'x' }, 'X', '"_X')
map({ 'n', 'x' }, 'c', '"_c')
map({ 'n', 'x' }, 'C', '"_C')
map({ 'n', 'x' }, 's', '"_s')
map({ 'n', 'x' }, 'S', '"_S')

map('n', '<leader>q', _G._cmd('q'))
map('n', '<C-x>c', _G._cmd('confirm qa'))
map('n', '|', _G._cmd('Inspect'))
map('n', 'j', 'gj')
map('n', 'k', 'gk')
map('n', 'gV', '`[v`]')
map({ 'i', 'n', 'x', 's' }, '<C-s>', _G._cmd('silent! write') .. '<ESC>')
map('n', '<ESC>', _G._cmd('nohlsearch'))
map('n', '<C-x><C-f>', ":e <C-R>=expand('%:p:~:h')<CR>")
map('n', '<C-x>k', ':bdelete ')
map('n', '<C-x>d', ':e ~/')

map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')
map('n', '<A-[>', '<C-w><')
map('n', '<A-]>', '<C-w>>')
map('n', '<A-,>', '<C-w>-')
map('n', '<A-.>', '<C-w>+')
map('n', '<A-->', _G._cmd('resize | vertical resize'))
map('n', '<leader>d', _G._cmd(vim.bo.buftype == 'terminal' and 'q!' or 'Bdelete'))
map('n', '<C-q>', function()
  vim.diagnostic.setloclist({ title = vim.fn.expand('%') })
end)

-- Move lines
map('x', '<A-j>', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv")
map('x', '<A-k>', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv")

local silent_mods = { mods = { silent = true, emsg_silent = true } }
map('n', '\\', function()
  if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
    vim.cmd.cclose(silent_mods)
  elseif #vim.fn.getqflist() > 0 then
    local win = vim.api.nvim_get_current_win()
    vim.cmd.copen(silent_mods)
    if win ~= vim.api.nvim_get_current_win() then
      vim.cmd.wincmd('p')
    end
  end
end, { desc = 'Toggle the quickfix window' })
map('n', '<C-\\>', function()
  if vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 then
    vim.cmd.lclose(silent_mods)
  elseif #vim.fn.getloclist(0) > 0 then
    local win = vim.api.nvim_get_current_win()
    vim.cmd.lopen(silent_mods)
    if win ~= vim.api.nvim_get_current_win() then
      vim.cmd.wincmd('p')
    end
  end
end, { desc = 'Toggle the location-list window' })

map({ 'n', 'i' }, '<A-/>', function()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  vim.cmd('normal! yyp')
  vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], col })
end, { desc = 'Duplicate one line and keep the cursor column position' })

-- Better indenting
map('x', '<', '<gv')
map('x', '>', '>gv')

map('n', 'gX', function()
  vim.ui.open(('https://google.com/search?q=%s'):format(vim.fn.expand('<cword>')))
end)
map('x', 'gX', function()
  local lines = vim.fn.getregion(vim.fn.getpos('.'), vim.fn.getpos('v'), { type = vim.fn.mode() })
  vim.ui.open(('https://google.com/search?q=%s'):format(vim.trim(table.concat(lines, ' '))))
  vim.api.nvim_input('<ESC>')
end)

map('c', '<C-b>', '<Left>')
map('c', '<C-f>', '<Right>')
map('c', '<C-a>', '<Home>')
map('c', '<A-b>', '<C-Left>')
map('c', '<A-f>', '<C-Right>')
map('c', '<C-e>', '<End>')
map('c', '%c', "expand('%:p:~:h')", { desc = 'Cwd' })
map('c', '%p', "expand('%:p:~')", { desc = 'Full path' })
-- Terminal mappings
map('t', '<A-Esc>', '<C-\\><C-n>')
map('t', '<A-h>', '<C-\\><C-n><C-w>h')
map('t', '<A-j>', '<C-\\><C-n><C-w>j')
map('t', '<A-k>', '<C-\\><C-n><C-w>k')
map('t', '<A-l>', '<C-\\><C-n><C-w>l')
