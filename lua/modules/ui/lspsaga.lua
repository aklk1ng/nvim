local M = {}

function M.config()
    local status, saga = pcall(require, "lspsaga")
    if (not status) then
        vim.notify("lspsaga not found")
        return
    end

    saga.setup({
        preview = {
            lines_above = 0,
            lines_below = 20,
        },
        scroll_preview = {
            scroll_down = '<C-f>',
            scroll_up = '<C-b>',
        },
        definition = {
            edit = '<C-c>o',
            vsplit = '<C-c>v',
            split = '<C-c>i',
            tabe = '<C-c>t',
            quit = 'q',
            close = '<Esc>',
        },
        lightbulb = {
            enable = false,
            enable_in_insert = false,
            sign = true,
            sign_priority = 40,
            virtual_text = true,
        },
        outline = {
            win_position = 'right',
            win_with = '',
            win_width = 30,
            custom_sort = nil,
            keys = {
                jump = 'o',
                expand_collaspe = 'u',
                quit = 'q',
            },
        },
        ui = {
            theme = 'round',
            border = 'shadow',
            winblend = 0,
            colors = {
                --float window normal bakcground color
                normal_bg = '#3F4342',
                -- normal_bg = '#201e26',
                --title background color
                title_bg = '#afd700',
                red = '#e95678',
                magenta = '#b33076',
                orange = '#FF8700',
                yellow = '#F3E68D',
                green = '#afd700',
                cyan = '#36d0e0',
                blue = '#61afef',
                purple = '#CBA6F7',
                white = '#d1d4cf',
                black = '#1c1c19',
            },
        },
    })

    local opts = { noremap = true, silent = true }

    -- Diagnsotic jump can use `<c-o>` to jump back
    vim.keymap.set('n', '[n', '<Cmd>Lspsaga diagnostic_jump_next<CR>', opts)
    vim.keymap.set('n', '[p', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', opts)

    -- Show line diagnostics
    vim.keymap.set("n", "<leader>sd", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })
    -- Show cursor diagnostic
    vim.keymap.set("n", "<leader>sd", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { silent = true })

    -- Hover Doc
    vim.keymap.set('n', ',,', '<Cmd>Lspsaga hover_doc<CR>', opts)

    -- Callhierarchy
    vim.keymap.set("n", "<Leader>ic", "<cmd>Lspsaga incoming_calls<CR>", opts)
    vim.keymap.set("n", "<Leader>oc", "<cmd>Lspsaga outgoing_calls<CR>", opts)

    -- Lsp finder find the symbol definition implement reference
    -- if there is no implement it will hide
    -- when you use action in finder like open vsplit then you can
    -- use <C-t> to jump back
    vim.keymap.set('n', 'gh', '<Cmd>Lspsaga lsp_finder<CR>', opts)

    -- goto_definition
    vim.keymap.set('n', 'gd', '<Cmd>Lspsaga goto_definition<CR>', opts)

    -- Code action
    vim.keymap.set({"n","v"}, "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)

    -- Peek Definition
    -- you can edit the definition file in this flaotwindow
    -- also support open/vsplit/etc operation check definition_action_keys
    -- support tagstack C-t jump back
    vim.keymap.set('n', 'gp', '<Cmd>Lspsaga peek_definition<CR>', opts)

    -- Rename
    vim.keymap.set('n', '<leader>rn', '<Cmd>Lspsaga rename<CR>', opts)

    -- outline / show symbols in some files when the lsp is supported
    vim.keymap.set("n","<leader>o", "<cmd>Lspsaga outline<CR>",opts)
end

return M
