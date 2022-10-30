local M = {}

function M.setup()
    require('nvim-treesitter.configs').setup {
        ensure_installed = " ",
        highlight = {
            enable = true
        },
        rainbow = {
            enable = true,
            disable = { "html" },
            extended_mode = false,
            max_file_lines = nil,
        },
        autopairs = { enable = true },
        autotag = { enable = true, filetypes = { "html" , "xml", "lua" } },
        indent = { enable = true },
    }
end

return M
