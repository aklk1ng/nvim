local M = {}
function M.config()
    -- vim.opt_local.bufhidden = 'wipe'
    vim.opt_local.buflisted = true
    -- vim.opt_local.buftype = 'nofile'
    require 'nvim-tree'.setup {
        git = {
            enable = true
        },
        update_focused_file = { enable = true },
        view = {
            mappings = {
                list = {
                    -------- default mappings
                    -- d remove
                    -- D trash
                    -- r rename
                    -- <C-r> full_rename
                    -- x cut
                    -- c copy
                    -- p paste
                    -- m toggle_mark
                    -- y copy_name
                    -- Y copy_path
                    -- gy copy_absolute_path

                    -------- self mappins
                    { key = '<cr>', action = "edit" },
                    { key = 'R', action = "refresh" },
                    { key = 'n', action = "create" },
                    { key = 'K', action = "preview" },
                }
            }
        }
    }
end

return M
