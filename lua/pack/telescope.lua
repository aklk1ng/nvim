require('G')
local telescope = require("telescope")
telescope.setup({
    defaults = {
        borderchars = { "═", "║", "═", "║", "╔", "╗", "╝", "╚" },
    },
    extensions = {
        media_files = {
            filetypes = { "png", "webp", "jpg", "jpeg", "mp4", "mp3" },
            find_cmd = "fd",-- sudo pacman -S ripgrep
        },
        fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        }
    },
})

telescope.load_extension('media_files')
telescope.load_extension('fzf')
telescope.load_extension('vim_bookmarks')
telescope.load_extension("notify")
