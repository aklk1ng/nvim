local M = {}

function M.lua_snip()
    local ls = require('luasnip')
    ls.config.set_config({
        -- disable the jump when i move outside the selection
        history = false,
        -- dynamic udpate the snippets when i type
        updateevents = 'TextChanged,TextChangedI',
    })
    -- require('luasnip.loaders.from_vscode').lazy_load()
    require('luasnip.loaders.from_vscode').lazy_load({
        paths = { '~/.config/nvim/lua/snippets/' },
    })
end

function M.config()
    local status, cmp = pcall(require, "cmp")
    if (not status) then
        vim.notify("cmp not found")
        return
    end
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")
    local cmp_window = require "cmp.utils.window"

    cmp_window.info_ = cmp_window.info
    cmp_window.info = function(self)
        local info = self:info_()
        info.scrollable = false
        return info
    end
    local function border(hl_name)
        return {
            { "╭", hl_name },
            { "─", hl_name },
            { "╮", hl_name },
            { "│", hl_name },
            { "╯", hl_name },
            { "─", hl_name },
            { "╰", hl_name },
            { "│", hl_name },
        }
    end

    cmp.setup({
        snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body)
            end,
        },
        window = {
            completion = {
                border = border "CmpBorder",
            },
            documentation = {
                border = border "CmpDocBorder",
            }
        },
        completion = {
            -- make the completion trigged when i type a letter not other invalid characters
            keyword_length = 1,
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-h>'] = cmp.mapping.abort(),
            ['<C-l>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm({
                select = true,
            }),

            ["<C-j>"] = cmp.mapping(function(fallback)
                if luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { "i", "s" }),

            ["<C-k>"] = cmp.mapping(function(fallback)
                if luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'buffer' },
            { name = "path" },
            { name = 'emoji' },
            {
                name = "latex_symbols",
                option = {
                    strategy = 0, -- mixed
                },
            },
            { name = 'vim-dadbod-completion' },
        }),
        formatting = {
            format = lspkind.cmp_format({
                maxwidth = 50,
            })
        },
    })
end

function M.nvim_autopairs()
    require("nvim-autopairs").setup()
    local status, cmp = pcall(require, "cmp")
    if (not status) then return end
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

return M
