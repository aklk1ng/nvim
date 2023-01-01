local M = {}
local helper = require('core.helper')

M.plugins = {}

function M:boot_strap()
    local lazypath = string.format('%s/lazy/lazy.nvim', helper.get_data_path())
    if not vim.loop.fs_stat(lazypath) then
        vim.notify("Start clone the lazy.nvim ...")
        local cmd = '!git clone https://github.com/folke/lazy.nvim ' .. lazypath
        vim.api.nvim_command(cmd)
    end
    vim.opt.runtimepath:prepend(lazypath)
    local lazy = require("lazy")
    local opts = {
        lockfile = helper.get_data_path() .. '/lazy-lock.json',
    }
    require('core.plugins')
    lazy.setup(M.plugins,opts)
end

function M.add_plugin(repo)
    table.insert(M.plugins,repo)
end


return M
