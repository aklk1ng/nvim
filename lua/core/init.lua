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
g.loaded_matchit = 1
g.loaded_2html_plugin = 1
g.loaded_logiPat = 1
g.loaded_rrhelper = 1
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_netrwSettings = 1
g.loaded_netrwFileHandlers = 1

_G.lsp_ft = {
  'c',
  'cpp',
  'cmake',
  'python',
  'go',
  'rust',
  'lua',
  'typescript',
  'markdown',
  'sh',
  'zig',
  'html',
  'css',
  'json',
  'jsonc',
}

local programs = {
  'git',
  'node',
  'yarn',
  'npm',
  'python',
  'python3',
}
local found = true
for _, program in ipairs(programs) do
  if vim.fn.executable(program) ~= 1 then
    found = false
  end
  if not found then
    print('Check the environment!')
    break
  end
end
if found then
  require('utils.colorscheme').colorscheme()
  require('core.options')
  require('keymap.basic')
  require('utils.api.searchcount')
  require('core.pack'):boot_strap()
  require('core.event')
  require('keymap.modules')
end
