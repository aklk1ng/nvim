local helper = require('core.helper')
local M = {}

function M.run()
  local file = io.open(helper.get_config_path() .. '/lua/snippets/cpp.json', 'r')
  if not file then
    return
  end
  local json = vim.fn.json_decode(file:read('*a'))
  local chunk = json.cf.body
  for k, v in pairs(chunk) do
    -- remove ${number}
    local t = string.gsub(v, '%$%w+', '')
    -- convert tab to spaces
    t = string.gsub(t, '\t', string.rep(' ', 2))
    chunk[k] = t
  end
  local start = vim.fn.line('.')
  vim.api.nvim_buf_set_lines(0, start - 1, -1, false, chunk)
end

return M
