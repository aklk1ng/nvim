vim.g.mapleader = " "
-- Split to the right in vsplit
vim.o.splitright = true
-- Split to the bottom in split
vim.o.splitbelow = true
vim.o.writebackup = false
vim.o.hidden = true
vim.o.showmode = false
vim.o.showcmd = false
vim.o.cmdheight = 1
vim.o.ruler = false
vim.o.termguicolors = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.timeout = 100
vim.o.smartindent = true
vim.o.expandtab = true
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
vim.o.number = true
-- set mouse movement
vim.o.mouse = "a"
-- foldmethod
vim.o.foldlevelshart = 99
vim.o.foldmethod = "manual"
-- no automatic backup,no newline
vim.o.nobackup = true
vim.o.swapfile = false

vim.o.pumheight = 10

vim.o.updatetime = 100
vim.o.timeout = true
vim.o.timeoutlen = 400
vim.o.ttimeoutlen = 10
vim.o.redrawtime = 1500

-- highlight the search and delay
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.showmatch = true
vim.o.inccommand = "split"

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- share clipboard
vim.cmd([[
    set fileencodings =utf-8,ucs-bom,gbk,cp936,gb2312,gb18030
    set clipboard=unnamed
    set clipboard+=unnamedplus
]])

if vim.fn.has('nvim-0.9') == 1 then
    vim.opt.stc = '%{v:virtnum ? repeat(" ", float2nr(ceil(log10(v:lnum))))."↳":v:lnum}%=%s%C'
end

if vim.fn.executable('rg') == 1 then
    vim.opt.grepformat = '%f:%l:%c:%m,%f:%l:%m'
    vim.opt.grepprg = 'rg --vimgrep --no-heading --smart-case'
end
