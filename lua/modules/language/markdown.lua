local M = {}


function M.config()
    vim.g.mkdp_markdown_css = '~/.config/nvim/colors/markdown.css'
    vim.g.mkdp_page_title = '${name}'
    vim.g.mkdp_preview_options = { hide_yaml_meta = 1, disable_filename = 1 }
    -- i only use next config in my Archlinux system(if you don't have the surf browser, comment the next line or move it)
    vim.g.mkdp_browser= 'surf'
end

function M.setup()
    -- do nothing
end

return M
