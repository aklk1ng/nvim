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
    dap.listeners.after.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.after.event_exited["dapui_config"] = function()
        dapui.close()
    end
    dapui.setup({
        mappings = {
            -- Use a table to apply multiple mappings
            expand = { "<CR>", "<2-LeftMouse>" },
            open = "o",
            remove = "d",
            edit = "e",
            repl = "r",
        },
        layouts = {
            {
                elements = {
                    -- Provide as ID strings or tables with "id" and "size" keys
                    {
                        id = "scopes",
                        size = 0.25, -- Can be float or integer > 1
                    },
                    { id = "breakpoints", size = 0.25 },
                    { id = "stacks", size = 0.25 },
                    { id = "watches", size = 0.25 },
                },
                size = 40,
                position = "left",
            },
            { elements = { "repl" }, size = 10, position = "bottom" },
        },
        -- Requires Nvim version >= 0.8
        controls = {
            enabled = true,
            -- Display controls in this session
            element = "repl",
        },
        floating = {
            max_height = nil,
            max_width = nil,
            mappings = { close = { "q", "<Esc>" } },
        },
        windows = { indent = 1 },
    })
end

return M
