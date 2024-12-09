local M = {}

M.plugins = {}

function M.load_modules()
  require('modules.plugins')
end

function M:boot_strap()
  local lazypath = string.format('%s/lazy/lazy.nvim', vim.fn.stdpath('data'))
  if not vim.uv.fs_stat(lazypath) then
    local cmd = '!git clone https://github.com/folke/lazy.nvim ' .. lazypath
    vim.api.nvim_command(cmd)
  end
  vim.opt.runtimepath:prepend(lazypath)
  local lazy = require('lazy')
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
          'matchit',
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
  lazy.setup(M.plugins, opts)
end

_G.packadd = function(repo)
  table.insert(M.plugins, repo)
end

return M
