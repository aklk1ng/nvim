local M = {}

function M.config()
    local filters = require('mutchar.filters')
    require('mutchar').setup({
        ["c"] = {
            rules = {
                { ",,", "->" },
            },
            filter = {
                filters.non_space_before,
            },
        },
        ["cpp"] = {
            rules = {
                { ",,", "->" },
            },
            filter = {
                filters.non_space_before,
            },
        },
        ["go"] = {
            rules = {
                { ";;", ":=" },
                { ",,", "<-" },
            },
            filter = {
                filters.has_space_before,
            }
        },
        ['rust'] = {
            rules = {
                { ",,", "->" },
                { ";;", "=>" },
            },
            filter = {
                filters.has_space_before,
            },
            one_to_one = true,
        },
    })
end

return M
