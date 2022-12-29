local M = {}

function M.config()
    require("notify").setup({
        -- vim.notify = require("notify"),
        -- hardcoded background color
        vim.notify.setup({ background_colour = "#282c34" })
    })
end

return M
