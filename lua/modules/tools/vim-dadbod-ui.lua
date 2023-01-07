local M = {}

function DBUI()
    vim.api.nvim_command('set laststatus=0 showtabline=0 nonu signcolumn=no nofoldenable')
    vim.api.nvim_command('exec "DBUI"')
end

function M.config()
    vim.g.db_ui_save_location = vim.env.HOME .. '/.cache/vim/db_ui_queries'
    vim.g.db_ui_win_position = 'left'
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_winwidth = 35
    vim.api.nvim_command('com! CALLDB call v:lua.DBUI()')
end

return M
