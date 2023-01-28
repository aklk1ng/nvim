local M = {}
local map = vim.keymap.set

M.default_opt = {
  noremap = true,
  silent = true,
}

function M.cmd(str)
  return '<cmd>' .. str .. '<CR>'
end

function M.wait_cmd(str)
  return ':' .. str
end

function M.map(maps)
  for _, value in pairs(maps) do
    map(value[1], value[2], value[3], value[4])
  end
end

function M.toggle_option(bound, option)
  if bound == 'o' then
    vim.opt_local[option] = not vim.opt_local[option]:get()
  elseif bound == 'g' then
    vim.g[option] = not vim.g[option]
  end
end

return M
