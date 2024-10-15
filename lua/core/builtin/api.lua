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

api.nvim_create_user_command('Root', function()
  local bufname = api.nvim_buf_get_name(0)
  if not vim.uv.fs_stat(bufname) then
    return
  end

  vim.tbl_map(function(client)
    local filetypes, root = client.config.filetypes, client.config.root_dir
    if filetypes and vim.fn.index(filetypes, vim.bo.ft) ~= -1 and root then
      vim.cmd.lcd(root)
      return
    end
  end, vim.lsp.get_clients({ buf = 0 }))

  local cwd = vim.fs.dirname(bufname)
  vim.cmd.lcd(cwd)
end, {})
