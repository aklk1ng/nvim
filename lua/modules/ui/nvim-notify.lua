local M = {}

function M.config()
    vim.notify = require("notify")
    require('notify').setup({
        fps = 20,
        timeout = 2000,
        stages = "fade_in_slide_out",
    })
end

return M
