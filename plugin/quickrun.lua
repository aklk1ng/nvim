local helper = require('core.helper')

local function Run(filetype)
    if filetype == "c" then
        vim.api.nvim_command("term gcc % -o %< && time ./%<")
    elseif filetype == "cpp" then
        vim.api.nvim_command("!g++ -std=c++17 % -Wall -o %<")
        vim.api.nvim_command("term ./%<")
    elseif filetype == "sh" then
        vim.api.nvim_command("!time bash %")
    elseif filetype == "python" then
        vim.api.nvim_command("term python %")
    elseif filetype == "go" then
        vim.api.nvim_command("term go run %")
    elseif filetype == "lua" then
        vim.api.nvim_command("term lua %")
    elseif filetype == "rust" then
        vim.api.nvim_command("term cargo run %")
    end
end

local function Prepare()
    local cmds = {
        "silent w",
        "set splitbelow",
        ":sp",
        ":res - 5",
    }
    for _, cmd in pairs(cmds) do
        vim.api.nvim_command(cmd)
    end
end

local function QuickRun()
    Prepare()
    local filetype = helper.get_current_filetype()
    Run(filetype)
end

vim.keymap.set("n", "<leader>r", QuickRun, { noremap = true, silent = true })
