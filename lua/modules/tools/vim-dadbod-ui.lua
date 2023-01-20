local M = {}

function M.config()
    vim.g.db_ui_save_location = vim.env.HOME .. '/.cache/vim/db_ui_queries'
    vim.g.db_ui_win_position = 'left'
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_winwidth = 35
end

return M
