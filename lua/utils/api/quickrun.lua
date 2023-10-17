local M = {}
local api, ui = vim.api, vim.ui

local function Command(filetype)
  if filetype == 'c' then
    return 'term gcc -Wall -Wextra -Wshadow -Wno-unused % -o %< && ./%< && rm ./%<'
  elseif filetype == 'cpp' then
    return 'term g++ -Wall -Wextra -Wshadow -Wno-unused -std=c++20 % -o %< && ./%< && rm ./%<'
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
  end
end

local function Prepare()
  local cmds = {
    'silent w',
    'set splitbelow',
    'sp',
  }
  for _, cmd in pairs(cmds) do
    api.nvim_command(cmd)
  end
end

function M.QuickRun()
  local default_command = Command(vim.bo.filetype)

  if
    vim.bo.filetype == 'c'
    or vim.bo.filetype == 'cpp'
    or vim.bo.filetype == 'python'
    or vim.bo.filetype == 'sh'
    or vim.bo.filetype == 'lua'
  then
    Prepare()
    api.nvim_command(default_command)
    return
  end

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

function M.asyncrun()
  vim.cmd('AsyncRun g++ -Wall -Wextra -Wshadow -Wno-unused -std=c++20 % -o %< && ./%< < in.txt && rm ./%<')
  vim.cmd('copen')
  vim.cmd(':wincmd k')
end

return M
