-- enable lua byte code caching
if vim.loader then
  vim.loader.enable()
end

local g = vim.g
-- disable_distribution_plugins
g.loaded_gzip = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_2html_plugin = 1
g.loaded_logiPat = 1
g.loaded_rrhelper = 1
g.loaded_matchit = 1
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
-- disable default providers
for _, provider in ipairs({ 'python3', 'ruby', 'node', 'perl' }) do
  g['loaded_' .. provider .. '_provider'] = 0
end

g.mapleader = ' '

vim.cmd.colorscheme('aklk1ng')
require('core.builtin')
require('core.pack'):boot_strap()
