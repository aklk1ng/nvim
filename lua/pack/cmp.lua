local config = {}
local status, cmp = pcall(require, "cmp")
if (not status) then return end
local lspkind = require'lspkind'
local luasnip = require'luasnip'
  require('luasnip.loaders.from_vscode').lazy_load()
-- use my snippets
require("luasnip.loaders.from_vscode").lazy_load({ paths = { "~/.config/nvim/lua/" }})

-- function config.lspsaga()
--   local saga = require('lspsaga')
--   saga.init_lsp_saga({
--     symbol_in_winbar = {
--       enable = true,
--     },
--   })
-- end

-- function config.nvim_cmp()
-- local status, cmp = pcall(require, "cmp")
-- if (not status) then return end
-- local lspkind = require'lspkind'
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
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<A-.>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        -- 取消
        ['<A-,>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping.confirm({
            select = true,
        }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

        --new mapping for completion(to cooperate the snippets)
        ["<Tab>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
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
-- end

-- function config.lua_snip()
--   local ls = require('luasnip')
--   ls.config.set_config({
--     history = false,
--     updateevents = 'TextChanged,TextChangedI',
--   })
--   require('luasnip.loaders.from_vscode').lazy_load()
--   require('luasnip.loaders.from_vscode').lazy_load({
--     paths = { '~/.config/nvim/lua/' },
--   })
-- end

vim.cmd [[
  set completeopt=menuone,noinsert,noselect
  highlight! default link CmpItemKind CmpItemMenuDefault
]]
--to require the map <CR> with the autopairs plugin
-- function config.auto_pairs()
--   require('nvim-autopairs').setup({})
--     local status, cmp = pcall(require, 'cmp')
--   if not status then
--     vim.cmd([[packadd nvim-cmp]])
--     cmp = require('cmp')
--   end
--   local cmp_autopairs = require('nvim-autopairs.completion.cmp')
--   cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))
-- end
require("nvim-autopairs").setup()
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
return config
