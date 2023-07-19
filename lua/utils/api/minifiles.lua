-- Plugin Auther
-- https://github.com/echasnovski/mini.nvim

local MiniFiles = {}
local H = {}

MiniFiles.setup = function(config)
  _G.MiniFiles = MiniFiles

  config = H.setup_config(config)

  H.apply_config(config)

  H.create_autocommands(config)

  H.create_default_hl()
end

MiniFiles.config = {

  content = {

    filter = nil,

    prefix = nil,

    sort = nil,
  },

  mappings = {
    close = 'q',
    go_in = 'l',
    go_in_plus = 'L',
    go_out = 'h',
    go_out_plus = 'H',
    reset = '<BS>',
    reveal_cwd = '@',
    show_help = 'g?',
    synchronize = '<CR>',
    trim_left = '<',
    trim_right = '>',
  },

  options = {

    permanent_delete = true,

    use_as_default_explorer = true,
  },

  windows = {

    max_number = math.huge,

    preview = false,

    width_focus = 50,

    width_nofocus = 15,

    width_preview = 25,
  },
}

MiniFiles.open = function(path, use_latest, opts)
  path = H.fs_full_path(path or vim.fn.getcwd())

  local fs_type = H.fs_get_type(path)
  if fs_type == nil then
    H.error('`path` is not a valid path ("' .. path .. '")')
  end

  local entry_name
  if fs_type == 'file' then
    path, entry_name = H.fs_get_parent(path), H.fs_get_basename(path)
  end

  if use_latest == nil then
    use_latest = true
  end

  local did_close = MiniFiles.close()
  if did_close == false then
    return
  end

  local explorer
  if use_latest then
    explorer = H.explorer_path_history[path]
  end
  explorer = explorer or H.explorer_new(path)

  explorer.opts = H.normalize_opts(nil, opts)
  explorer.target_window = vim.api.nvim_get_current_win()

  explorer = H.explorer_focus_on_entry(explorer, path, entry_name)

  H.explorer_refresh(explorer)

  H.latest_paths[vim.api.nvim_get_current_tabpage()] = path
end

MiniFiles.refresh = function(opts)
  local explorer = H.explorer_get()
  if explorer == nil then
    return
  end

  local content_opts = (opts or {}).content or {}
  local force_update = #vim.tbl_keys(content_opts) > 0

  if force_update then
    force_update = H.explorer_confirm_modified(explorer, 'buffer updates')
  end

  explorer.opts = H.normalize_opts(explorer.opts, opts)

  H.explorer_refresh(explorer, { force_update = force_update })
end

MiniFiles.synchronize = function()
  local explorer = H.explorer_get()
  if explorer == nil then
    return
  end

  local fs_actions = H.explorer_compute_fs_actions(explorer)
  if fs_actions ~= nil and H.fs_actions_confirm(fs_actions) then
    H.fs_actions_apply(fs_actions, explorer.opts)
  end

  H.explorer_refresh(explorer, { force_update = true })
end

MiniFiles.reset = function()
  local explorer = H.explorer_get()
  if explorer == nil then
    return
  end

  explorer.branch = { explorer.anchor }
  explorer.depth_focus = 1

  for _, view in pairs(explorer.views) do
    view.cursor = { 1, 0 }
  end

  H.explorer_refresh(explorer, { skip_update_cursor = true })
end

MiniFiles.close = function()
  local explorer = H.explorer_get()
  if explorer == nil then
    return nil
  end

  if not H.explorer_confirm_modified(explorer, 'close') then
    return false
  end

  explorer = H.explorer_ensure_target_window(explorer)
  vim.api.nvim_set_current_win(explorer.target_window)

  explorer = H.explorer_update_cursors(explorer)

  for i, win_id in pairs(explorer.windows) do
    H.window_close(win_id)
    explorer.windows[i] = nil
  end

  for _, win_id in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf_id = vim.api.nvim_win_get_buf(win_id)
    if vim.bo[buf_id].filetype == 'minifiles-help' then
      vim.api.nvim_win_close(win_id, true)
    end
  end

  for path, view in pairs(explorer.views) do
    explorer.views[path] = H.view_invalidate_buffer(H.view_encode_cursor(view))
  end

  local tabpage_id, anchor = vim.api.nvim_get_current_tabpage(), explorer.anchor
  H.explorer_path_history[anchor] = explorer
  H.opened_explorers[tabpage_id] = nil

  return true
end

MiniFiles.go_in = function()
  local explorer = H.explorer_get()
  if explorer == nil then
    return
  end

  local cur_line = vim.fn.line('.')
  explorer = H.explorer_go_in_range(explorer, vim.api.nvim_get_current_buf(), cur_line, cur_line)

  H.explorer_refresh(explorer)
end

MiniFiles.go_out = function()
  local explorer = H.explorer_get()
  if explorer == nil then
    return
  end

  if explorer.depth_focus == 1 then
    explorer = H.explorer_open_root_parent(explorer)
  else
    explorer.depth_focus = explorer.depth_focus - 1
  end

  H.explorer_refresh(explorer)
end

MiniFiles.trim_left = function()
  local explorer = H.explorer_get()
  if explorer == nil then
    return
  end

  explorer = H.explorer_trim_branch_left(explorer)
  H.explorer_refresh(explorer)
end

MiniFiles.trim_right = function()
  local explorer = H.explorer_get()
  if explorer == nil then
    return
  end

  explorer = H.explorer_trim_branch_right(explorer)
  H.explorer_refresh(explorer)
end

MiniFiles.reveal_cwd = function()
  local explorer = H.explorer_get()
  if explorer == nil then
    return
  end

  local cwd = H.fs_full_path(vim.fn.getcwd())
  local cwd_ancestor_pattern = string.format('^%s/.', vim.pesc(cwd))
  while explorer.branch[1]:find(cwd_ancestor_pattern) ~= nil do
    local parent, name = H.fs_get_parent(explorer.branch[1]), H.fs_get_basename(explorer.branch[1])
    table.insert(explorer.branch, 1, parent)

    explorer.depth_focus = explorer.depth_focus + 1

    local parent_view = explorer.views[parent] or {}
    parent_view.cursor = name
    explorer.views[parent] = parent_view
  end

  H.explorer_refresh(explorer)
end

MiniFiles.show_help = function()
  local explorer = H.explorer_get()
  if explorer == nil then
    return
  end

  local buf_id = vim.api.nvim_get_current_buf()
  if not H.is_opened_buffer(buf_id) then
    return
  end

  H.explorer_show_help(buf_id, vim.api.nvim_get_current_win())
end

MiniFiles.get_fs_entry = function(buf_id, line)
  buf_id = H.validate_opened_buffer(buf_id)
  line = H.validate_line(buf_id, line)

  local path_id = H.match_line_path_id(H.get_bufline(buf_id, line))
  if path_id == nil then
    return nil
  end

  local path = H.path_index[path_id]
  return { fs_type = H.fs_get_type(path), name = H.fs_get_basename(path), path = path }
end

