-- enable lua byte code caching
vim.loader.enable()

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
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

local function check()
  local cmds = {
    'git',
    'python3',
  }
  for _, cmd in ipairs(cmds) do
    if vim.fn.executable(cmd) ~= 1 then
      print(cmd .. ' not found')
      return false
    end
  end
  return true
end

if check() then
  vim.api.nvim_create_autocmd('UIEnter', {
    once = true,
    callback = function()
      require('core.builtin')
      require('core.globals')
      require('utils.api')
      require('keymap.basic')
    end,
  })
  vim.cmd.colorscheme('aklk1ng')
  require('core.options')
  require('core.event')
  require('core.pack'):boot_strap()
  require('keymap.modules')
end
