local M = {}
local helper = require('core.helper')

M.plugins = {}

function M.load_modules()
  local modules_dir = helper.get_config_path() .. '/lua/modules'
  local file_list = vim.fs.find('plugins.lua', { path = modules_dir, type = 'file', limit = 10 })
  if #file_list == 0 then
    return
  end

  vim.iter(file_list):map(function(f)
    local _, pos = f:find(modules_dir)
    f = f:sub(pos - 6, #f - 4)
    require(f)
  end)
end

function M:boot_strap()
  local lazypath = string.format('%s/lazy/lazy.nvim', helper.get_data_path())
  if not vim.loop.fs_stat(lazypath) then
    local cmd = '!git clone https://github.com/folke/lazy.nvim ' .. lazypath
    vim.api.nvim_command(cmd)
  end
  vim.opt.runtimepath:prepend(lazypath)
  local lazy = require('lazy')
  local opts = {
    lockfile = helper.get_data_path() .. '/lazy-lock.json',
    git = {
      log = { '-10' }, -- show the last 10 commits
      timeout = 60, -- kill processes that take more than 1 minutes
    },
    dev = {
      path = '~/workspace',
    },
    performance = {
      rtp = {
        disabled_plugins = {
          'gzip',
          'man',
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
      notify = true,
      frequency = 3600,
    },
  }
  M.load_modules()
  lazy.setup(M.plugins, opts)
end

function M.add_plugin(repo)
  table.insert(M.plugins, repo)
end

return M
