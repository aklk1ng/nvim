local M = {}
local api, ui = vim.api, vim.ui

local function Command(filetype)
  if filetype == 'c' then
    return 'term gcc % -o %< && time ./%< && rm ./%<'
  elseif filetype == 'cpp' then
    return 'term g++ -std=c++17 % -Wall -o %< && time ./%< && rm ./%<'
  elseif filetype == 'sh' then
    return 'term time bash %'
  elseif filetype == 'python' then
    return 'term python3 %'
  elseif filetype == 'go' then
    return 'term go run %'
  elseif filetype == 'lua' then
    return 'term lua %'
  elseif filetype == 'rust' then
    return 'term cargo run'
  elseif filetype == 'zig' then
    return 'term zig run %'
  elseif filetype == 'typescript' then
    return 'term ts-node %'
  end
end
local function Prepare()
  local cmds = {
    'silent w',
    'set splitbelow',
    ':sp',
    ':res - 5',
  }
  for _, cmd in pairs(cmds) do
    api.nvim_command(cmd)
  end
end

function M.QuickRun()
  local default_command = Command(vim.bo.filetype)
  ui.input({
    prompt = 'QuickRun: ',
    default = default_command,
  }, function(input)
    if input then
      Prepare()
      api.nvim_command(input)
    end
  end)
end

return M
