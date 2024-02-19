-- Heavily modified version of bfredl's indentline
local api = vim.api
local ns = api.nvim_create_namespace('indentline')
local blacklist = {
  'help',
  'tex',
  'lazy',
  'markdown',
  'erlang',
  'nofile',
  'text',
  'query',
  'floatterm',
  'checkhealth',
  '',
}

local function get_single_line(buf, row)
  -- pcall necessary because line_count is only for saved buffer contents
  local ok, line = pcall(api.nvim_buf_get_lines, buf, row, row + 1, true)
  if not ok then
    return ' '
  else
    return line[1]
  end
end

local function find_indent(row, incr, low, high)
  local current = row
  while row > low and row < high do
    if get_single_line(0, current) ~= '' then
      return vim.fn.indent(current + 1)
    end
    current = current + incr
  end
  return 0
end

local function on_start(_, _)
  if vim.tbl_contains(blacklist, vim.bo.filetype) then
    return false
  end
end

local function on_win(_, _, bufnr, _)
  if bufnr ~= api.nvim_get_current_buf() then
    return false
  end
end

local function on_line(_, _, bufnr, row)
  if vim.bo.shiftwidth < 2 then
    return
  end
  local indent = vim.fn.indent(row + 1)
  local high, low = api.nvim_buf_line_count(bufnr) - 1, 0
  if indent == 0 and row ~= high then
    indent = math.min(
      find_indent(row, 1, math.max(row - 20, low), math.min(row + 20, high)),
      find_indent(row, -1, math.max(row - 20, low), math.min(row + 20, high))
    )
  end

  ---@diagnostic disable-next-line: undefined-field
  local leftcol = vim.fn.winsaveview().leftcol
  for i = 0, indent - 2, vim.bo.shiftwidth do
    if i >= leftcol then
      api.nvim_buf_set_extmark(bufnr, ns, row, 0, {
        virt_text = { { '▏', 'IndentLine' } },
        virt_text_pos = 'overlay',
        hl_mode = 'combine',
        virt_text_win_col = i - leftcol,
        priority = 2, -- don't overwrite text
        ephemeral = true,
      })
    end
  end
end
api.nvim_set_decoration_provider(ns, { on_start = on_start, on_win = on_win, on_line = on_line })
