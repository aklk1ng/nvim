require('profile')
require('mapping')
require('packer-init')
require('pack.lsp.setup')

local has = vim.fn.has
local is_mac = has "macunix"
local is_win = has "win32"

if is_mac then
  require('macos')
end
if is_win then
  require('windows')
end
