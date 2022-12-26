local M = {}

function M.config()
    local status, colorizer = pcall(require, "colorizer")
    if (not status) then return end

    colorizer.setup({
    })
end

return M
