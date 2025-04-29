if vim.loader then
  vim.loader.enable()
end

local g = vim.g
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
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.did_install_default_menus = 1
-- Disable default providers.
for _, provider in ipairs({ 'python3', 'ruby', 'node', 'perl' }) do
  g['loaded_' .. provider .. '_provider'] = 0
end

g.mapleader = ' '

---@param str string
_G._cmd = function(str)
  return '<Cmd>' .. str .. '<CR>'
end

_G._augroup = vim.api.nvim_create_augroup('aklk1ng', { clear = true })

_G._cmp_kinds = {
  Text = '',
  Method = '',
  Function = '',
  Constructor = '',
  Field = '',
  Variable = '',
  Class = '',
  Interface = ' ',
  Module = '',
  Property = '',
  Unit = '',
  Value = '',
  Enum = '',
  Keyword = '',
  Snippet = '',
  Color = '',
  File = '',
  Reference = '',
  Folder = '',
  EnumMember = '',
  Constant = '',
  Struct = '',
  Event = '',
  Operator = '',
  TypeParameter = '',
}

vim.cmd.colorscheme('aklk1ng')
local plugins = vim.fn.stdpath('data') .. '/site/pack/plugins/opt'
local handle = assert(vim.uv.fs_opendir(plugins, nil, 4096))
local entries = vim.uv.fs_readdir(handle, nil)
if not entries then
  return
end
for _, t in ipairs(entries) do
  if t.type == 'directory' then
    vim.cmd.packadd(t.name)
  end
end
vim.cmd.helptags('ALL')
require('plugins')
