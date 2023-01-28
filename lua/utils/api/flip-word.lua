-- Plugin Auther
-- https://github.com/rmagatti/alternate-toggler

local M = {}
local flip_word_table = {
  ['true'] = 'false',
  ['True'] = 'False',
  ['TRUE'] = 'FALSE',
  ['Yes'] = 'No',
  ['YES'] = 'NO',
  ['yes'] = 'no',
  ['1'] = '0',
  ['<'] = '>',
  ['('] = ')',
  ['['] = ']',
  ['{'] = '}',
  ['"'] = "'",
  ['""'] = "''",
  ['+'] = '-',
  ['++'] = '--',
  ['+='] = '-=',
  ['=='] = '!=',
  ['<='] = '>=',
  ['<<'] = '>>',
  ['<<='] = '>>=',
  ['->'] = '<-',
  ['&&'] = '||',
  ['&'] = '|',
  ['&='] = '|=',
  ['and'] = 'or',
}

vim.tbl_add_reverse_lookup(flip_word_table)

local function errorHandler(err)
  if not err == nil then
    vim.notify('Error toggling to alternate value. Err: ' .. err, vim.log.levels.ERROR)
  end
end

local user_clipboard = nil
local user_register = nil
local user_register_mode = nil
local curpos = nil

local function snapshot_and_clean()
  user_clipboard = vim.o.clipboard
  user_register = vim.fn.getreg('"')
  user_register_mode = vim.fn.getregtype('"')
  curpos = vim.api.nvim_win_get_cursor(0)

  vim.o.clipboard = nil
end

local function restore_snapshot()
  vim.fn.setreg('"', user_register, user_register_mode)
  vim.o.clipboard = user_clipboard
  vim.api.nvim_win_set_cursor(0, curpos)
end

function M.toggleAlternate(str)
  if str ~= nil then
    vim.notify(
      'Deprecated: passing a string (usually <cword>) into `toggleAlternate` is deprecated. It now automatically does a `iw` text object operation.',
      vim.log.levels.WARN
    )
  end

  snapshot_and_clean()

  vim.api.nvim_command('normal! yiw')
  local yanked_word = vim.fn.getreg('"')
  local replace_word = flip_word_table[yanked_word]

  if replace_word == nil then
    vim.notify('Unsupported alternate value.', vim.log.levels.INFO)
    restore_snapshot()
    return
  end

  xpcall(function()
    vim.api.nvim_command('normal! ciw' .. replace_word)
  end, errorHandler)

  restore_snapshot()
end

return M
