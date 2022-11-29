local M = {}

function M.setup()
    vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics,
        {
            underline = true,
            virtual_text = {
                spacing = 5,
                severity_limit = 'Warning',
            },
            update_in_insert = true,
        }
    )
    require('nvim-treesitter.configs').setup {
        ensure_installed = {
            "c",
            "cpp",
            "python",
            "lua",
            "bash",
            "yaml",
            "html",
            "css",
            "json",
            "tsx",
            "go",
            "markdown",
            "javascript",
            "typescript",
            "cmake",
            "sql",
            "vim",
        },
        highlight = {
            enable = true
        },
        rainbow = {
            enable = true,
            disable = {},
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
        query_linter = {
            enable = true,
            use_virtual_text = true,
            lint_events = {"BufWrite", "CursorHold"},
        },
    }
end

return M
