local M = {}

function M.run()
  local ft = vim.bo.filetype
  local cmd
  if ft == 'c' then
    cmd = 'gcc -g -Wall -Wextra -Wshadow -Wno-unused -Wno-sign-compare % -o %< && ./%< && rm ./%<'
  elseif ft == 'cpp' then
    cmd =
      'clang++ -g -Wall -Wextra -Wshadow -Wno-unused -Wno-sign-compare -std=c++20 % -o %< && ./%< && rm ./%<'
  elseif ft == 'rust' then
    cmd = 'rustc % && ./%< && rm ./%<'
  elseif ft == 'python' then
    cmd = 'python %'
  elseif ft == 'sh' then
    cmd = 'bash %'
  elseif ft == 'go' then
    cmd = 'go run %'
  elseif ft == 'lua' then
    cmd = 'lua %'
  elseif ft == 'make' then
    cmd = 'make'
  end

  if not cmd then
    vim.notify('No command found')
    return
  end

  vim.api.nvim_command('silent write')
  _G.Terms.run({ cmd = vim.fn.expandcmd(cmd), id = 'QuickRun' })
end

return M