MiniFiles.get_target_window = function()
  local explorer = H.explorer_get()
  if explorer == nil then
    return
  end

  explorer = H.explorer_ensure_target_window(explorer)
  return explorer.target_window
end

MiniFiles.set_target_window = function(win_id)
  if not H.is_valid_win(win_id) then
    H.error('`win_id` should be valid window identifier.')
  end

  local explorer = H.explorer_get()
  if explorer == nil then
    return
  end

  explorer.target_window = win_id
end

MiniFiles.get_latest_path = function()
  return H.latest_paths[vim.api.nvim_get_current_tabpage()]
end

MiniFiles.default_filter = function(fs_entry)
  return true
end

MiniFiles.default_prefix = function(fs_entry)
  if fs_entry.fs_type == 'directory' then
    return ' ', 'MiniFilesDirectory'
  end
  local has_devicons, devicons = pcall(require, 'nvim-web-devicons')
  if not has_devicons then
    return ' ', 'MiniFilesFile'
  end

  local icon, hl = devicons.get_icon(fs_entry.name, nil, { default = false })
  return (icon or '') .. ' ', hl or 'MiniFilesFile'
end

MiniFiles.default_sort = function(fs_entries)
  local res = vim.tbl_map(function(x)
    return {
      fs_type = x.fs_type,
      name = x.name,
      path = x.path,
      lower_name = x.name:lower(),
      is_dir = x.fs_type == 'directory',
    }
  end, fs_entries)

  table.sort(res, H.compare_fs_entries)

  return vim.tbl_map(function(x)
    return { name = x.name, fs_type = x.fs_type, path = x.path }
  end, res)
end

H.default_config = MiniFiles.config

H.ns_id = {
  highlight = vim.api.nvim_create_namespace('MiniFilesHighlight'),
}

H.path_index = {}

H.explorer_path_history = {}

H.opened_explorers = {}

H.latest_paths = {}

H.opened_buffers = {}

H.is_windows = vim.loop.os_uname().sysname == 'Windows_NT'

H.block_event_trigger = {}

H.setup_config = function(config)
  vim.validate({ config = { config, 'table', true } })
  config = vim.tbl_deep_extend('force', H.default_config, config or {})

  vim.validate({
    content = { config.content, 'table' },
    mappings = { config.mappings, 'table' },
    options = { config.options, 'table' },
    windows = { config.windows, 'table' },
  })

  vim.validate({
    ['content.filter'] = { config.content.filter, 'function', true },
    ['content.prefix'] = { config.content.prefix, 'function', true },
    ['content.sort'] = { config.content.sort, 'function', true },

    ['mappings.close'] = { config.mappings.close, 'string' },
    ['mappings.go_in'] = { config.mappings.go_in, 'string' },
    ['mappings.go_in_plus'] = { config.mappings.go_in_plus, 'string' },
    ['mappings.go_out'] = { config.mappings.go_out, 'string' },
    ['mappings.go_out_plus'] = { config.mappings.go_out_plus, 'string' },
    ['mappings.reset'] = { config.mappings.reset, 'string' },
    ['mappings.reveal_cwd'] = { config.mappings.reveal_cwd, 'string' },
    ['mappings.show_help'] = { config.mappings.show_help, 'string' },
    ['mappings.synchronize'] = { config.mappings.synchronize, 'string' },
    ['mappings.trim_left'] = { config.mappings.trim_left, 'string' },
    ['mappings.trim_right'] = { config.mappings.trim_right, 'string' },

    ['options.use_as_default_explorer'] = { config.options.use_as_default_explorer, 'boolean' },
    ['options.permanent_delete'] = { config.options.permanent_delete, 'boolean' },

    ['windows.max_number'] = { config.windows.max_number, 'number' },
    ['windows.preview'] = { config.windows.preview, 'boolean' },
    ['windows.width_focus'] = { config.windows.width_focus, 'number' },
    ['windows.width_nofocus'] = { config.windows.width_nofocus, 'number' },
    ['windows.width_preview'] = { config.windows.width_preview, 'number' },
  })

  return config
end

H.apply_config = function(config)
  MiniFiles.config = config
end

H.create_autocommands = function(config)
  local augroup = vim.api.nvim_create_augroup('MiniFiles', {})

  local au = function(event, pattern, callback, desc)
    vim.api.nvim_create_autocmd(
      event,
      { group = augroup, pattern = pattern, callback = callback, desc = desc }
    )
  end

  au('VimResized', '*', MiniFiles.refresh, 'Refresh on resize')

  if config.options.use_as_default_explorer then
    vim.cmd('silent! autocmd! FileExplorer *')
    vim.cmd('autocmd VimEnter * ++once silent! autocmd! FileExplorer *')

    au('BufEnter', '*', H.track_dir_edit, 'Track directory edit')
  end
end

H.create_default_hl = function()
  local hi = function(name, opts)
    opts.default = true
    vim.api.nvim_set_hl(0, name, opts)
  end

  hi('MiniFilesBorder', { link = 'FloatBorder' })
  hi('MiniFilesBorderModified', { link = 'DiagnosticFloatingWarn' })
  hi('MiniFilesDirectory', { link = 'Directory' })
  hi('MiniFilesFile', {})
  hi('MiniFilesNormal', { link = 'NormalFloat' })
  hi('MiniFilesTitle', { link = 'FloatTitle' })
  hi('MiniFilesTitleFocused', { link = 'FloatTitle' })
end

H.get_config = function(config)
  return vim.tbl_deep_extend('force', MiniFiles.config, vim.b.minifiles_config or {}, config or {})
end

H.normalize_opts = function(explorer_opts, opts)
  opts = vim.tbl_deep_extend('force', H.get_config(), explorer_opts or {}, opts or {})
  opts.content.filter = opts.content.filter or MiniFiles.default_filter
  opts.content.prefix = opts.content.prefix or MiniFiles.default_prefix
  opts.content.sort = opts.content.sort or MiniFiles.default_sort

  return opts
end

H.track_dir_edit = function(data)
  local buf_id = data.buf

  if vim.b[buf_id].minifiles_processed_dir then
    vim.api.nvim_buf_delete(buf_id, { force = true })
    return
  end

  if vim.api.nvim_get_current_buf() ~= buf_id then
    return
  end

  local path = vim.api.nvim_buf_get_name(buf_id)
  if vim.fn.isdirectory(path) ~= 1 then
    return
  end

  vim.bo[buf_id].bufhidden = 'wipe'
  vim.b[buf_id].minifiles_processed_dir = true

  vim.schedule(function()
    MiniFiles.open(path, false)
  end)
end

H.explorer_new = function(path)
  return {
    branch = { path },
    depth_focus = 1,
    views = {},
    windows = {},
    anchor = path,
    target_window = vim.api.nvim_get_current_win(),
    opts = {},
  }
end

H.explorer_get = function(tabpage_id)
  tabpage_id = tabpage_id or vim.api.nvim_get_current_tabpage()
  local res = H.opened_explorers[tabpage_id]

  if H.explorer_is_visible(res) then
    return res
  end

  H.opened_explorers[tabpage_id] = nil
  return nil
