local M = {}

function M.config()
    local filters = require('mutchar.filters')
    require('mutchar').setup({
        ["c"] = {
            rules = {
                {"--", "->"},
            },
            filter = {
                filters.non_space_before,
            },
        },
        ["cpp"] = {
            rules = {
                {"--", "->"},
            },
            filter = {
                filters.non_space_before,
            },
        },
        ["go"] = {
            rules = {
                {":", ":="},
            },
        }
    })
end

return M
