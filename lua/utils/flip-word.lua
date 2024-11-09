local M = {}
local fn, api = vim.fn, vim.api

local tbl = {
  ['true'] = 'false',
  ['True'] = 'False',
  ['TRUE'] = 'FALSE',
  ['yes'] = 'no',
  ['Yes'] = 'No',
  ['YES'] = 'NO',
  ['min'] = 'max',
  ['Min'] = 'Max',
  ['MIN'] = 'MAX',
  ['and'] = 'or',
  ['And'] = 'Or',
  ['AND'] = 'OR',
  ['off'] = 'on',
  ['Off'] = 'On',
  ['OFF'] = 'ON',
  ['<'] = '>',
  ['+'] = '-',
  ['+='] = '-=',
  ['=='] = '!=',
  ['<='] = '>=',
  ['<<'] = '>>',
  ['<<='] = '>>=',
  ['->'] = '<-',
  ['&&'] = '||',
  ['&'] = '|',
  ['&='] = '|=',
  ['/='] = '%=',
  ['/'] = '%',
}

local special_tbl = {
  ['lua'] = {
    ['=='] = '~=',
  },
}

-- Just stolen from the `vim` stadard module.
local function tbl_keys(t)
  local keys = {}
  for k in pairs(t) do
    if type(k) == 'string' then
      table.insert(keys, k)
    end
  end
  return keys
end

local function tbl_add_reverse_lookup(t)
  local keys = tbl_keys(t)
  if not keys then
    return nil
  end
  for _, k in ipairs(keys) do
    local v = t[k]
    if not t[v] then
      t[v] = k
    end
  end
  return t
end

tbl = tbl_add_reverse_lookup(tbl)

function M.toggle()
  local cur = api.nvim_win_get_cursor(0)
  vim.cmd('normal! viw')
  local s_l, s_r = fn.getpos('v')[2], fn.getpos('v')[3]
  local e_l, e_r = fn.getpos('.')[2], fn.getpos('.')[3]
  local word = fn.getline(s_l, e_l)[1]:sub(s_r, e_r)
  api.nvim_feedkeys(api.nvim_replace_termcodes('<Esc>', true, true, true), 'v', true)

  local new_map = tbl_add_reverse_lookup(special_tbl[vim.o.filetype] or {})
  new_map = vim.tbl_extend('force', tbl, new_map or {})
  if not new_map then
    vim.notify('Word map is nil', vim.log.levels.ERROR)
    api.nvim_win_set_cursor(0, cur)
    return
  end
  local new_word = new_map[word]
  if not new_word then
    vim.notify('Unsupported word', vim.log.levels.WARN)
    api.nvim_win_set_cursor(0, cur)
    return
  end
  api.nvim_buf_set_text(0, s_l - 1, s_r - 1, e_l - 1, e_r, { new_word })
  api.nvim_win_set_cursor(0, cur)
end

return M
