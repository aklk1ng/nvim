-- https://github.com/nvimdev/Session.nvim
--
-- CHANGE:
-- 1. Use current buffer's full path and timestamp as default session name
-- 2. Don't adapt Windows
--
-- FIX:
-- 1. If no session exists, the completion of cmdline will be `v:null` not just nothing

local function path_sep()
  return '/'
end

local function path_join(...)
  return table.concat({ ... }, path_sep())
end

local CACHE_DIR = path_join(vim.fn.stdpath('cache'), 'session')

local function default_session_name()
  local name = vim.fn.expand('%:p') .. '_' .. os.date('%Y_%m_%d_%H_%M_%S')
  return name:gsub('^/', ''):gsub('[/]', '_')
end

local function session_list()
  if vim.fn.glob(CACHE_DIR .. '/*.vim') == '' then
    return {}
  end

  return vim.split(vim.fn.globpath(CACHE_DIR, '*.vim'), '\n')
end

local function full_path(session_name)
  return path_join(CACHE_DIR, session_name .. '.vim')
end

local function session_save(session_name)
  local file_name = (not session_name or #session_name == 0) and default_session_name()
    or session_name
  local file_path = path_join(CACHE_DIR, file_name .. '.vim')
  vim.api.nvim_command('mksession! ' .. vim.fn.fnameescape(file_path))
  vim.v.this_session = file_path
end

local function session_load(session_name)
  if not session_name or #session_name == 0 then
    return
  end
  local file_path = full_path(session_name)

  if vim.v.this_session ~= '' and vim.fn.exists('g:SessionLoad') == 0 then
    vim.api.nvim_command('mksession! ' .. vim.fn.fnameescape(vim.v.this_session))
  end

  if vim.fn.filereadable(file_path) == 1 then
    local curbuf = vim.api.nvim_get_current_buf()
    if vim.bo[curbuf].modified then
      vim.cmd.write()
    end
    vim.cmd([[noautocmd silent! %bwipeout!]])
    vim.api.nvim_command('silent! source ' .. file_path)
    return
  end

  vim.notify('[Session] Load failed:' .. file_path, vim.log.levels.ERROR)
end

local function session_delete(name)
  if not name then
    vim.notify('[Session] No session found', vim.log.levels.WARN)
    return
  end

  local file_path = full_path(name)

  if vim.fn.filereadable(file_path) == 1 then
    vim.fn.delete(file_path)
    return
  end

  vim.notify('[Session] Delete failed:' .. name, vim.log.levels.ERROR)
end

local function complete_list()
  local list = session_list()
  list = vim.tbl_map(function(k)
    local tbl = vim.split(k, path_sep(), { trimempty = true })
    return vim.fn.fnamemodify(tbl[#tbl], ':r')
  end, list)
  return list
end

vim.api.nvim_create_user_command('SessionSave', function(args)
  session_save(args.args)
end, {
  nargs = '?',
})

vim.api.nvim_create_user_command('SessionLoad', function(args)
  session_load(args.args)
end, {
  nargs = '?',
  complete = complete_list,
})

vim.api.nvim_create_user_command('SessionDelete', function(args)
  session_delete(args.args)
end, {
  nargs = '?',
  complete = complete_list,
})

if vim.fn.isdirectory(CACHE_DIR) == 0 then
  vim.fn.mkdir(CACHE_DIR, 'p')
end
