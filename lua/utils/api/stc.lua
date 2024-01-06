local api, o = vim.api, vim.o
local M = {}
local ffi = require('ffi')
ffi.cdef([[
  typedef struct {} Error;
  typedef struct {} win_T;
  typedef struct {
    int start;  // line number where deepest fold starts
    int level;  // fold level, when zero other fields are N/A
    int llevel; // lowest level that starts in v:lnum
    int lines;  // number of lines from v:lnum to end of closed fold
  } foldinfo_T;
  foldinfo_T fold_info(win_T* wp, int lnum);
  win_T *find_window_by_handle(int Window, Error *err);
  int compute_foldcolumn(win_T *wp, int col);

  // Display tick, incremented for each call to update_screen() uint64_t display_tick;
  uint64_t display_tick;
]])

local fcs = vim.opt_local.fillchars:get()
local shared = {}

local function hl_fold()
  local win = vim.api.nvim_get_current_win()
  local display_tick = ffi.C.display_tick --[[@as uinteger]]
  if not shared[win] then -- Initialize shared data
    shared[win] = {
      win = win,
      wp = ffi.C.find_window_by_handle(win, ffi.new('Error')),
    }
  end

  local data = shared[win]
  if not data.display_tick or data.display_tick < display_tick then -- Update shared data
    data.display_tick = display_tick
    data.foldopen = fcs.foldopen or ''
    data.foldclose = fcs.foldclose or ''
    data.foldsep = fcs.foldsep or ' '
  end
  data.lnum = vim.v.lnum

  local width = ffi.C.compute_foldcolumn(data.wp, 0) -- get foldcolumn width
  local foldinfo = width > 0 and ffi.C.fold_info(data.wp, data.lnum)
    or { start = 0, level = 0, llevel = 0, lines = 0 }
  local foldchar = foldinfo.start ~= data.lnum and data.foldsep
    or foldinfo.lines == 0 and data.foldopen
    or data.foldclose
  return '%#' .. 'FoldColumn' .. '#' .. foldchar .. '%*'
end

local function stc()
  local function get_signs(name)
    return function()
      local bufnr = api.nvim_win_get_buf(vim.g.statusline_winid)
      local it = vim
        .iter(api.nvim_buf_get_extmarks(bufnr, -1, 0, -1, { details = true, type = 'sign' }))
        :find(function(item)
          return item[2] == vim.v.lnum - 1 and item[4].sign_hl_group:find(name)
        end)
      return not it and '  ' or '%#' .. it[4].sign_hl_group .. '#' .. it[4].sign_text .. '%*'
    end
  end

  function _G.show_stc()
    local stc_gitsign = get_signs('GitSign')

    local function show_break()
      if vim.v.virtnum > 0 then
        return (' '):rep(math.floor(math.ceil(math.log10(vim.v.lnum))) - 1) .. ' '
      elseif vim.v.virtnum < 0 then
        return ''
      else
        return vim.v.lnum
      end
    end

    return hl_fold() .. '%=' .. show_break() .. stc_gitsign()
  end

  o.stc = [[%!v:lua.show_stc()]]
end

function M.setup()
  if vim.bo.bt == '' and vim.wo.stc == '' and vim.fn.win_gettype() == '' then
    stc()
  end
end

return M