end

H.explorer_is_visible = function(explorer)
  if explorer == nil then
    return nil
  end
  for _, win_id in ipairs(explorer.windows) do
    if H.is_valid_win(win_id) then
      return true
    end
  end
  return false
end

H.explorer_refresh = function(explorer, opts)
  explorer = H.explorer_normalize(explorer)
  if #explorer.branch == 0 then
    return
  end
  opts = opts or {}

  if not opts.skip_update_cursor then
    explorer = H.explorer_update_cursors(explorer)
  end

  if opts.force_update then
    for path, view in pairs(explorer.views) do
      view = H.view_encode_cursor(view)
      view.children_path_ids = H.buffer_update(view.buf_id, path, explorer.opts)
      explorer.views[path] = view
    end
  end

  for depth = 1, #explorer.branch do
    explorer = H.explorer_sync_cursor_and_branch(explorer, depth)
  end

  for _, win_id in ipairs(explorer.windows) do
    local buf_id = vim.api.nvim_win_get_buf(win_id)
    H.opened_buffers[buf_id].win_id = nil
  end

  local depth_range = H.compute_visible_depth_range(explorer, explorer.opts)

  local cur_win_col, cur_win_count = 0, 0
  for depth = depth_range.from, depth_range.to do
    cur_win_count = cur_win_count + 1
    local cur_width = H.explorer_refresh_depth_window(explorer, depth, cur_win_count, cur_win_col)

    cur_win_col = cur_win_col + cur_width + 2
  end

  for depth = cur_win_count + 1, #explorer.windows do
    H.window_close(explorer.windows[depth])
    explorer.windows[depth] = nil
  end

  local win_focus_count = explorer.depth_focus - depth_range.from + 1
  local win_id_focused = explorer.windows[win_focus_count]
  H.window_focus(win_id_focused)

  local tabpage_id = vim.api.nvim_win_get_tabpage(win_id_focused)
  H.opened_explorers[tabpage_id] = explorer

  return explorer
end

H.explorer_normalize = function(explorer)
  local norm_branch = {}
  for _, path in ipairs(explorer.branch) do
    if not H.fs_is_present_path(path) then
      break
    end
    table.insert(norm_branch, path)
  end

  local cur_max_depth = #norm_branch

  explorer.branch = norm_branch
  explorer.depth_focus = math.min(math.max(explorer.depth_focus, 1), cur_max_depth)

  for i = cur_max_depth + 1, #explorer.windows do
    H.window_close(explorer.windows[i])
    explorer.windows[i] = nil
  end

  return explorer
end

