vim.loader.enable()

local g = vim.g
g.loaded_gzip = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_2html_plugin = 1
g.loaded_logiPat = 1
g.loaded_rrhelper = 1
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.did_install_default_menus = 1
-- Disable default providers.
for _, provider in ipairs({ 'python3', 'ruby', 'node', 'perl' }) do
  g['loaded_' .. provider .. '_provider'] = 0
end

g.mapleader = ' '

---@param str string
_G._cmd = function(str)
  return '<Cmd>' .. str .. '<CR>'
end

_G._augroup = vim.api.nvim_create_augroup('aklk1ng', { clear = true })

_G._cmp_kinds = {
  Text = '',
  Method = '',
  Function = '',
  Constructor = '',
  Field = '',
  Variable = '',
  Class = '',
  Interface = ' ',
  Module = '',
  Property = '',
  Unit = '',
  Value = '',
  Enum = '',
  Keyword = '',
  Snippet = '',
  Color = '',
  File = '',
  Reference = '',
  Folder = '',
  EnumMember = '',
  Constant = '',
  Struct = '',
  Event = '',
  Operator = '',
  TypeParameter = '',
}

local o = vim.o
local indent = 2

o.splitright = true
o.splitbelow = true
o.writebackup = false
o.virtualedit = 'block'
o.showmode = false
o.tabstop = indent
o.shiftwidth = indent
o.ruler = false
o.termguicolors = true
o.expandtab = true
o.cursorline = true
o.inccommand = 'split'
o.colorcolumn = '100'
o.scrolloff = 3
o.signcolumn = 'yes'
o.shortmess = 'loOTcCF'
o.number = true
o.relativenumber = true
o.numberwidth = 3
o.jumpoptions = 'stack,view'
o.mouse = 'a'
o.complete = '.,w,b,u,t,i,]'

o.list = true
o.listchars = 'tab:» ,nbsp:+,trail:·,extends:→,precedes:←,'

o.foldtext = ''
o.fillchars = 'eob: ,fold: ,foldopen:,foldsep: ,foldclose:,diff:╱'
o.foldlevel = 99
o.foldlevelstart = 99

o.pumheight = 15

o.updatetime = 800
o.timeoutlen = 500
o.ttimeoutlen = 10

o.wildignorecase = true
o.ignorecase = true
o.infercase = true
o.smartcase = true
o.swapfile = false
o.clipboard = 'unnamedplus'

o.stc = '%=%l%s'

require('vim._extui').enable({})

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

local au = vim.api.nvim_create_autocmd

au('FileType', {
  group = _G._augroup,
  pattern = { 'help', 'checkhealth', 'dashboard', 'qf', 'netrw' },
  callback = function(args)
    vim.keymap.set('n', 'q', _G._cmd('quit'), { buffer = args.buf, silent = true, nowait = true })
  end,
})

au('TextYankPost', {
  group = _G._augroup,
  callback = function()
    vim.hl.on_yank()
  end,
})

au('BufReadPost', {
  group = _G._augroup,
  callback = function()
    local pos = vim.fn.getpos('\'"')
    if pos[2] > 0 and pos[2] <= vim.fn.line('$') then
      vim.api.nvim_win_set_cursor(0, { pos[2], pos[3] - 1 })
      vim.api.nvim_input('zz')
    end
  end,
})

au({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = _G._augroup,
  callback = function()
    vim.cmd('checktime')
  end,
})

if vim.fn.executable('fcitx5-remote') == 1 then
  au('InsertLeavePre', {
    group = _G._augroup,
    callback = function()
      os.execute('fcitx5-remote -c')
    end,
  })
end

vim.cmd.colorscheme('aklk1ng')

local git = function(name)
  return 'https://github.com/' .. name
end

vim.pack.add({
  git('nvimdev/phoenix.nvim'),
  git('ibhagwan/fzf-lua'),
  { src = git('nvim-treesitter/nvim-treesitter'), version = 'main' },
  { src = git('nvim-treesitter/nvim-treesitter-textobjects'), version = 'main' },
  git('lewis6991/gitsigns.nvim'),
  git('stevearc/conform.nvim'),
  git('stevearc/oil.nvim'),
  git('uga-rosa/ccc.nvim'),
})

for _, plugin in ipairs(vim.pack.get()) do
  if plugin.active then
    local name = plugin.spec.name:gsub('%.nvim$', ''):gsub('^nvim%-', ''):gsub('%-nvim', '')
    pcall(require, 'plugins.' .. name)
  end
end
