local M = {}

function M.config()
    local filters = require('mutchar.filters')
    require('mutchar').setup({
        ["c"] = {
            rules = {
                {",,", "->"},
            },
            filter = {
                filters.non_space_before,
            },
        },
        ["cpp"] = {
            rules = {
                {",,", "->"},
            },
            filter = {
                filters.non_space_before,
            },
        },
        ["go"] = {
            rules = {
                {";;", ":="},
                {",,", "<-"},
            },
            fileter = {
                filters.has_space_before,
            }
        }
    })
end

return M
