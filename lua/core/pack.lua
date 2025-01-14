local M = {}

M.plugins = {}

function M.load_modules()
  require('plugins')
end

function M:boot_strap()
  local lazypath = string.format('%s/lazy/lazy.nvim', vim.fn.stdpath('data'))
  if not vim.uv.fs_stat(lazypath) then
    local cmd = '!git clone https://github.com/folke/lazy.nvim ' .. lazypath
    vim.api.nvim_command(cmd)
  end
  vim.opt.runtimepath:prepend(lazypath)
  local opts = {
    rocks = {
      enabled = false,
    },
    lockfile = vim.fn.stdpath('data') .. '/lazy-lock.json',
    git = {
      log = { '-10' },
      timeout = 60,
    },
    dev = {
      path = '~/workspace',
    },
    install = { colorscheme = { 'aklk1ng' } },
    performance = {
      rtp = {
        disabled_plugins = {
          'gzip',
          'netrwPlugin',
          'rplugin',
          'tarPlugin',
          'tohtml',
          'tutor',
          'zipPlugin',
        },
      },
    },
    checker = {
      enabled = true,
    },
  }
  M.load_modules()
  require('lazy').setup(M.plugins, opts)
end

_G.packadd = function(plugin)
  table.insert(M.plugins, plugin)
end

return M
