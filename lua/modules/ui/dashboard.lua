local M = {}

function M.setup()
    local home = os.getenv('HOME')
    local db = require('dashboard')
    -- macos
    db.preview_command = 'cat | lolcat -F 0.3'
    -- linux
    -- db.preview_command = 'ueberzug'
    --
    db.preview_file_path = home .. '/.config/nvim/static/neovim.cat'
    db.preview_file_height = 15
    db.preview_file_width = 67
    db.custom_center = {
        {icon = '  ',
            desc = 'Recently opened files                    ',
            action =  'FzfLua oldfiles',
            shortcut = 'f o'},
        {icon = '  ',
            desc = 'Find  File                               ',
            action = 'FzfLua files',
            shortcut = 'f f'},
    }
end

return M
