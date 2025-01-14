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
o.laststatus = 3
o.scrolloff = 5
o.signcolumn = 'yes'
o.shortmess = 'loOTcCF'
o.completeopt = 'menu,menuone,noselect,fuzzy,popup'
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
