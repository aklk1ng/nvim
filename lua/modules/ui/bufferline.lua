local M = {}

function M.config()
    local status, bufferline = pcall(require, "bufferline")
    if (not status) then
        vim.notify("bufferline not found")
        return
    end

    bufferline.setup({
        options = {
            always_show_bufferline = true,
            color_icons = true,
            offsets = { {
                filetype = "NvimTree",
                text = "File Explorer",
                text_align = "left"
            } }
        },
        highlights = {
            fill = {
                bg = '#262a33'
            }
        },
    })
end

return M
