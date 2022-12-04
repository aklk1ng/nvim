local M = {}

function M.lua_snip()
  local ls = require('luasnip')
  ls.config.set_config({
    history = false,
    updateevents = 'TextChanged,TextChangedI',
  })
  require('luasnip.loaders.from_vscode').lazy_load()
  require('luasnip.loaders.from_vscode').lazy_load({
    paths = { '~/.config/nvim/lua/' },
  })
end
function M.config()
    local status, cmp = pcall(require, "cmp")
    if (not status) then
        vim.notify("cmp not found")
        return
    end
     local has_words_before = function()
         local line, col = unpack(vim.api.nvim_win_get_cursor(0))
         return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
     end
     local luasnip = require("luasnip")
    local lspkind = require'lspkind'
    cmp.setup({
        snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            end,
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-e>'] = cmp.mapping.abort(),
            ['<A-.>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
            -- cancel
            ['<A-,>'] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }),
            ['<CR>'] = cmp.mapping.confirm({
                select = true,
            }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

             ["<Tab>"] = cmp.mapping(function(fallback)
                 if luasnip.expand_or_jumpable() then
                     luasnip.expand_or_jump()
                 elseif has_words_before() then
                     cmp.complete()
                 else
                     fallback()
                 end
             end, { "i", "s" }),

             ["<S-Tab>"] = cmp.mapping(function(fallback)
                 if luasnip.jumpable(-1) then
                     luasnip.jump(-1)
                 else
                     fallback()
                 end
             end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' }, -- For luasnip users.
            { name = 'buffer' },
            { name = "path" },
            { name = 'emoji' },
        }),
        formatting = {
            format = lspkind.cmp_format({
                wirth_text = true,
                maxwidth = 50
            })
        }
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
