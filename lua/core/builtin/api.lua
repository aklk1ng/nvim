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

-- https://github.com/folke/snacks.nvim/blob/main/lua/snacks/bufdelete.lua

--- Delete a buffer:
--- - either the current buffer if `buf` is not provided
--- - or the buffer `buf` if it is a number
--- - or every buffer for which `buf` returns true if it is a function
local function delete(opts)
  opts = opts or {}
  opts = type(opts) == 'number' and { buf = opts } or opts
  opts = type(opts) == 'function' and { filter = opts } or opts

  if type(opts.filter) == 'function' then
    for _, b in ipairs(vim.tbl_filter(opts.filter, api.nvim_list_bufs())) do
      if vim.bo[b].buflisted then
        delete(vim.tbl_extend('force', {}, opts, { buf = b, filter = false }))
      end
    end
    return
  end

  local buf = opts.buf or 0
  buf = buf == 0 and api.nvim_get_current_buf() or buf

  api.nvim_buf_call(buf, function()
    if vim.bo.modified and not opts.force then
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
      api.nvim_win_call(win, function()
        if not api.nvim_win_is_valid(win) or api.nvim_win_get_buf(win) ~= buf then
          return
        end
        -- Try using alternate buffer
        local alt = vim.fn.bufnr('#')
        if alt ~= buf and vim.fn.buflisted(alt) == 1 then
          api.nvim_win_set_buf(win, alt)
          return
        end

        -- Try using previous buffer
        local has_previous = pcall(vim.cmd, 'bprevious')
        if has_previous and buf ~= api.nvim_win_get_buf(win) then
          return
        end

        -- Create new listed buffer
        local new_buf = api.nvim_create_buf(true, false)
        api.nvim_win_set_buf(win, new_buf)
      end)
    end
    if api.nvim_buf_is_valid(buf) then
      pcall(vim.cmd, (opts.wipe and 'bwipeout! ' or 'bdelete! ') .. buf)
    end
  end)
end

api.nvim_create_user_command('Bdelete', delete, {})
