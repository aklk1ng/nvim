local M = {}

local function prepare()
  local cmds = {
    'silent w',
    'new',
  }
  for _, cmd in pairs(cmds) do
    vim.api.nvim_command(cmd)
  end
end

function M.run()
  local ft = vim.bo.filetype
  local name = vim.fn.expand('%')
  local bin = vim.fn.expand('%<')
  local cmd
  if ft == 'c' then
    cmd = 'gcc -g -Wall -Wextra -Wshadow -Wno-unused -Wno-sign-compare '
      .. name
      .. ' -o '
      .. bin
      .. ' && ./'
      .. bin
      .. ' && rm ./'
      .. bin
  elseif ft == 'cpp' then
    cmd = 'clang++ -g -Wall -Wextra -Wshadow -Wno-unused -Wno-sign-compare -std=c++20 '
      .. name
      .. ' -o '
      .. bin
      .. ' && ./'
      .. bin
      .. ' && rm ./'
      .. bin
  elseif ft == 'rust' then
    cmd = 'rustc ' .. name .. ' && ./' .. bin .. ' && rm ./' .. bin
  elseif ft == 'python' then
    cmd = 'python ' .. name
  elseif ft == 'sh' then
    cmd = 'bash ' .. name
  elseif ft == 'go' then
    cmd = 'go run ' .. name
  elseif ft == 'lua' then
    cmd = 'lua ' .. name
  elseif ft == 'make' then
    cmd = 'make'
  end

  if not cmd then
    vim.notify('there is no valiable command')
    return
  end

  prepare()
  vim.api.nvim_command('term ' .. cmd)
end

return M
