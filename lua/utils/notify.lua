local api = vim.api
local title = {
  [vim.log.levels.DEBUG] = ' Debug: ',
  [vim.log.levels.ERROR] = ' Error: ',
  [vim.log.levels.INFO] = ' Info: ',
  [vim.log.levels.TRACE] = ' Trace: ',
  [vim.log.levels.WARN] = ' Warning: ',
  [vim.log.levels.OFF] = '󰂛 Off: ',
}
local hls = {
  [vim.log.levels.DEBUG] = 'NotifyDebug',
  [vim.log.levels.ERROR] = 'NotifyError',
  [vim.log.levels.INFO] = 'NotifyInfo',
  [vim.log.levels.TRACE] = 'NotifyTrace',
  [vim.log.levels.WARN] = 'NotifyWarn',
  [vim.log.levels.OFF] = 'NotifyOff',
}

---@class PopupState
---@field win integer
---@field width integer
---@field height integer
---@field offset integer
---@field level integer
---@type PopupState[]
local displayed = {}
local ns = api.nvim_create_namespace('NanoNotify')

local function make_popup_opts(level, width, height, offset)
  local is_oneliner = height == 1
  local title_str = title[level] or (level and tostring(level)) or ''
  return {
    relative = 'editor',
    anchor = 'SE',
    width = is_oneliner and #title_str + width or math.max(width, #title_str + 1),
    height = height,
    row = vim.o.lines - offset,
    col = vim.o.columns,
    style = 'minimal',
    border = not is_oneliner and { ' ', ' ', ' ', ' ' } or 'none',
    title = not is_oneliner and { { title_str, hls[level] or 'NotifyInfo' } } or nil,
  }
end

local function register_callback(this, buf)
  vim.defer_fn(function()
    -- it is possible modify_existing rendered this callback as obsolete
    if not api.nvim_win_is_valid(this.win) then
      return
    end
    -- don't close this win if i want to check the message
    if api.nvim_get_current_buf() == buf then
      return
    end
    -- delete all info related to this message
    api.nvim_win_close(this.win, true)
    api.nvim_buf_delete(buf, { force = true })
    displayed[buf] = nil
    -- adjust all messages above us
    for sbuf, popup in pairs(displayed) do
      if popup.offset > this.offset then
        popup.offset = popup.offset - this.height
        if this.height ~= 1 then
          popup.offset = popup.offset - 2
        end
        api.nvim_win_close(popup.win, true)
        popup.win = api.nvim_open_win(
          sbuf,
          false,
          make_popup_opts(popup.level, popup.width, popup.height, popup.offset)
        )
      end
    end
  end, 3000)
end

---@class NotifyOpts
---@field modify_existing? boolean
---@field clear? boolean
---@param opts NotifyOpts
vim.notify = function(msg, level, opts)
  if not msg then
    return
  end
  level = level or vim.log.levels.INFO
  opts = opts or {}
  local lines = vim.split(msg, '\n')
  local formatted = {}
  local msg_max_len = math.floor(vim.o.columns / 3)

  -- wrap lines and record longgest message
  local line_max_len = -1
  for _, line in ipairs(lines) do
    if #line > line_max_len then
      line_max_len = #line
    end
    while #line > msg_max_len do
      table.insert(formatted, line:sub(0, msg_max_len))
      line = line:sub(msg_max_len + 1, -1)
    end
    table.insert(formatted, line)
  end
  if #formatted == 1 then
    formatted[1] = (title[level] or tostring(level)) .. formatted[1]
  end

  -- if clear is true we close all other windows
  if opts.clear then
    for sbuf, popup in pairs(displayed) do
      api.nvim_win_close(popup.win, true)
      api.nvim_buf_delete(sbuf, { force = true })
      displayed[sbuf] = nil
    end
  end

  -- if modify_existing we try to find an existing buffer
  if opts.modify_existing then
    local buf = opts.modify_existing
    if not displayed[buf] then
      return -1
    end
    local existing = displayed[buf]
    existing.level = level
    api.nvim_buf_set_lines(buf, 0, -1, false, formatted)
    for i = 0, #formatted - 1, 1 do
      api.nvim_buf_add_highlight(buf, ns, hls[level], i, 0, -1)
    end
    api.nvim_set_option_value('winhl', 'Normal:Normal', { win = existing.win })

    local old_height = existing.height
    local width = math.min(msg_max_len, line_max_len)
    register_callback(existing, buf)
    -- if dimension did not change at all, we don't need to do anything
    if old_height == #formatted and existing.height == width then
      return buf
    end
    -- else we would at least have to refresh the existing window
    existing.height = #formatted
    existing.width = width
    api.nvim_win_close(existing.win, true)
    existing.win = api.nvim_open_win(
      buf,
      false,
      make_popup_opts(existing.level, width, existing.height, existing.offset)
    )
    -- if height did not change, we don't need to update other messages
    if old_height == existing.height then
      return buf
    end
    -- else we adjust messages above the current one
    for sbuf, popup in pairs(displayed) do
      if popup.offset > existing.offset then
        popup.offset = popup.offset - old_height + existing.height
        if existing.height ~= 1 then
          popup.offset = popup.offset - 2
        end
        api.nvim_win_close(popup.win, true)
        popup.win = api.nvim_open_win(
          sbuf,
          false,
          make_popup_opts(popup.level, popup.width, popup.height, popup.offset)
        )
      end
    end
  end

  -- open win at corner
  local offset = 1
  local this = {
    height = #formatted,
    width = math.min(msg_max_len, line_max_len),
    level = level,
  }
  for _, s in pairs(displayed) do
    offset = offset + s.height
    if s.height ~= 1 then
      offset = offset + 2
    end
  end
  local buf = api.nvim_create_buf(false, true)
  api.nvim_buf_set_lines(buf, 0, -1, false, formatted)
  local win = api.nvim_open_win(buf, false, make_popup_opts(level, this.width, this.height, offset))
  this.buf = buf
  this.offset = offset
  this.win = win

  -- add a local keymap to close the win conviently
  _G.map('n', 'q', _G.cmd('q'), { buffer = buf })

  -- add highlights
  for i = 0, #formatted - 1, 1 do
    api.nvim_buf_add_highlight(buf, ns, hls[level] or 'NotifyInfo', i, 0, -1)
  end
  api.nvim_set_option_value('winhl', 'Normal:Normal', { win = win })

  -- register callback
  displayed[buf] = this
  register_callback(this, buf)
  return buf
end

local platte = {
  NotifyDebug = { fg = _G.palette.purple },
  NotifyError = { fg = _G.palette.red },
  NotifyInfo = { fg = _G.palette.blue },
  NotifyTrace = { fg = _G.palette.galaxy },
  NotifyWarn = { fg = _G.palette.yellow },
  NotifyOff = { fg = _G.palette.fancy },
}

for group, conf in pairs(platte) do
  api.nvim_set_hl(0, group, conf)
end
