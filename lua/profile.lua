local G = require('G')
vim.g.mapleader = " "
-- Lua
-- vim.cmd[[colorscheme tokyonight-night]]
-- Disable some default plugins
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_2html_plugin = 1

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1

-- Split to the right in vsplit
vim.o.splitright = true
-- Split to the bottom in split
vim.o.splitbelow = true
-- Enable mouse for any mode
vim.o.writebackup = false
vim.o.termguicolors = true
vim.o.tabstop = 5
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.smartindent = true
vim.o.expandtab = true
-- Show line number
vim.o.relativenumber = false
-- Highlight current line number
vim.o.cursorline = true
-- Display long text in one line
vim.o.wrap = false
-- Do not fold on default
vim.o.foldenable = false
-- Add scrolloff for better zt/zb
vim.o.scrolloff = 5
-- Show sign column (e.g. lsp Error sign)
vim.o.signcolumn = "yes"
-- Better completion
vim.o.completeopt = "menu,menuone,noselect"
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.number = true

vim.cmd([[
    let g:wildfire_objects = {
    \ "*" : ["i'", 'i"', "i)", "i]", "i}"],
    \ "html,xml" : ["at", "it"],
    \ }
]])
-- Highlight on yank
vim.cmd([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]])
-- 提示多余空格和TODO
vim.cmd([[
    hi ErrSpace ctermbg=238
    " autocmd BufWinEnter * syn match ErrSpace /\s\+$\| \+\ze\t\+\|\t\+\zs \+/
    autocmd BufWinEnter * syn match Todo /TODO\(:.*\)*/
]])
-- 光标回到上次位置
vim.cmd([[ au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif ]])
-- vim保存1000条文件记录
vim.cmd([[ set viminfo=!,'10000,<50,s10,h ]])
-- 不自动备份 不换行
vim.cmd([[
    set nobackup
    set noswapfile
    set nowrap
]])
-- 设置鼠标移动
vim.cmd([[
    set mouse=a
    set selection=exclusive
]])
-- 折叠
G.cmd([[
    set foldenable
    set foldmethod=manual
    set foldexpr=nvim_treesitter#foldexpr()
]])
-- 搜索高亮 空格+回车 去除匹配高亮 延迟
vim.cmd([[
    set hlsearch
    set showmatch
    noremap \ :nohlsearch<CR>
    set incsearch
    set inccommand=
    set ignorecase
    set smartcase
    set timeoutlen=400
]])
-- 设置命令提示 唯一标识 共享剪贴板
vim.cmd([[
    set showcmd
    set encoding=utf-8
    set wildmenu
    set pumheight=10
    set conceallevel=0
    set clipboard=unnamed
    set clipboard+=unnamedplus
]])