H.explorer_sync_cursor_and_branch = function(explorer, depth)
  if #explorer.branch < depth then
    return explorer
  end

  local path, path_to_right = explorer.branch[depth], explorer.branch[depth + 1]
  local view = explorer.views[path]
  if view == nil then
    return explorer
  end

  local buf_id, cursor = view.buf_id, view.cursor
  if cursor == nil then
    return explorer
  end

  local cursor_path
  if type(cursor) == 'table' and H.is_valid_buf(buf_id) then
    local l = H.get_bufline(buf_id, cursor[1])
    cursor_path = H.path_index[H.match_line_path_id(l)]
  elseif type(cursor) == 'string' then
    cursor_path = H.fs_child_path(path, cursor)
  else
    return explorer
  end

  if cursor_path == path_to_right then
    return explorer
  end

  for i = depth + 1, #explorer.branch do
    explorer.branch[i] = nil
  end
  explorer.depth_focus = math.min(explorer.depth_focus, #explorer.branch)

  local show_preview = explorer.opts.windows.preview
  local path_is_present = type(cursor_path) == 'string' and H.fs_is_present_path(cursor_path)
  local is_cur_buf = buf_id == vim.api.nvim_get_current_buf()
  if show_preview and path_is_present and is_cur_buf then
    table.insert(explorer.branch, cursor_path)
  end

  return explorer
end

H.explorer_go_in_range = function(explorer, buf_id, from_line, to_line)
  local files, path, line = {}, nil, nil
  for i = from_line, to_line do
    local fs_entry = MiniFiles.get_fs_entry(buf_id, i) or {}
    if fs_entry.fs_type == 'file' then
      table.insert(files, fs_entry.path)
    end
    if fs_entry.fs_type == 'directory' then
      path, line = fs_entry.path, i
    end
  end

  for _, file_path in ipairs(files) do
    explorer = H.explorer_open_file(explorer, file_path)
  end

  if path ~= nil then
    explorer = H.explorer_open_directory(explorer, path, explorer.depth_focus + 1)

    local win_id = H.opened_buffers[buf_id].win_id
    if H.is_valid_win(win_id) then
      vim.api.nvim_win_set_cursor(win_id, { line, 0 })
    end
  end

  return explorer
end

H.explorer_focus_on_entry = function(explorer, path, entry_name)
  if entry_name == nil then
    return explorer
  end

  explorer.depth_focus = H.explorer_get_path_depth(explorer, path)
  if explorer.depth_focus == nil then
    explorer.branch, explorer.depth_focus = { path }, 1
  end

  local path_view = explorer.views[path] or {}
  path_view.cursor = entry_name
  explorer.views[path] = path_view

  return explorer
end

H.explorer_compute_fs_actions = function(explorer)
  local fs_diffs = {}
  for _, view in pairs(explorer.views) do
    local dir_fs_diff = H.buffer_compute_fs_diff(view.buf_id, view.children_path_ids)
    if #dir_fs_diff > 0 then
      vim.list_extend(fs_diffs, dir_fs_diff)
    end
  end
  if #fs_diffs == 0 then
    return nil
  end

  local create, delete_map, rename, move, raw_copy = {}, {}, {}, {}, {}

  for _, diff in ipairs(fs_diffs) do
    if diff.from == nil then
      table.insert(create, diff.to)
    elseif diff.to == nil then
      delete_map[diff.from] = true
    else
      table.insert(raw_copy, diff)
    end
  end

  local copy = {}
  for _, diff in pairs(raw_copy) do
    if delete_map[diff.from] then
      if H.fs_get_parent(diff.from) == H.fs_get_parent(diff.to) then
        table.insert(rename, diff)
      else
        table.insert(move, diff)
      end

      delete_map[diff.from] = nil
    else
      table.insert(copy, diff)
    end
  end

  return { create = create, delete = vim.tbl_keys(delete_map), copy = copy, rename = rename, move = move }
end

H.explorer_update_cursors = function(explorer)
  for _, win_id in ipairs(explorer.windows) do
    if H.is_valid_win(win_id) then
      local buf_id = vim.api.nvim_win_get_buf(win_id)
      local path = H.opened_buffers[buf_id].path
      explorer.views[path].cursor = vim.api.nvim_win_get_cursor(win_id)
    end
  end

  return explorer
end

H.explorer_refresh_depth_window = function(explorer, depth, win_count, win_col)
  local path = explorer.branch[depth]
  local views, windows, opts = explorer.views, explorer.windows, explorer.opts

  local view = views[path] or {}
  view = H.view_ensure_proper(view, path, opts)
  views[path] = view

  local win_is_focused = depth == explorer.depth_focus
  local win_is_preview = opts.windows.preview and (depth == (explorer.depth_focus + 1))
  local cur_width = win_is_focused and opts.windows.width_focus
    or (win_is_preview and opts.windows.width_preview or opts.windows.width_nofocus)

  local config = {
    col = win_col,
    height = vim.api.nvim_buf_line_count(view.buf_id),
    width = cur_width,

    title = win_count == 1 and H.fs_shorten_path(H.fs_full_path(path)) or H.fs_get_basename(path),
  }

  local win_id = windows[win_count]
  if not H.is_valid_win(win_id) then
    H.window_close(win_id)
    win_id = H.window_open(view.buf_id, config)
    windows[win_count] = win_id
  end

  H.window_update(win_id, config)

  H.window_set_view(win_id, view)

  explorer.views = views
  explorer.windows = windows

  return cur_width
end

H.explorer_get_path_depth = function(explorer, path)
  for depth, depth_path in pairs(explorer.branch) do
    if path == depth_path then
      return depth
    end
  end
end

H.explorer_confirm_modified = function(explorer, action_name)
  local has_modified = false
  for _, view in pairs(explorer.views) do
    if H.is_modified_buffer(view.buf_id) then
      has_modified = true
    end
  end

  if not has_modified then
    return true
  end

  local msg =
    string.format('There is at least one modified buffer\n\nConfirm %s without synchronization?', action_name)
  local confirm_res = vim.fn.confirm(msg, '&Yes\n&No', 1, 'Question')
  return confirm_res == 1
end

H.explorer_open_file = function(explorer, path)
  explorer = H.explorer_ensure_target_window(explorer)

  local path_buf_id
  for _, buf_id in ipairs(vim.api.nvim_list_bufs()) do
    if H.is_valid_buf(buf_id) and vim.api.nvim_buf_get_name(buf_id) == path then
      path_buf_id = buf_id
    end
  end

  if path_buf_id ~= nil then
    vim.api.nvim_win_set_buf(explorer.target_window, path_buf_id)
  else
    pcall(vim.fn.win_execute, explorer.target_window, 'edit ' .. vim.fn.fnameescape(path))
  end

  return explorer
end

H.explorer_ensure_target_window = function(explorer)
  if not H.is_valid_win(explorer.target_window) then
    explorer.target_window = H.get_first_valid_normal_window()
  end
  return explorer
end

H.explorer_open_directory = function(explorer, path, target_depth)
  explorer.depth_focus = target_depth

  local show_new_path_at_depth = path ~= explorer.branch[target_depth]
  if show_new_path_at_depth then
    explorer.branch[target_depth] = path
    explorer = H.explorer_trim_branch_right(explorer)
  end

  return explorer
end

H.explorer_open_root_parent = function(explorer)
  local root = explorer.branch[1]
  local root_parent = H.fs_get_parent(root)
  if root_parent == nil then
    return explorer
  end

  table.insert(explorer.branch, 1, root_parent)

  return H.explorer_focus_on_entry(explorer, root_parent, H.fs_get_basename(root))
end

H.explorer_trim_branch_right = function(explorer)
  for i = explorer.depth_focus + 1, #explorer.branch do
    explorer.branch[i] = nil
  end
  return explorer
end

H.explorer_trim_branch_left = function(explorer)
  local new_branch = {}
  for i = explorer.depth_focus, #explorer.branch do
    table.insert(new_branch, explorer.branch[i])
  end
  explorer.branch = new_branch
  explorer.depth_focus = 1
  return explorer
end

H.explorer_show_help = function(explorer_buf_id, explorer_win_id)
  local buf_mappings = vim.api.nvim_buf_get_keymap(explorer_buf_id, 'n')
  local map_data, desc_width = {}, 0
  for _, data in ipairs(buf_mappings) do
    if data.desc ~= nil then
      map_data[data.desc] = data.lhs:lower() == '<lt>' and '<' or data.lhs
      desc_width = math.max(desc_width, data.desc:len())
    end
  end

  local desc_arr = vim.tbl_keys(map_data)
  table.sort(desc_arr)
  local map_format = string.format('%%-%ds │ %%s', desc_width)

  local lines = { 'Buffer mappings:', '' }
  for _, desc in ipairs(desc_arr) do
    table.insert(lines, string.format(map_format, desc, map_data[desc]))
  end
  table.insert(lines, '')
  table.insert(lines, '(Press `q` to close)')

  local buf_id = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)

  vim.keymap.set('n', 'q', '<Cmd>close<CR>', { buffer = buf_id, desc = 'Close this window' })

  vim.b[buf_id].minicursorword_disable = true
  vim.b[buf_id].miniindentscope_disable = true

  vim.bo[buf_id].filetype = 'minifiles-help'

  local line_widths = vim.tbl_map(vim.fn.strdisplaywidth, lines)
  local max_line_width = math.max(unpack(line_widths))

  local config = vim.api.nvim_win_get_config(explorer_win_id)
  config.relative = 'win'
  config.row = 0
  config.col = 0
  config.width = max_line_width
  config.height = #lines
  config.title = vim.fn.has('nvim-0.9') == 1 and [['mini.files' help]] or nil
  config.zindex = config.zindex + 1
  config.style = 'minimal'

  local win_id = vim.api.nvim_open_win(buf_id, false, config)
  H.window_update_highlight(win_id, 'NormalFloat', 'MiniFilesNormal')
  H.window_update_highlight(win_id, 'FloatTitle', 'MiniFilesTitle')
  vim.wo[win_id].cursorline = true

  vim.api.nvim_set_current_win(win_id)
  return win_id
end

H.compute_visible_depth_range = function(explorer, opts)
  local width_focus, width_nofocus = opts.windows.width_focus + 2, opts.windows.width_nofocus + 2

  local has_preview = explorer.opts.windows.preview and explorer.depth_focus < #explorer.branch
  local width_preview = has_preview and (opts.windows.width_preview + 2) or width_nofocus

  local max_number = 1
  if (width_focus + width_preview) <= vim.o.columns then
    max_number = max_number + 1
  end
  if (width_focus + width_preview + width_nofocus) <= vim.o.columns then
    max_number = max_number + math.floor((vim.o.columns - width_focus - width_preview) / width_nofocus)
  end

  max_number = math.min(math.max(max_number, 1), opts.windows.max_number)

  local branch_depth, depth_focus = #explorer.branch, explorer.depth_focus
  local n_panes = math.min(branch_depth, max_number)

  local to = math.min(branch_depth, math.floor(depth_focus + 0.5 * n_panes))
  local from = math.max(1, to - n_panes + 1)
  to = from + math.min(n_panes, branch_depth) - 1

  return { from = from, to = to }
end

