local scratch_buf_init = function()
  local buf = vim.api.nvim_get_current_buf()
  for name, value in pairs({
    filetype = 'Scratch',
    buftype = 'nofile',
    bufhidden = 'wipe',
    swapfile = false,
    modifiable = true,
  }) do
    vim.api.nvim_set_option_value(name, value, { buf = buf })
  end
end

vim.api.nvim_create_user_command('Mes', function()
  vim.cmd('vertical new')
  scratch_buf_init()
  vim.cmd('redir => msg_output | silent messages | redir END')
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.fn.split(vim.g.msg_output, '\n'))
end, { nargs = 0 })

vim.api.nvim_create_user_command('Root', function()
  local bufname = vim.api.nvim_buf_get_name(0)
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
end, { nargs = 0 })

-- https://github.com/folke/snacks.nvim/blob/main/lua/snacks/bufdelete.lua

--- Delete a buffer.
local function delete()
  local buf = vim.api.nvim_get_current_buf()

  vim.api.nvim_buf_call(buf, function()
    if vim.bo.modified then
      local choice =
        vim.fn.confirm(('Save changes to %q?'):format(vim.fn.bufname()), '&Yes\n&No\n&Cancel')
      if choice == 0 or choice == 3 then -- 0 for <Esc>/<C-c> and 3 for Cancel
        return
      end
      if choice == 1 then -- Yes
        vim.cmd.write()
      end
    end

    for _, win in ipairs(vim.fn.win_findbuf(buf)) do
      vim.api.nvim_win_call(win, function()
        if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then
          return
        end
        -- Try using alternate buffer
        local alt = vim.fn.bufnr('#')
        if alt ~= buf and vim.fn.buflisted(alt) == 1 then
          vim.api.nvim_win_set_buf(win, alt)
          return
        end

        -- Try using previous buffer
        local has_previous = pcall(vim.cmd, 'bprevious')
        if has_previous and buf ~= vim.api.nvim_win_get_buf(win) then
          return
        end

        -- Create new listed buffer
        local new_buf = vim.api.nvim_create_buf(true, false)
        vim.api.nvim_win_set_buf(win, new_buf)
      end)
    end
    if vim.api.nvim_buf_is_valid(buf) then
      pcall(vim.cmd, 'bdelete! ' .. buf)
    end
  end)
end

vim.api.nvim_create_user_command('Bdelete', delete, {})

vim.api.nvim_create_user_command('Scratch', function()
  vim.cmd('tabnew')
  scratch_buf_init()
end, { nargs = 0 })
