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
o.showcmd = false
o.ruler = false
o.termguicolors = true
o.shiftround = true
o.expandtab = true
o.cursorline = true
o.inccommand = 'split'
o.whichwrap = 'h,l,<,>,[,],~'
o.breakindentopt = 'shift:4'
o.breakindent = true
o.linebreak = true
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
o.numberwidth = 3
o.mouse = 'a'

o.list = true
o.listchars = 'tab:» ,nbsp:+,trail:·,extends:→,precedes:←,'

o.foldcolumn = '1'
o.foldtext = ''
o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
o.foldmethod = 'expr'
o.fillchars = 'eob: ,fold: ,foldopen:,foldsep: ,foldclose:'
o.foldlevel = 99
o.foldlevelstart = 99

o.swapfile = false

o.pumblend = 10
o.pumheight = 15

o.updatetime = 400
o.timeoutlen = 500
o.ttimeoutlen = 10
o.redrawtime = 1500

o.wildignorecase = true
o.wildignore = '.hg,.svn,*~,*.png,*.jpg,*.gif,*.min.js,*.swp,*.o,vendor,dist,_site'
o.ignorecase = true
o.infercase = true
o.smartcase = true
o.clipboard = 'unnamedplus'

o.stc = '%=%l%s'

if vim.fn.executable('rg') == 1 then
  o.grepformat = '%f:%l:%c:%m,%f:%l:%m'
  o.grepprg = 'rg --vimgrep --no-heading --smart-case'
end
