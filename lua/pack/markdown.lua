local G = require('G')
local M = {}

function M.config()
    G.g.mkdp_markdown_css = '~/.config/nvim/colors/markdown.css'
    G.g.mkdp_page_title = '${name}'
    G.g.mkdp_preview_options = { hide_yaml_meta = 1, disable_filename = 1 }
end

function M.setup()
    -- do nothing
end

return M
