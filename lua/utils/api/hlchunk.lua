local M = {}
local api, fn = vim.api, vim.fn
local ns_id = -1

local support_ft = {
  '*.ts',
  '*.tsx',
  '*.js',
  '*.jsx',
  '*.json',
  '*.go',
  '*.c',
  '*.cpp',
  '*.rs',
  '*.h',
  '*.hpp',
  '*.lua',
  '*.vue',
  '*.proto',
  '*.sh',
  '*.jsonc',
  '*.cmake',
  '*.css',
}

local config = {
  chunk = {
    support_filetypes = support_ft,
    chars = {
      horizontal_line = '─',
      vertical_line = '│',
      left_top = '╭',
      left_bottom = '╰',
      right_arrow = '>',
    },
  },
}

-- execute this function to get styles
local function set_hls()
  api.nvim_set_hl(0, 'HLChunk', {
    fg = '#CFC2C2',
  })
end

local CUR_CHUNK_RANGE = { -1, -1 }
local SPACE_TAB = (' '):rep(vim.o.shiftwidth)

local function render_cur_chunk()
  local beg_row, end_row = unpack(CUR_CHUNK_RANGE)
  local beg_blank_len = fn.indent(beg_row)
  local end_blank_len = fn.indent(end_row)
  local start_col = math.min(beg_blank_len, end_blank_len) - vim.o.shiftwidth

  local row_opts = {
    virt_text_pos = 'overlay',
    virt_text_win_col = start_col,
    hl_mode = 'combine',
    priority = 100,
  }
  -- render beg_row and end_row
  if start_col >= 0 then
    local beg_virt_text = config.chunk.chars.left_top
      .. config.chunk.chars.horizontal_line:rep(beg_blank_len - start_col - 1)
    local end_virt_text = config.chunk.chars.left_bottom
      .. config.chunk.chars.horizontal_line:rep(end_blank_len - start_col - 2)
      .. config.chunk.chars.right_arrow

    row_opts.virt_text = { { beg_virt_text, 'HLChunk' } }
    api.nvim_buf_set_extmark(0, ns_id, beg_row - 1, 0, row_opts)
    row_opts.virt_text = { { end_virt_text, 'HLChunk' } }
    api.nvim_buf_set_extmark(0, ns_id, end_row - 1, 0, row_opts)
  end

  -- render middle section
  for i = beg_row + 1, end_row - 1 do
    start_col = math.max(0, start_col)
    row_opts.virt_text = { { config.chunk.chars.vertical_line, 'HLChunk' } }
    row_opts.virt_text_win_col = start_col
    ---@diagnostic disable-next-line: undefined-field
    local line_val = fn.getline(i):gsub('\t', SPACE_TAB)
    if #fn.getline(i) <= start_col or line_val:sub(start_col + 1, start_col + 1):match('%s') then
      api.nvim_buf_set_extmark(0, ns_id, i - 1, 0, row_opts)
    end
  end
end

function M.get_chunk_range()
  local beg_row, end_row
  local base_flag = 'nWz'
  local cur_row_val = fn.getline('.')
  local cur_col = fn.col('.')
  local cur_char = string.sub(cur_row_val, cur_col, cur_col)

  beg_row = fn.searchpair('{', '', '}', base_flag .. 'b' .. (cur_char == '{' and 'c' or ''))
  end_row = fn.searchpair('{', '', '}', base_flag .. (cur_char == '}' and 'c' or ''))

  if beg_row <= 0 or end_row <= 0 then
    return { 0, 0 }
  end

  return { beg_row, end_row }
end

-- set new virtual text to the right place
function M:render_chunk()
  self:clear()
  ns_id = api.nvim_create_namespace('hlchunk')

  -- determined the row where parentheses are
  if CUR_CHUNK_RANGE[1] < CUR_CHUNK_RANGE[2] then
    render_cur_chunk()
  end
end

-- clear the virtual text marked before
function M:clear()
  if ns_id ~= -1 then
    api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
  end
end

function M:enable_chunk()
  api.nvim_create_augroup('hl_chunk_augroup', { clear = true })
  api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'TextChanged' }, {
    group = 'hl_chunk_augroup',
    pattern = config.chunk.support_filetypes,
    callback = function()
      set_hls()
      CUR_CHUNK_RANGE = self.get_chunk_range()
      M:render_chunk()
    end,
  })
end

return M
