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
        autotag = { enable = true, filetypes = {
            'html',
            'javascript',
            'typescript',
            'javascriptreact',
            'typescriptreact',
            'svelte',
            'vue',
            'tsx',
            'jsx',
            'rescript',
            'xml',
            'php',
            'markdown',
            'glimmer','handlebars','hbs'
        }},
        indent = { enable = true },
    }
end

return M