H.view_ensure_proper = function(view, path, opts)
  if not H.is_valid_buf(view.buf_id) then
    H.buffer_delete(view.buf_id)
    view.buf_id = H.buffer_create(path, opts.mappings)
    view.children_path_ids = H.buffer_update(view.buf_id, path, opts)
  end

  view.cursor = view.cursor or { 1, 0 }
  if type(view.cursor) == 'string' then
    view = H.view_decode_cursor(view)
  end

  return view
end

H.view_encode_cursor = function(view)
  local buf_id, cursor = view.buf_id, view.cursor
  if not H.is_valid_buf(buf_id) or type(cursor) ~= 'table' then
    return view
  end

  local l = H.get_bufline(buf_id, cursor[1])
  view.cursor = H.match_line_entry_name(l)
  return view
end

H.view_decode_cursor = function(view)
  local buf_id, cursor = view.buf_id, view.cursor
  if not H.is_valid_buf(buf_id) or type(cursor) ~= 'string' then
    return view
  end

  local lines = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)
  for i, l in ipairs(lines) do
    if cursor == H.match_line_entry_name(l) then
      view.cursor = { i, 0 }
    end
  end

  if type(view.cursor) ~= 'table' then
    view.cursor = { 1, 0 }
  end

  return view
end

H.view_invalidate_buffer = function(view)
  H.buffer_delete(view.buf_id)
  view.buf_id = nil
  view.children_path_ids = nil
  return view
end

H.view_track_cursor = vim.schedule_wrap(function(data)
  local buf_id = data.buf
  local buf_data = H.opened_buffers[buf_id]
  if buf_data == nil then
    return
  end

  local win_id = buf_data.win_id
  if not H.is_valid_win(win_id) then
    return
  end

  local cur_cursor = vim.api.nvim_win_get_cursor(win_id)
  local l = H.get_bufline(buf_id, cur_cursor[1])

  local cur_offset = H.match_line_offset(l)
  if cur_cursor[2] < (cur_offset - 1) then
    vim.api.nvim_win_set_cursor(win_id, { cur_cursor[1], cur_offset - 1 })

    vim.cmd('normal! 1000zh')
  end

  local tabpage_id = vim.api.nvim_win_get_tabpage(win_id)
  local explorer = H.explorer_get(tabpage_id)
  if explorer == nil then
    return
  end

  local buf_depth = H.explorer_get_path_depth(explorer, buf_data.path)
  if buf_depth == nil then
    return
  end

  local view = explorer.views[buf_data.path]
  if view ~= nil then
    view.cursor = cur_cursor
    explorer.views[buf_data.path] = view
  end

  explorer = H.explorer_sync_cursor_and_branch(explorer, buf_depth)

  H.block_event_trigger['MiniFilesWindowUpdate'] = true
  H.explorer_refresh(explorer)
  H.block_event_trigger['MiniFilesWindowUpdate'] = false
end)

H.view_track_text_change = function(data)
  local buf_id = data.buf
  local new_n_modified = H.opened_buffers[buf_id].n_modified + 1
  H.opened_buffers[buf_id].n_modified = new_n_modified
  local win_id = H.opened_buffers[buf_id].win_id
  if new_n_modified > 0 and H.is_valid_win(win_id) then
    H.window_update_border_hl(win_id)
  end

  if not H.is_valid_win(win_id) then
    return
  end

  local n_lines = vim.api.nvim_buf_line_count(buf_id)
  local height = math.min(n_lines, H.window_get_max_height())
  vim.api.nvim_win_set_height(win_id, height)

  local last_visible_line = vim.fn.line('w0', win_id) + height - 1
  local out_of_buf_lines = last_visible_line - n_lines

  if out_of_buf_lines > 0 then
    vim.cmd('normal! ' .. out_of_buf_lines .. '\25')
  end
end

H.buffer_create = function(path, mappings)
  local buf_id = vim.api.nvim_create_buf(false, true)

  H.opened_buffers[buf_id] = { path = path }

  H.buffer_make_mappings(buf_id, mappings)

  local augroup = vim.api.nvim_create_augroup('MiniFiles', { clear = false })
  local au = function(events, desc, callback)
    vim.api.nvim_create_autocmd(
      events,
      { group = augroup, buffer = buf_id, desc = desc, callback = callback }
    )
  end

  au({ 'CursorMoved', 'CursorMovedI' }, 'Tweak cursor position', H.view_track_cursor)
  au({ 'TextChanged', 'TextChangedI', 'TextChangedP' }, 'Track buffer modification', H.view_track_text_change)

  vim.b[buf_id].minicursorword_disable = true

  vim.bo[buf_id].filetype = 'minifiles'

  H.trigger_event('MiniFilesBufferCreate', { buf_id = buf_id })

  return buf_id
end

H.buffer_make_mappings = function(buf_id, mappings)
  local go_in_with_count = function()
    for _ = 1, vim.v.count1 do
      MiniFiles.go_in()
    end
  end

  local go_in_plus = function()
    for _ = 1, vim.v.count1 - 1 do
      MiniFiles.go_in()
    end
    local fs_entry = MiniFiles.get_fs_entry()
    local is_at_file = fs_entry ~= nil and fs_entry.fs_type == 'file'
    MiniFiles.go_in()
    if is_at_file then
      MiniFiles.close()
    end
  end

  local go_out_with_count = function()
    for _ = 1, vim.v.count1 do
      MiniFiles.go_out()
    end
  end

  local go_out_plus = function()
    go_out_with_count()
    MiniFiles.trim_right()
  end

  local go_in_visual = function()
    if vim.fn.mode() ~= 'V' then
      return mappings.go_in
    end

    local line_1, line_2 = vim.fn.line('v'), vim.fn.line('.')
    local from_line, to_line = math.min(line_1, line_2), math.max(line_1, line_2)
    vim.schedule(function()
      local explorer = H.explorer_get()
      explorer = H.explorer_go_in_range(explorer, buf_id, from_line, to_line)
      H.explorer_refresh(explorer)
    end)

    return [[<C-\><C-n>]]
  end

  local buf_map = function(mode, lhs, rhs, desc)
    H.map(mode, lhs, rhs, { buffer = buf_id, desc = desc, nowait = true })
  end

  buf_map('n', mappings.close, MiniFiles.close, 'Close')
  buf_map('n', mappings.go_in, go_in_with_count, 'Go in entry')
  buf_map('n', mappings.go_in_plus, go_in_plus, 'Go in entry plus')
  buf_map('n', mappings.go_out, go_out_with_count, 'Go out of directory')
  buf_map('n', mappings.go_out_plus, go_out_plus, 'Go out of directory plus')
  buf_map('n', mappings.reset, MiniFiles.reset, 'Reset')
  buf_map('n', mappings.reveal_cwd, MiniFiles.reveal_cwd, 'Reveal cwd')
  buf_map('n', mappings.show_help, MiniFiles.show_help, 'Show Help')
  buf_map('n', mappings.synchronize, MiniFiles.synchronize, 'Synchronize')
  buf_map('n', mappings.trim_left, MiniFiles.trim_left, 'Trim branch left')
  buf_map('n', mappings.trim_right, MiniFiles.trim_right, 'Trim branch right')

  H.map('x', mappings.go_in, go_in_visual, { buffer = buf_id, desc = 'Go in selected entries', expr = true })
