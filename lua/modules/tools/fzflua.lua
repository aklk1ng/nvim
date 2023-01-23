local M = {}

function M.config()
    local actions = require "fzf-lua.actions"
    require 'fzf-lua'.setup {
        global_resume       = true, -- enable global `resume`?
        global_resume_query = true, -- include typed query in `resume`?
        winopts             = {
            -- split         = "belowright new",-- open in a split instead?
            -- "belowright new"  : split below
            -- "aboveleft new"   : split above
            -- "belowright vnew" : split right
            -- "aboveleft vnew   : split left
            -- Only valid when using a float window
            -- (i.e. when 'split' is not defined, default)
            height     = 0.85, -- window height
            width      = 0.95, -- window width
            row        = 0.40, -- window row position (0=top, 1=bottom)
            col        = 0.70, -- window col position (0=left, 1=right)
            -- border argument passthrough to nvim_open_win(), also used
            -- to manually draw the border characters around the preview
            -- window, can be set to 'false' to remove all borders or to
            -- 'none', 'single', 'double', 'thicc' or 'rounded' (default)
            border     = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
            fullscreen = false, -- start fullscreen?
            preview    = {
                border       = 'border', -- border|noborder, applies only to
                wrap         = 'nowrap', -- wrap|nowrap
                hidden       = 'nohidden', -- hidden|nohidden
                vertical     = 'down:45%', -- up|down:size
                horizontal   = 'right:60%', -- right|left:size
                layout       = 'flex', -- horizontal|vertical|flex
                flip_columns = 100, -- #cols to switch to horizontal on flex
                -- Only used with the builtin previewer:
                title        = true, -- preview border title (file/buf)?
                title_align  = "left", -- left|center|right, title alignment
                scrollbar    = 'float', -- `false` or string:'float|border'
                -- float:  in-window floating border
                -- border: in-border chars (see below)
                scrolloff    = '-2', -- float scrollbar offset from right
                -- applies only when scrollbar = 'float'
                scrollchars  = { '█', '' }, -- scrollbar chars ({ <full>, <empty> }
                -- applies only when scrollbar = 'border'
                delay        = 100, -- delay(ms) displaying the preview
                -- prevents lag on fast scrolling
                winopts      = { -- builtin previewer window options
                    number         = true,
                    relativenumber = false,
                    cursorline     = true,
                    cursorlineopt  = 'both',
                    cursorcolumn   = false,
                    signcolumn     = 'no',
                    list           = false,
                    foldenable     = false,
                    foldmethod     = 'manual',
                },
            },
            on_create  = function()
                -- called once upon creation of the fzf main window
                -- can be used to add custom fzf-lua mappings, e.g:
                --   vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", "<Down>",
                --     { silent = true, noremap = true })
            end,
        },
        keymap              = {
            -- These override the default tables completely
            -- no need to set to `false` to disable a bind
            -- delete or modify is sufficient
            builtin = {
                -- neovim `:tmap` mappings for the fzf win
                ["<F1>"]     = "toggle-help",
                ["<F2>"]     = "toggle-fullscreen",
                -- Only valid with the 'builtin' previewer
                ["<F3>"]     = "toggle-preview-wrap",
                ["<F4>"]     = "toggle-preview",
                -- Rotate preview clockwise/counter-clockwise
                ["<F5>"]     = "toggle-preview-ccw",
                ["<F6>"]     = "toggle-preview-cw",
                -- ["<ctrl-u>"]    = "preview-page-down",
                -- ["<ctrl-i>"]      = "preview-page-up",
                ["<S-left>"] = "preview-page-reset",
            },
            fzf = {
                -- fzf '--bind=' options
                ["ctrl-z"]     = "abort",
                ["ctrl-u"]     = "unix-line-discard",
                ["ctrl-f"]     = "half-page-down",
                ["ctrl-b"]     = "half-page-up",
                ["ctrl-a"]     = "beginning-of-line",
                ["ctrl-e"]     = "end-of-line",
                ["alt-a"]      = "toggle-all",
                -- Only valid with fzf previewers (bat/cat/git/etc)
                ["f3"]         = "toggle-preview-wrap",
                ["f4"]         = "toggle-preview",
                ["shift-down"] = "preview-page-down",
                ["shift-up"]   = "preview-page-up",
            },
        },
        actions             = {
            -- These override the default tables completely
            -- no need to set to `false` to disable an action
            -- delete or modify is sufficient
            files = {
                -- ["default"]     = actions.file_edit,
                ["default"] = actions.file_edit_or_qf,
                ["ctrl-s"]  = actions.file_split,
                ["ctrl-v"]  = actions.file_vsplit,
                ["ctrl-t"]  = actions.file_tabedit,
                ["alt-q"]   = actions.file_sel_to_qf,
                ["alt-l"]   = actions.file_sel_to_ll,
            },
            buffers = {
                -- providers that inherit these actions:
                --   buffers, tabs, lines, blines
                ["default"] = actions.buf_edit,
                ["ctrl-s"]  = actions.buf_split,
                ["ctrl-v"]  = actions.buf_vsplit,
                ["ctrl-t"]  = actions.buf_tabedit,
            }
        },
        fzf_opts = {
            ['--ansi']   = '',
            ['--info']   = 'inline',
            ['--height'] = '100%',
            ['--layout'] = 'reverse-list',
            ['--border'] = 'none',
        },
        previewers = {
            cat = {
                cmd  = "cat",
                args = "--number",
            },
            bat = {
                cmd    = "bat",
                args   = "--style=numbers,changes --color always",
                theme  = 'Coldark-Dark', -- bat preview theme (bat --list-themes)
                config = nil, -- nil uses $BAT_CONFIG_PATH
            },
            builtin = {
                syntax          = true, -- preview syntax highlight?
                syntax_limit_l  = 0, -- syntax limit (lines), 0=nolimit
                syntax_limit_b  = 1024 * 1024 * 2, -- syntax limit (bytes), 0=nolimit
                limit_b         = 1024 * 1024 * 20, -- preview limit (bytes), 0=nolimit
                extensions      = {
                    -- neovim terminal only supports `viu` block output
                    ["png"] = { "viu", "-b" },
                    ["jpg"] = { "ueberzug" },
                },
                -- if using `ueberzug` in the above extensions map
                -- set the default image scaler, possible scalers:
                --   false (none), "crop", "distort", "fit_contain",
                --   "contain", "forced_cover", "cover"
                -- https://github.com/seebye/ueberzug
                ueberzug_scaler = "cover",
            },
        },
        -- provider setup
        files               = {
            -- previewer      = "bat",          -- uncomment to override previewer
            -- (name from 'previewers' table)
            -- set to 'false' to disable
            prompt       = 'Files❯ ',
            multiprocess = true, -- run command in a separate process
            git_icons    = true, -- show git icons?
            file_icons   = true, -- show file icons?
            color_icons  = true, -- colorize file|git icons
            -- NOTE: 'find -printf' requires GNU find
            -- cmd            = "find . -type f -printf '%P\n'",
            find_opts    = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
            rg_opts      = "--color=never --files --hidden --follow -g '!.git'",
            fd_opts      = "--color=never --type f --hidden --follow --exclude .git",
            actions      = {
                -- inherits from 'actions.files', here we can override
                -- or set bind to 'false' to disable a default action
                ["default"] = actions.file_edit,
                -- custom actions are available too
                ["ctrl-y"]  = function(selected) print(selected[1]) end,
            }
        },
    }
end

return M
