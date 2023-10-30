-- https://github.com/glepnir

local api, fn = vim.api, vim.fn

local function matchadd()
  local bufname = api.nvim_buf_get_name(0)
  if #bufname == 0 then
    return
  end

  local column = api.nvim_win_get_cursor(0)[2]
  local line = api.nvim_get_current_line()
  local cursorword = fn.matchstr(line:sub(1, column + 1), [[\k*$]])
    .. fn.matchstr(line:sub(column + 1), [[^\k*]]):sub(2)

  if cursorword == vim.w.cursorword then
    return
  end
  vim.w.cursorword = cursorword
  if vim.w.cursorword_match == 1 then
    fn.matchdelete(vim.w.cursorword_id)
  end
  vim.w.cursorword_match = 0
  if
    cursorword == ''
    or #cursorword > 100
    or #cursorword < 3
    or string.find(cursorword, '[\192-\255]+') ~= nil
  then
    return
  end
  local pattern = [[\<]] .. cursorword .. [[\>]]
  vim.w.cursorword_id = fn.matchadd('CursorWord', pattern, -1)
  vim.w.cursorword_match = 1
end

local function cursor_moved()
  if vim.bo.filetype ~= 'help' and vim.bo.filetype ~= 'dashboard' and fn.expand('%:e') ~= '' then
    matchadd()
  else
    if vim.w.cursorword_match == 1 then
      fn.matchdelete(vim.w.cursorword_id)
    end
    vim.w.cursorword_match = 0
  end
end

api.nvim_create_autocmd({ 'CursorHold' }, {
  pattern = '*',
  callback = cursor_moved,
})
