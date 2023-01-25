local M = {}

function M.footer()
    local stats = require("lazy").stats()
    return
    '',
    '',
    "   Welcome here"
    ..
    "   v"
    .. vim.version().major
    .. "."
    .. vim.version().minor
    .. "."
    .. vim.version().patch
    .. "   "
    .. stats.count
    .. " plugins"
end

function M.setup()
    local home = os.getenv('HOME')
    require('dashboard').setup({
        theme = 'doom',
        config = {
            center = {
                {
                    icon = '  ',
                    icon_hi = 'Type',
                    desc = 'Update',
                    desc_hi = 'String',
                    key = 'u',
                    key_hi = 'Keyword',
                    action = 'Lazy update'
                },
                {
                    icon = '  ',
                    icon_hi = 'Type',
                    desc = 'Files',
                    desc_hi = 'String',
                    key = 'f',
                    key_hi = 'Keyword',
                    action = 'FzfLua files'
                },
                {
                    icon = '  ',
                    icon_hi = 'Type',
                    desc = 'Old Files           ',
                    desc_hi = 'String',
                    key = 'o',
                    key_hi = 'Keyword',
                    action = 'FzfLua oldfiles'
                }
            },
            footer = {
                M.footer()
            }
        },
        preview = {
            command = 'cat | lolcat -F 0.3',      -- preview command
            file_path = home .. '/.config/nvim/static/neovim.cat',   -- preview file path
            file_height = 20,  -- prefview file height
            file_width = 65    -- preview file width
        },
    })
end

return M
