local M = {}

function M.config()

    require("indent_blankline").setup {
        char = '│',
        use_treesitter= true,
        show_current_context = true,
        show_current_context_start = false,
        show_trailing_blankline_indent = true,
        context_highlight_list = {
            'rainbowcol1',
            'rainbowcol2',
            'rainbowcol3',
            'rainbowcol4',
            'rainbowcol5',
            'rainbowcol6',
            'rainbowcol7',
        },
        filetype_exclude = {
            'dashboard',
            'DogicPrompt',
            'log',
            'fugitive',
            'gitcommit',
            'packer',
            'markdown',
            'json',
            'txt',
            'vista',
            'help',
            'todoist',
            'NvimTree',
            'git',
            'undotree',
        },
        buftype_exclude = { 'terminal', 'nofile', 'prompt' },
        context_patterns = {
            'class',
            'function',
            'method',
            'block',
            'list_literal',
            'selector',
            '^if',
            '^table',
            'if_statement',
            'while',
            'for',
        },
    }
end

return M
