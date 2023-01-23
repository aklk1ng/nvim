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
        rename = {
            quit = '<C-c>',
            exec = '<CR>',
            mark = 'x',
            confirm = '<CR>',
            in_select = true,
            whole_project = true,
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
                title = true,
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
end

return M
