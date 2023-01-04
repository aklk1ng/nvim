local M = {}

function M.config()
    local status_ok, dap = pcall(require, 'dap')
    if not status_ok then
        vim.notify("dap not found")
        return
    end
    vim.keymap.set("n", "<F5>", require('dap').continue)
    vim.keymap.set("n", "<F6>", require('dap').step_into)
    vim.keymap.set("n", "<F7>", require('dap').step_over)
    vim.keymap.set("n", "<F8>", require("dap").step_out)
    vim.keymap.set("n", "<Leader>db", require('dap').toggle_breakpoint)
    vim.keymap.set("n", "<Leader>dB", function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end)

     dap.adapters.lldb = {
         type = 'executable',
         command = '/home/linuxbrew/.linuxbrew/bin/lldb-vscode', -- adjust as needed, must be absolute path
         -- command = '/usr/bin/lldb-vscode', -- adjust as needed, must be absolute path
         name = 'lldb'
     }
    dap.configurations.cpp = {
        {
            name = 'Launch',
            type = 'lldb',
            request = 'launch',
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            args = {},

            -- 💀
            -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
            --
            --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
            --
            -- Otherwise you might get the following error:
            --
            --    Error on launch: Failed to attach to the target process
            --
            -- But you should be aware of the implications:
            -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
            -- runInTerminal = false,
        },
    }

    -- If you want to use this for Rust and C, add something like this:

    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp

    dap.adapters.python = {
        type = "executable",
        command = "python",
        args = { "-m", "debugpy.adapter" },
    }
    dap.configurations.python = {
        {
            type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
            request = 'launch';
            name = "Launch file";
            program = "${file}"; -- This configuration will launch the current file if used.
            pythonPath = function()
                local cwd = vim.fn.getcwd()
                if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
                    return cwd .. '/venv/bin/python'
                elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
                    return cwd .. '/.venv/bin/python'
                else
                    return '/usr/bin/python'
                end
            end;
        },
    }

    dap.adapters.delve = {
        type = 'server',
        port = '${port}',
        executable = {
            command = 'dlv',
            args = {'dap', '-l', '127.0.0.1:${port}'},
        }
    }

    -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
    dap.configurations.go = {
        {
            type = "delve",
            name = "Debug",
            request = "launch",
            program = "${file}"
        },
        {
            type = "delve",
            name = "Debug test", -- configuration for debugging test files
            request = "launch",
            mode = "test",
            program = "${file}"
        },
        -- works with go.mod packages and sub packages 
        {
            type = "delve",
            name = "Debug test (go.mod)",
            request = "launch",
            mode = "test",
            program = "./${relativeFileDirname}"
        }
    }
end

return M
