local opt = vim.opt
local indent = 2

opt.fileencoding = 'utf-8'
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = 'screen'
opt.writebackup = false
opt.virtualedit = 'block'
opt.showmode = false
opt.tabstop = indent
opt.shiftwidth = indent
opt.showcmd = false
opt.cmdheight = 0
opt.ruler = false
opt.termguicolors = true
opt.shiftround = true
opt.expandtab = true
opt.cursorline = true
opt.inccommand = 'split'
opt.whichwrap = 'h,l,<,>,[,],~'
opt.breakindentopt = 'shift:4'
opt.breakindent = true
opt.textwidth = 100
opt.colorcolumn = '100'
opt.laststatus = 3
opt.scrolloff = 5
opt.signcolumn = 'yes'
opt.completeopt = 'menu,menuone,noselect,popup'
opt.copyindent = true
opt.smartindent = true
opt.cindent = true
opt.number = true
-- actually there is no symbol to the left of number in my neovim
opt.numberwidth = 2
opt.mouse = 'a'
opt.exrc = true

opt.list = true
opt.listchars = 'tab:» ,nbsp:+,trail:·,extends:→,precedes:←,'

opt.foldcolumn = '1'
opt.foldmethod = 'expr'
opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
opt.foldtext = ''
opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
opt.foldlevel = 99
opt.foldlevelstart = 99

opt.swapfile = false

opt.pumblend = 10
opt.pumheight = 15

opt.updatetime = 400
opt.timeoutlen = 500
opt.ttimeoutlen = 10
opt.redrawtime = 1500

opt.wildignorecase = true
opt.ignorecase = true
opt.infercase = true
opt.smartcase = true
opt.clipboard = 'unnamedplus'

opt.stc = '%=%l%s'

if vim.fn.executable('rg') == 1 then
  vim.opt.grepformat = '%f:%l:%c:%m,%f:%l:%m'
  vim.opt.grepprg = 'rg --vimgrep --no-heading --smart-case'
end
