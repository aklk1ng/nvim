vim.g.mapleader = " "
-- Split to the right in vsplit
vim.o.splitright = true
-- Split to the bottom in split
vim.o.splitbelow = true
vim.o.writebackup = false
vim.o.termguicolors = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.timeout = 100
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.relativenumber = true
vim.o.cursorline = true
-- Display long text in one line
vim.o.wrap = false
-- Add scrolloff for better zt/zb
vim.o.scrolloff = 5
-- Show sign column (e.g. lsp Error sign)
vim.o.signcolumn = "yes"
-- Better completion
vim.o.completeopt = "menu,menuone,noselect"
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.number = true



-- leap
require('leap').add_default_mappings()
--highlight the search result
require('leap').opts.highlight_unlabeled_phase_one_targets = true

-- vim-bookmarks
vim.cmd([[
    highlight BookmarkSign ctermbg=NONE ctermfg=160
    highlight BookmarkLine ctermbg=194 ctermfg=NONE
    let g:bookmark_sign = '♥'
    let g:bookmark_highlight_lines = 1
]])

vim.cmd([[
    let g:python3_host_prog = $PYTHON
]])

-- Highlight on yank
vim.cmd([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]])
-- prompt to remove extra spaces
vim.cmd([[
    hi ErrSpace ctermbg=238
    autocmd BufWinEnter * syn match Todo /TODO\(:.*\)*/
]])
-- cursor returns last position
vim.cmd([[ au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif ]])
-- vim save 1000 files
vim.cmd([[ set viminfo=!,'10000,<50,s10,h ]])
-- no automatic backup,no newline
vim.cmd([[
    set nobackup
    set noswapfile
    set nowrap
]])
-- set mouse movement
vim.cmd([[
    set mouse=a
    set selection=exclusive
]])
-- highlight the search and delay
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
-- share clipboard
vim.cmd([[
    set noshowcmd
    set updatetime=300
    set encoding=utf-8
    set fileencodings =utf-8,ucs-bom,gbk,cp936,gb2312,gb18030
    set wildmenu
    set pumheight=10
    set conceallevel=0
    set clipboard=unnamed
    set clipboard+=unnamedplus
]])
-- set the relativenumber automatically when i'm in insert or normal
vim.cmd([[
    augroup relative_numbers
    autocmd!
    autocmd InsertEnter * :set norelativenumber
    autocmd InsertLeave * :set relativenumber
    augroup END
]])
