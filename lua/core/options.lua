vim.g.mapleader = " "
-- Split to the right in vsplit
vim.o.splitright = true
-- Split to the bottom in split
vim.o.splitbelow = true
vim.o.writebackup = false
vim.o.hidden = true
vim.o.showmode = false
vim.o.showcmd = false
vim.o.ruler = false
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

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- vim-bookmarks
vim.cmd([[
    highlight BookmarkSign ctermbg=NONE ctermfg=160
    highlight BookmarkLine ctermbg=194 ctermfg=NONE
    let g:bookmark_sign = '♥'
    let g:bookmark_highlight_lines = 1
]])

-- vim-cmake
vim.cmd([[
    let g:cmake_link_compile_commands = 1
]])

-- foldmethod
vim.cmd([[
    set foldmethod=manual
    set nofoldenable
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

-- vim-dadbod-completion
vim.cmd([[
  autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
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
    set updatetime=100
    set encoding=utf-8
    set fileencodings =utf-8,ucs-bom,gbk,cp936,gb2312,gb18030
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

if vim.loop.os_uname().sysname == 'Darwin' then
    vim.g.clipboard = {
        name = 'macOS-clipboard',
        copy = {
            ['+'] = 'pbcopy',
            ['*'] = 'pbcopy',
        },
        paste = {
            ['+'] = 'pbpaste',
            ['*'] = 'pbpaste',
        },
        cache_enabled = 0,
    }
    vim.g.python_host_prog = '/usr/bin/python'
    vim.g.python3_host_prog = '/usr/local/bin/python3'
end
