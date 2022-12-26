local M = {}

function M.config()
    local status_ok, dapui = pcall(require, 'dapui')
    if not status_ok then
        vim.notify("dapui not found")
        return
    end
    local dap = require("dap")
    dap.listeners.after.event_initialized["dapui_config"] = function()
        ---@diagnostic disable-next-line: missing-parameter
        dapui.open()
    end
    dapui.setup({
    })
end

return M
