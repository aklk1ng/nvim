local o, g = vim.opt, vim.g
local indent = 2

g.mapleader = ' '

o.splitright = true
o.splitbelow = true
o.splitkeep = 'screen'
o.writebackup = false
o.hidden = true
o.virtualedit = 'block'
o.showmode = false
o.showcmd = false
o.cmdheight = 0
o.ruler = false
o.termguicolors = true
o.tabstop = indent
o.shiftwidth = indent
o.shiftround = true
o.expandtab = true
o.cursorline = true
o.wrap = true
o.whichwrap = 'h,l,<,>,[,],~'
o.breakindentopt = 'shift:4'
o.breakindent = true
o.colorcolumn = '110'
o.textwidth = 110
o.laststatus = 3
o.scrolloff = 3
o.signcolumn = 'yes'
o.completeopt = 'menu,menuone,noselect'
o.copyindent = true
o.smartindent = true
o.cindent = true
o.number = true
-- actually there is no symbol to the left of number in my neovim
o.numberwidth = 2
o.mouse = 'a'
o.autochdir = true
o.exrc = true

o.list = true
o.listchars = 'tab:» ,nbsp:+,trail:·,extends:→,precedes:←,'

o.foldcolumn = '1'
o.foldmethod = 'manual'
o.foldenable = true
o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
o.foldlevelstart = 99

o.swapfile = false

o.mousemoveevent = true

o.pumblend = 10
o.pumheight = 15

o.updatetime = 400
o.timeout = true
o.timeoutlen = 400
o.ttimeoutlen = 10
o.redrawtime = 1500

o.wildignorecase = true
o.ignorecase = true
o.infercase = true
o.smartcase = true
o.clipboard = 'unnamedplus'
o.fileencodings = 'utf-8,ucs-bom,gbk,cp936,gb2312,gb18030'

o.stc = '%=%l%s'

if vim.fn.executable('rg') == 1 then
  vim.opt.grepformat = '%f:%l:%c:%m,%f:%l:%m'
  vim.opt.grepprg = 'rg --vimgrep --no-heading --smart-case'
end
