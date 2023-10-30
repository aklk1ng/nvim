local M = {}
local api = vim.api

local run_commands = {
  c = 'gcc -Wall -Wextra -Wshadow -Wno-unused % -o %< && ./%< && rm ./%<',
  cpp = 'g++ -Wall -Wextra -Wshadow -Wno-unused -std=c++20 % -o %< && ./%< && rm ./%<',
  async_run = 'g++ -Wall -Wextra -Wshadow -Wno-unused -std=c++20 % -o %< && ./%< < in > sample && rm ./%<',
  sh = 'bash %',
  python = 'python3 %',
  go = 'go run %',
  lua = 'lua %',
  rust = 'rustc % && ./%< && rm ./%<',
  zig = 'zig run',
}

local function Prepare()
  local cmds = {
    'silent w',
    'vs',
  }
  for _, cmd in pairs(cmds) do
    api.nvim_command(cmd)
  end
end

local function check()
  api.nvim_command('term diff sample out')
  api.nvim_command('term rm sample')
end

function M.run()
  local ft = vim.bo.filetype
  Prepare()
  api.nvim_command('term ' .. run_commands[ft])
end

function M.run_file()
  Prepare()
  vim.cmd('term ' .. run_commands.async_run)
  check()
end

return M
