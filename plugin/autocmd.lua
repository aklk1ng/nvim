local autocmd = {}

function autocmd.nvim_create_augroups(definitions)
    for group_name, definition in pairs(definitions) do
        vim.api.nvim_command("augroup " .. group_name)
        vim.api.nvim_command("autocmd!")
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
            vim.api.nvim_command(command)
        end
        vim.api.nvim_command("augroup END")
    end
end

function autocmd.load_autocmds()
    local definitions = {
        bufs = {
            -- auto place to last edit
            {
                "BufReadPost",
                "*",
                [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g'\"" | endif]],
            },
            -- trailing whitespace
            {
                "BufWritePre",
                "*",
                [[%s/\s\+$//e]]
            },
        },
        wins = {
        },
        ft = {
        },
        yank = {
            {
                "TextYankPost",
                "*",
                [[silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=100})]]
            },
        },
    }

    autocmd.nvim_create_augroups(definitions)
end

autocmd.load_autocmds()
