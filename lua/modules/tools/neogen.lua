local M = {}

function M.config()
    require('neogen').setup({
        snippet_engine = "luasnip"
    })
end

return M
