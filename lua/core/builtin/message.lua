local api = vim.api

api.nvim_create_user_command('Mes', function()
  local mes = vim.fn.execute('message')
  local lines = {}
  for line in vim.trim(mes):gsub('\t', (' '):rep(4)):gmatch('([^\n]*)\n?') do
    table.insert(lines, { text = line })
  end
  vim.fn.setqflist(lines)
  vim.cmd.copen()
end, {})
