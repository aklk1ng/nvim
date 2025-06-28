-- https://github.com/nvimdev/modeline.nvim

---@class Compoment
---@field name string Used for highlight group name if need(**attr is true**).
---@field stl string|function Result is the evaluated text.
---@field event? table<string> Triggered events.
---@field attr? string|boolean if `attr` is true, the `stl` field return whole evaluated text. otherwise, set the highlight group if need.

local function stl_attr(group)
  return {
    fg = vim.api.nvim_get_hl(0, { name = group, link = false }).fg,
    bg = vim.api.nvim_get_hl(0, { name = 'StatusLine' }).bg,
  }
end

local function stl_format(hl, val)
  return ('%%#Stl%s#%s%%*'):format(hl, val)
end

---@return Compoment
local function sep()
  return {
    name = 'sep',
    stl = ' ',
  }
end

---@return Compoment
local function fileinfo()
  return {
    name = 'fileinfo',
    stl = '%f%r%m',
    event = { 'BufEnter' },
    attr = 'Normal',
  }
end

local function progress()
  local spinner = { '⣶', '⣧', '⣏', '⡟', '⠿', '⢻', '⣹', '⣼' }
  local idx = 1
  return {
    stl = function(args)
      if args.data and args.data.params then
        local val = args.data.params.value
        if val.message and val.kind ~= 'end' then
          idx = idx + 1 > #spinner and 1 or idx + 1
          return ('%s'):format(spinner[idx - 1 > 0 and idx - 1 or 1])
        end
      end
      return ''
    end,
    name = 'LspProgress',
    event = { 'LspProgress' },
    attr = 'Normal',
  }
end

---@return Compoment
local function pad()
  return {
    name = 'pad',
    stl = '%=',
  }
end

---@return Compoment
local function diagnostic()
  local levels = { 'ERROR', 'WARN', 'INFO', 'HINT' }

  return {
    name = 'diagnostic',
    stl = function()
      if
        not vim.diagnostic.is_enabled({ bufnr = 0 }) or #vim.lsp.get_clients({ bufnr = 0 }) == 0
      then
        return ''
      end

      local counts = vim.diagnostic.count(0)
      local res = {}
      for _, level in ipairs(levels) do
        local n = counts[vim.diagnostic.severity[level]]
        if n then
          table.insert(res, ('%%#Diagnostic%s#%s%%*'):format(level, n))
        end
      end
      if #res > 0 then
        return '[' .. table.concat(res, ' ') .. ']'
      else
        return ''
      end
    end,
    event = { 'DiagnosticChanged', 'LspAttach', 'LspDetach' },
    attr = true,
  }
end

---@return Compoment
local function lnumcol()
  return {
    name = 'lnumcol',
    stl = '%l:%c %P',
    event = { 'CursorHold' },
    attr = 'Normal',
  }
end

---@return Compoment[], table<string, table<integer, integer>>, string[]
local function default()
  local comps = {
    fileinfo(),
    sep(),
    diagnostic(),

    pad(),
    pad(),

    progress(),
    sep(),
    lnumcol(),
  }
  local e, pieces = {}, {}
  vim
    .iter(ipairs(comps))
    :map(function(key, item)
      if type(item) == 'string' then
        pieces[#pieces + 1] = item
      elseif type(item.stl) == 'string' then
        if item.attr == true then
          pieces[#pieces + 1] = item.stl
        else
          pieces[#pieces + 1] = stl_format(item.name, item.stl)
        end
      else
        pieces[#pieces + 1] = ''
        for _, event in ipairs({ unpack(item.event or {}) }) do
          if not e[event] then
            e[event] = {}
          end
          e[event][#e[event] + 1] = key
        end
      end
      if type(item.attr) == 'string' then
        vim.api.nvim_set_hl(0, ('Stl%s'):format(item.name), stl_attr(item.attr))
      end
    end)
    :totable()
  return comps, e, pieces
end

---@param comps Compoment[]
---@param events table<string, table<integer, integer>>,
---@param pieces string[]
local function render(comps, events, pieces)
  return coroutine.create(function(args)
    while true do
      for _, idx in ipairs(events[args.event]) do
        if comps[idx].attr == true then
          pieces[idx] = comps[idx].stl(args)
        else
          pieces[idx] = stl_format(comps[idx].name, comps[idx].stl(args))
        end
      end

      vim.opt.stl = table.concat(pieces)
      args = coroutine.yield()
    end
  end)
end

local comps, events, pieces = default()
local stl_render = render(comps, events, pieces)
vim.iter(vim.tbl_keys(events)):map(function(e)
  vim.api.nvim_create_autocmd(e, {
    callback = function(args)
      vim.schedule(function()
        local ok, res = coroutine.resume(stl_render, args)
        if not ok then
          vim.notify('StatusLine render failed ' .. res, vim.log.levels.ERROR)
        end
      end)
    end,
  })
end)
