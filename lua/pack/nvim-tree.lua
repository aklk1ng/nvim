vim.opt_local.bufhidden = 'wipe'
vim.opt_local.buflisted = false
vim.opt_local.buftype = 'nofile'
require'nvim-tree'.setup {
    -- 不显示 git 状态图标
    git = {
        enable = false
    },
    update_focused_file = { enable = true },
    view = {
        mappings = {
            list = {
                { key='<cr>', action = "edit" },
                { key='R'   , action = "refresh" },
                { key='K'   , action = "preview" },
            }
        }
    }
}
