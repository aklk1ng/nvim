-- https://github.com/rockyzhang24/dotfiles/blob/master/.config/nvim/lua/rockyz/quickfix.lua

local MAX_FNAME_LEN = 50 -- threshold for filename length. 0 means no limit.
local TRUNCATE_PREFIX = '...'

local function normalize(item)
  local fname = ''
  if item.bufnr > 0 then
    fname = vim.api.nvim_buf_get_name(item.bufnr)
    if fname == '' then
      fname = '[No Name]'
    else
      fname = fname:gsub('^' .. vim.env.HOME, '~')
    end
    if MAX_FNAME_LEN > 0 and #fname > MAX_FNAME_LEN then
      fname = TRUNCATE_PREFIX .. fname:sub(-MAX_FNAME_LEN)
    end
  end
  -- Is showing end_lnum and end_col in quickfix helpful? I don't think so!
  return {
    filename = fname,
    lnum = item.lnum or -1,
    col = item.col or -1,
    type = item.type == '' and '' or item.type:sub(1, 1):upper(),
    text = item.text:gsub('\n', ' '),
  }
end

-- To avoid performance issue, qftf should be kept as simple as possible
function _G.qftf(info)
  local items
  local lines = {}
  if info.quickfix == 1 then
    items = vim.fn.getqflist({ id = info.id, items = 0 }).items
  else
    items = vim.fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end
  local fmt = '%s |%d:%d| %s %s'
  for i = info.start_idx, info.end_idx do
    local item = normalize(items[i])
    local line
    if items[i].valid == 1 then
      line = fmt:format(
        item.filename,
        item.lnum,
        item.col,
        item.type == '' and '' or item.type,
        item.text
      )
    else
      line = item.text
    end
    table.insert(lines, line)
  end
  return lines
end

vim.o.quickfixtextfunc = 'v:lua.qftf'
