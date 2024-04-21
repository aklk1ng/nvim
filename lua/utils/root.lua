local api, fs, uv = vim.api, vim.fs, vim.uv

api.nvim_create_user_command('Root', function()
  local bufname = api.nvim_buf_get_name(0)
  ---@diagnostic disable-next-line: undefined-field
  if not uv.fs_stat(bufname) then
    return
  end
  local cwd = fs.dirname(bufname)
  -- try to find a file that's supposed to be in the root
  local patterns = {
    '.git',
    'Makefile',
    'Cargo.toml',
    'go.mod',
    'CMakeList.txt',
    'package.json',
  }
  local result = fs.find(patterns, { path = cwd, upward = true, stop = vim.env.HOME })
  if not vim.tbl_isempty(result) then
    vim.cmd('silent! ' .. 'lcd ' .. fs.dirname(result[1]))
    return
  end
  -- or if it's some wierd filtype try to get root from lsp
  vim.tbl_map(function(client)
    local ft, root = client.config.filetypes, client.config.root_dir
    if ft and vim.fn.index(ft, vim.bo.ft) ~= -1 and root then
      vim.cmd('silent! ' .. 'lcd ' .. root)
      return
    end
  end, vim.lsp.get_clients({ bufnr = 0 }))
  vim.cmd('silent! ' .. 'lcd ' .. cwd)
end, {})
