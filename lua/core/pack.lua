local M = {}
local helper = require('core.helper')

M.plugins = {}

function M:boot_load()
    local lazypath = string.format('%s/lazy/lazy.nvim', helper.get_data_path())
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "--single-branch",
            "https://github.com/folke/lazy.nvim.git",
            lazypath,
        })
    end
    vim.opt.runtimepath:prepend(lazypath)
    local lazy = require("lazy")
    local opts = {
        lockfile = helper.get_data_path() .. '/lazy-lock.json',
    }
    lazy.setup(M.plugins,opts)
end

function M.load_plugin(repo)
    table.insert(M.plugins,repo)
end


return M
