local M = {}

function M.config()
    vim.g.floaterm_title = ''
    vim.g.floaterm_width = 0.8
    vim.g.floaterm_height = 0.8
    vim.g.floaterm_autoclose = 1
    vim.g.floaterm_opener = 'edit'
end

return M
