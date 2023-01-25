local M = {}


function M.config()
    vim.g.mkdp_page_title = '${name}'
    vim.g.mkdp_preview_options = { hide_yaml_meta = 1, disable_filename = 1 }
    vim.g.mkdp_browser = 'surf'
end

function M.setup()
    -- do nothing
end

return M
