local o = vim.o
local indent = 2

o.fileencoding = 'utf-8'
o.splitright = true
o.splitbelow = true
o.splitkeep = 'screen'
o.writebackup = false
o.virtualedit = 'block'
o.showmode = false
o.tabstop = indent
o.shiftwidth = indent
o.showcmd = true
o.ruler = false
o.termguicolors = true
o.shiftround = true
o.expandtab = true
o.cursorline = true
o.inccommand = 'split'
o.breakindentopt = 'shift:4'
o.breakindent = true
o.colorcolumn = '100'
o.laststatus = 3
o.scrolloff = 5
o.signcolumn = 'yes'
o.shortmess = 'aoOTcF'
o.completeopt = 'menu,menuone,noselect,fuzzy,popup'
o.copyindent = true
o.smartindent = true
o.cindent = true
o.number = true
o.relativenumber = true
o.numberwidth = 3
o.jumpoptions = 'stack,view'
o.mouse = 'a'

o.list = true
o.listchars = 'tab:» ,nbsp:+,trail:·,extends:→,precedes:←,'

o.foldtext = ''
o.fillchars = 'eob: ,fold: ,foldopen:,foldsep: ,foldclose:,diff:╱'
o.foldlevel = 99
o.foldlevelstart = 99

o.pumheight = 15

o.updatetime = 400
o.timeoutlen = 500
o.ttimeoutlen = 10

o.wildignorecase = true
o.ignorecase = true
o.infercase = true
o.smartcase = true
o.swapfile = false
o.clipboard = 'unnamedplus'

o.stc = '%=%l%s'
