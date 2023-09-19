local o, g = vim.o, vim.g
local indent = 2

g.mapleader = ' '
g.python3_host_prog = '/usr/bin/python'

-- Split to the right in vsplit
o.splitright = true
-- Split to the bottom in split
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
o.expandtab = true
o.cursorline = true
-- Display long text on the next line
o.wrap = true
o.whichwrap = 'h,l,<,>,[,],~'
o.breakindentopt = 'shift:2'
o.breakindent = true
o.textwidth = 110
o.colorcolumn = '110'
-- Add scrolloff for better zt/zb
o.scrolloff = 8
-- Show sign column (e.g. lsp Error sign)
o.signcolumn = 'yes'
-- Better completion
o.completeopt = 'menu,menuone,noselect'
o.copyindent = true
o.smartindent = true
o.cindent = true
o.number = true
-- set mouse movement
o.mouse = 'a'
-- foldmethod
o.foldcolumn = '1'
o.foldenable = true
o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
o.foldlevelstart = 99
o.swapfile = false

o.mousemoveevent = true

o.pumblend = 10
o.pumheight = 10

o.updatetime = 50
o.timeout = true
o.timeoutlen = 400
o.ttimeoutlen = 10
o.redrawtime = 1500

o.ignorecase = true
o.smartcase = true
o.showmatch = true
o.inccommand = 'split'
-- share clipboard
o.clipboard = 'unnamedplus'
o.fileencodings = 'utf-8,ucs-bom,gbk,cp936,gb2312,gb18030'

if vim.fn.executable('rg') == 1 then
  vim.opt.grepformat = '%f:%l:%c:%m,%f:%l:%m'
  vim.opt.grepprg = 'rg --vimgrep --no-heading --smart-case'
end

local os_name
if vim.version().prerelease then
  os_name = vim.uv.os_uname().sysname
else
  os_name = vim.loop.os_uname().sysname
end

if os_name == 'Darwin' then
elseif os_name == 'Darwin' then
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
end