end

H.buffer_update = function(buf_id, path, opts)
  if not (H.is_valid_buf(buf_id) and H.fs_is_present_path(path)) then
    return
  end

  local update_fun = H.fs_get_type(path) == 'directory' and H.buffer_update_directory or H.buffer_update_file
  local fs_entries = update_fun(buf_id, path, opts)

  H.trigger_event('MiniFilesBufferUpdate', { buf_id = buf_id, win_id = H.opened_buffers[buf_id].win_id })

  H.opened_buffers[buf_id].n_modified = -1

  return vim.tbl_map(function(x)
    return x.path_id
  end, fs_entries)
end

H.buffer_update_directory = function(buf_id, path, opts)
  local lines, icon_hl, name_hl = {}, {}, {}

  local fs_entries = H.fs_read_dir(path, opts.content)

  local path_width = math.floor(math.log10(#H.path_index)) + 1
  local line_format = '/%0' .. path_width .. 'd/%s/%s'

  local prefix_fun = opts.content.prefix
  for _, entry in ipairs(fs_entries) do
    local prefix, hl = prefix_fun(entry)
    prefix, hl = prefix or '', hl or ''
    table.insert(lines, string.format(line_format, H.path_index[entry.path], prefix, entry.name))
    table.insert(icon_hl, hl)
    table.insert(name_hl, entry.fs_type == 'directory' and 'MiniFilesDirectory' or 'MiniFilesFile')
  end

  H.set_buflines(buf_id, lines)

  local ns_id = H.ns_id.highlight
  vim.api.nvim_buf_clear_namespace(buf_id, ns_id, 0, -1)

  local set_hl = function(line, col, hl_opts)
    H.set_extmark(buf_id, ns_id, line, col, hl_opts)
  end

  for i, l in ipairs(lines) do
    local icon_start, name_start = l:match('^/%d+/().-()/')

    local icon_opts = { hl_group = icon_hl[i], end_col = name_start - 1, right_gravity = false }
    set_hl(i - 1, icon_start - 1, icon_opts)

    local name_opts = { hl_group = name_hl[i], end_row = i, end_col = 0, right_gravity = false }
    set_hl(i - 1, name_start - 1, name_opts)
  end

  return fs_entries
end

H.buffer_update_file = function(buf_id, path, opts)
  local fd = vim.loop.fs_open(path, 'r', 1)
  local is_text = vim.loop.fs_read(fd, 1024):find('\0') == nil
  vim.loop.fs_close(fd)
  if not is_text then
    H.set_buflines(buf_id, { '-Non-text-file' .. string.rep('-', opts.windows.width_preview) })
    return {}
  end

  local has_lines, read_res = pcall(vim.fn.readfile, path, '', vim.o.lines)

  local lines = has_lines and vim.split(table.concat(read_res, '\n'), '\n') or {}

  H.set_buflines(buf_id, lines)

  if vim.fn.has('nvim-0.8') == 1 then
    local ft = vim.filetype.match({ buf = buf_id, filename = path })
    local ok, _ = pcall(vim.treesitter.start, buf_id, ft)
    if not ok then
      vim.bo[buf_id].syntax = ft
    end
  end

  return {}
end

H.buffer_delete = function(buf_id)
  if buf_id == nil then
    return
  end
  pcall(vim.api.nvim_buf_delete, buf_id, { force = true })
  H.opened_buffers[buf_id] = nil
end

H.buffer_compute_fs_diff = function(buf_id, ref_path_ids)
  if not H.is_modified_buffer(buf_id) then
    return {}
  end

  local path = H.opened_buffers[buf_id].path
  local lines = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)
  local res, present_path_ids = {}, {}

  for _, l in ipairs(lines) do
    local path_id = H.match_line_path_id(l)
    local path_from = H.path_index[path_id]

    local name_to = path_id ~= nil and l:sub(H.match_line_offset(l)) or l

    local path_to = H.fs_child_path(path, name_to) .. (vim.endswith(name_to, '/') and '/' or '')

    if l:find('^%s*$') == nil and path_from ~= path_to then
      table.insert(res, { from = path_from, to = path_to })
    elseif path_id ~= nil then
      present_path_ids[path_id] = true
    end
  end

  for _, ref_id in ipairs(ref_path_ids) do
    if not present_path_ids[ref_id] then
      table.insert(res, { from = H.path_index[ref_id], to = nil })
    end
  end

  return res
end

H.is_opened_buffer = function(buf_id)
  return H.opened_buffers[buf_id] ~= nil
end

H.is_modified_buffer = function(buf_id)
  local data = H.opened_buffers[buf_id]
  return data ~= nil and data.n_modified > 0
end

H.match_line_entry_name = function(l)
  if l == nil then
    return nil
  end
  local offset = H.match_line_offset(l)

  local res = l:sub(offset):gsub('/.*$', '')
  return res
end

H.match_line_offset = function(l)
  if l == nil then
    return nil
  end
  return l:match('^/.-/.-/()') or 1
end

H.match_line_path_id = function(l)
  if l == nil then
    return nil
  end

  local id_str = l:match('^/(%d+)')
  local ok, res = pcall(tonumber, id_str)
  if not ok then
    return nil
  end
  return res
end

H.window_open = function(buf_id, config)
  config.anchor = 'NW'
  config.border = 'single'
  config.focusable = true
  config.relative = 'editor'
  config.style = 'minimal'

  config.zindex = 99

  config.row = 1

  if vim.fn.has('nvim-0.9') == 0 then
    config.title = nil
  end

  local win_id = vim.api.nvim_open_win(buf_id, false, config)

  vim.wo[win_id].concealcursor = 'nvic'
  vim.wo[win_id].foldenable = false
  vim.wo[win_id].wrap = false

  vim.api.nvim_win_call(win_id, function()
    vim.fn.matchadd('Conceal', [[^/\d\+/]])
    vim.fn.matchadd('Conceal', [[^/\d\+/[^/]*\zs/\ze]])
  end)

  H.window_update_highlight(win_id, 'NormalFloat', 'MiniFilesNormal')
  H.window_update_highlight(win_id, 'FloatTitle', 'MiniFilesTitle')

  H.trigger_event('MiniFilesWindowOpen', { buf_id = buf_id, win_id = win_id })

  return win_id
end

H.window_update = function(win_id, config)
  local has_tabline = vim.o.showtabline == 2 or (vim.o.showtabline == 1 and #vim.api.nvim_list_tabpages() > 1)
  local max_height = H.window_get_max_height()

  config.row = has_tabline and 1 or 0
  config.height = config.height ~= nil and math.min(config.height, max_height) or nil
  config.width = config.width ~= nil and math.min(config.width, vim.o.columns) or nil

  if vim.fn.has('nvim-0.9') == 1 and config.title ~= nil then
    local title_string, width = config.title, config.width
    local title_chars = vim.fn.strcharlen(title_string)
    if width < title_chars then
      title_string = '…' .. vim.fn.strcharpart(title_string, title_chars - width + 1, width - 1)
    end
    config.title = title_string
    config.border = vim.api.nvim_win_get_config(win_id).border
  else
    config.title = nil
  end

  config.relative = 'editor'
  vim.api.nvim_win_set_config(win_id, config)

  H.window_update_highlight(win_id, 'FloatTitle', 'MiniFilesTitle')

  vim.wo[win_id].cursorline = true

  vim.wo[win_id].conceallevel = 3

  H.trigger_event('MiniFilesWindowUpdate', { buf_id = vim.api.nvim_win_get_buf(win_id), win_id = win_id })
end

H.window_update_highlight = function(win_id, new_from, new_to)
  local new_entry = new_from .. ':' .. new_to
  local replace_pattern = string.format('(%s:[^,]*)', vim.pesc(new_from))
  local new_winhighlight, n_replace = vim.wo[win_id].winhighlight:gsub(replace_pattern, new_entry)
  if n_replace == 0 then
    new_winhighlight = new_winhighlight .. ',' .. new_entry
  end

  pcall(function()
    vim.wo[win_id].winhighlight = new_winhighlight
  end)
end

H.window_focus = function(win_id)
  vim.api.nvim_set_current_win(win_id)
  H.window_update_highlight(win_id, 'FloatTitle', 'MiniFilesTitleFocused')
end

H.window_close = function(win_id)
  if win_id == nil then
    return
  end
  local has_buffer, buf_id = pcall(vim.api.nvim_win_get_buf, win_id)
  if has_buffer then
    H.opened_buffers[buf_id].win_id = nil
  end
  pcall(vim.api.nvim_win_close, win_id, true)
end

H.window_set_view = function(win_id, view)
  local buf_id = view.buf_id
  vim.api.nvim_win_set_buf(win_id, buf_id)

  H.opened_buffers[buf_id].win_id = win_id

  pcall(vim.api.nvim_win_set_cursor, win_id, view.cursor)

  vim.wo[win_id].cursorline = true

  H.window_update_border_hl(win_id)
end

H.window_update_border_hl = function(win_id)
  if not H.is_valid_win(win_id) then
    return
  end
  local buf_id = vim.api.nvim_win_get_buf(win_id)

  local border_hl = H.is_modified_buffer(buf_id) and 'MiniFilesBorderModified' or 'MiniFilesBorder'
  H.window_update_highlight(win_id, 'FloatBorder', border_hl)
end

H.window_get_max_height = function()
  local has_tabline = vim.o.showtabline == 2 or (vim.o.showtabline == 1 and #vim.api.nvim_list_tabpages() > 1)
  local has_statusline = vim.o.laststatus > 0

  return vim.o.lines - vim.o.cmdheight - (has_tabline and 1 or 0) - (has_statusline and 1 or 0) - 2
end

H.fs_read_dir = function(path, content_opts)
  local fs = vim.loop.fs_scandir(path)
  local res = {}
  if not fs then
    return res
  end

  local name, fs_type = vim.loop.fs_scandir_next(fs)
  while name do
    if not (fs_type == 'file' or fs_type == 'directory') then
      fs_type = H.fs_get_type(H.fs_child_path(path, name))
    end
    table.insert(res, { fs_type = fs_type, name = name, path = H.fs_child_path(path, name) })
    name, fs_type = vim.loop.fs_scandir_next(fs)
  end

  res = content_opts.sort(vim.tbl_filter(content_opts.filter, res))

  for _, entry in ipairs(res) do
    entry.path_id = H.add_path_to_index(entry.path)
  end

  return res
end

H.add_path_to_index = function(path)
  local cur_id = H.path_index[path]
  if cur_id ~= nil then
    return cur_id
  end

  local new_id = #H.path_index + 1
  H.path_index[new_id] = path
  H.path_index[path] = new_id

  return new_id
end

H.compare_fs_entries = function(a, b)
  if a.is_dir and not b.is_dir then
    return true
  end
  if not a.is_dir and b.is_dir then
    return false
  end

  return a.lower_name < b.lower_name
end

H.fs_normalize_path = function(path)
  local res = path:gsub('\\', '/'):gsub('/+', '/'):gsub('(.)/$', '%1')
  return res
end

H.fs_is_present_path = function(path)
  return vim.loop.fs_stat(path) ~= nil
end

H.fs_child_path = function(dir, name)
  return H.fs_normalize_path(string.format('%s/%s', dir, name))
end

H.fs_full_path = function(path)
  return H.fs_normalize_path(vim.fn.fnamemodify(path, ':p'))
end

H.fs_shorten_path = function(path)
  path = H.fs_normalize_path(path)
  local home_dir = H.fs_normalize_path(vim.loop.os_homedir() or '~')
  local res = path:gsub('^' .. vim.pesc(home_dir), '~')
  return res
end

H.fs_get_basename = function(path)
  return H.fs_normalize_path(path):match('[^/]+$')
end

H.fs_get_parent = function(path)
  path = H.fs_full_path(path)

  local is_top = H.fs_is_windows_top(path) or path == '/'
  if is_top then
    return nil
  end

  local res = H.fs_normalize_path(path:match('^.*/'))

  local suffix = H.fs_is_windows_top(res) and '/' or ''
  return res .. suffix
end

H.fs_is_windows_top = function(path)
  return H.is_windows and path:find('^%w:[\\/]?$') ~= nil
end

H.fs_get_type = function(path)
  if not H.fs_is_present_path(path) then
    return nil
  end
  return vim.fn.isdirectory(path) == 1 and 'directory' or 'file'
end

H.fs_actions_confirm = function(fs_actions)
  local msg = table.concat(H.fs_actions_to_lines(fs_actions), '\n')
  local confirm_res = vim.fn.confirm(msg, '&Yes\n&No', 1, 'Question')
  return confirm_res == 1
end

H.fs_actions_to_lines = function(fs_actions)
  local actions_per_dir = {}

  local get_dir_actions = function(path)
    local dir_path = H.fs_shorten_path(H.fs_get_parent(path))
    local dir_actions = actions_per_dir[dir_path] or {}
    actions_per_dir[dir_path] = dir_actions
    return dir_actions
  end

  local get_quoted_basename = function(path)
    return string.format("'%s'", H.fs_get_basename(path))
  end

  for _, diff in ipairs(fs_actions.copy) do
    local dir_actions = get_dir_actions(diff.from)
    local l =
      string.format("    COPY: %s to '%s'", get_quoted_basename(diff.from), H.fs_shorten_path(diff.to))
    table.insert(dir_actions, l)
  end

  for _, path in ipairs(fs_actions.create) do
    local dir_actions = get_dir_actions(path)
    local fs_type = path:find('/$') == nil and 'file' or 'directory'
    local l = string.format('  CREATE: %s (%s)', get_quoted_basename(path), fs_type)
    table.insert(dir_actions, l)
  end

  for _, path in ipairs(fs_actions.delete) do
    local dir_actions = get_dir_actions(path)
    local l = string.format('  DELETE: %s', get_quoted_basename(path))
    table.insert(dir_actions, l)
  end

  for _, diff in ipairs(fs_actions.move) do
    local dir_actions = get_dir_actions(diff.from)
    local l =
      string.format("    MOVE: %s to '%s'", get_quoted_basename(diff.from), H.fs_shorten_path(diff.to))
    table.insert(dir_actions, l)
  end

  for _, diff in ipairs(fs_actions.rename) do
    local dir_actions = get_dir_actions(diff.from)
    local l =
      string.format('  RENAME: %s to %s', get_quoted_basename(diff.from), get_quoted_basename(diff.to))
    table.insert(dir_actions, l)
  end

  local res = { 'CONFIRM FILE SYSTEM ACTIONS', '' }
  for path, dir_actions in pairs(actions_per_dir) do
    table.insert(res, path .. ':')
    vim.list_extend(res, dir_actions)
    table.insert(res, '')
  end

  return res
end

H.fs_actions_apply = function(fs_actions, opts)
  for _, diff in ipairs(fs_actions.copy) do
    local ok, success = pcall(H.fs_copy, diff.from, diff.to)
    local data = { action = 'copy', from = diff.from, to = diff.to }
    if ok and success then
      H.trigger_event('MiniFilesActionCopy', data)
    end
  end

  for _, path in ipairs(fs_actions.create) do
    local ok, success = pcall(H.fs_create, path)
    local data = { action = 'create', to = H.fs_normalize_path(path) }
    if ok and success then
      H.trigger_event('MiniFilesActionCreate', data)
    end
  end

  for _, diff in ipairs(fs_actions.move) do
    local ok, success = pcall(H.fs_move, diff.from, diff.to)
    local data = { action = 'move', from = diff.from, to = diff.to }
    if ok and success then
      H.trigger_event('MiniFilesActionMove', data)
    end
  end

  for _, diff in ipairs(fs_actions.rename) do
    local ok, success = pcall(H.fs_rename, diff.from, diff.to)
    local data = { action = 'rename', from = diff.from, to = diff.to }
    if ok and success then
      H.trigger_event('MiniFilesActionRename', data)
    end
  end

  for _, path in ipairs(fs_actions.delete) do
    local ok, success = pcall(H.fs_delete, path, opts.options.permanent_delete)
    local data = { action = 'delete', from = path }
    if ok and success then
      H.trigger_event('MiniFilesActionDelete', data)
    end
  end
end

H.fs_create = function(path)
  if H.fs_is_present_path(path) then
    return false
  end

  vim.fn.mkdir(H.fs_get_parent(path), 'p')

  local fs_type = path:find('/$') == nil and 'file' or 'directory'
  if fs_type == 'directory' then
    return vim.fn.mkdir(path) == 1
  else
    return vim.fn.writefile({}, path) == 0
  end
end

H.fs_copy = function(from, to)
  if H.fs_is_present_path(to) then
    return false
  end

  local from_type = H.fs_get_type(from)
  if from_type == nil then
    return false
  end
  if from_type == 'file' then
    return vim.loop.fs_copyfile(from, to)
  end

  local fs_entries = H.fs_read_dir(from, {
    filter = function()
      return true
    end,
    sort = function(x)
      return x
    end,
  })

  vim.fn.mkdir(to)

  local success = true
  for _, entry in ipairs(fs_entries) do
    success = success and H.fs_copy(entry.path, H.fs_child_path(to, entry.name))
  end

  return success
end

H.fs_delete = function(path, permanent_delete)
  if permanent_delete then
    return vim.fn.delete(path, 'rf') == 0
  end

  local trash_dir = H.fs_child_path(vim.fn.stdpath('data'), 'mini.files/trash')
  vim.fn.mkdir(trash_dir, 'p')

  local trash_path = H.fs_child_path(trash_dir, H.fs_get_basename(path))

  pcall(vim.fn.delete, trash_path, 'rf')

  return vim.loop.fs_rename(path, trash_path)
end

H.fs_move = function(from, to)
  if H.fs_is_present_path(to) then
    return false
  end

  vim.fn.mkdir(H.fs_get_parent(to), 'p')
  local success = vim.loop.fs_rename(from, to)

  for _, buf_id in ipairs(vim.api.nvim_list_bufs()) do
    H.rename_loaded_buffer(buf_id, from, to)
  end

  return success
end

H.fs_rename = H.fs_move

H.rename_loaded_buffer = function(buf_id, from, to)
  if not (vim.api.nvim_buf_is_loaded(buf_id) and vim.bo[buf_id].buftype == '') then
    return
  end

  local cur_name = H.fs_normalize_path(vim.api.nvim_buf_get_name(buf_id))

  local new_name = cur_name:gsub('^' .. vim.pesc(from), to)
  if cur_name == new_name then
    return
  end
  vim.api.nvim_buf_set_name(buf_id, new_name)

  vim.api.nvim_buf_call(buf_id, function()
    vim.cmd('silent! write! | edit')
  end)
end

H.validate_opened_buffer = function(x)
  if x == nil or x == 0 then
    x = vim.api.nvim_get_current_buf()
  end
  if not H.is_opened_buffer(x) then
    H.error('`buf_id` should be an identifier of an opened directory buffer.')
  end
  return x
end

H.validate_line = function(buf_id, x)
  x = x or vim.fn.line('.')
  if not (type(x) == 'number' and 1 <= x and x <= vim.api.nvim_buf_line_count(buf_id)) then
    H.error('`line` should be a valid line number in buffer ' .. buf_id .. '.')
  end
  return x
end

H.error = function(msg)
  error(string.format('(mini.files) %s', msg), 0)
end

H.map = function(mode, lhs, rhs, opts)
  if lhs == '' then
    return
  end
  opts = vim.tbl_deep_extend('force', { silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

H.trigger_event = function(event_name, data)
  if H.block_event_trigger[event_name] then
    return
  end

  if vim.fn.has('nvim-0.8') == 0 then
    data = nil
  end
  vim.api.nvim_exec_autocmds('User', { pattern = event_name, data = data })
end

H.is_valid_buf = function(buf_id)
  return type(buf_id) == 'number' and vim.api.nvim_buf_is_valid(buf_id)
end

H.is_valid_win = function(win_id)
  return type(win_id) == 'number' and vim.api.nvim_win_is_valid(win_id)
end

H.get_bufline = function(buf_id, line)
  return vim.api.nvim_buf_get_lines(buf_id, line - 1, line, false)[1]
end

H.set_buflines = function(buf_id, lines)
  local cmd = string.format(
    'lockmarks lua vim.api.nvim_buf_set_lines(%d, 0, -1, false, %s)',
    buf_id,
    vim.inspect(lines)
  )
  vim.cmd(cmd)
end

H.set_extmark = function(...)
  pcall(vim.api.nvim_buf_set_extmark, ...)
end

H.get_first_valid_normal_window = function()
  for _, win_id in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_config(win_id).relative == '' then
      return win_id
    end
  end
end

return MiniFiles
