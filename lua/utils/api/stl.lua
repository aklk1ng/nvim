--@see https://github.com/nvimdev/whiskyline.nvim

local co, api, lsp = coroutine, vim.api, vim.lsp
local whk = {}

local function sep()
  return {
    stl = ' ',
  }
end

local function fileinfo()
  local result = {
    stl = '%t%r%m',
    event = { 'BufEnter' },
    attr = 'CursorLineNr',
  }

  return result
end

local function search()
  local function res()
    if vim.v.hlsearch == 0 then
      return ''
    end
    local s = vim.fn.searchcount()
    local current = s.current
    local cnt = math.min(s.total, s.maxcount)
    return string.format('[%d/%d]', current, cnt)
  end
  local result = {
    stl = res,
    event = { 'CursorHold' },
    attr = 'Repeat',
  }

  return result
end

local function lspinfo()
  local function lsp_stl(args)
    local client = lsp.get_clients({ bufnr = args.buf })[1]
    if not client then
      return ''
    end

    local msg = client and client.name or ''
    if args.data and args.data.result then
      local val = args.data.result.value
      msg = val.title
        .. ' '
        .. (val.message and val.message .. ' ' or '')
        .. (val.percentage and val.percentage .. '%' or '')
      if not val.message or val.kind == 'end' then
        ---@diagnostic disable-next-line: need-check-nil
        msg = client.name
      end
    elseif args.event == 'BufEnter' then
      msg = client.name
    elseif args.event == 'LspDetach' then
      msg = ''
    end
    return '%.40{"' .. msg .. '"}'
  end

  local result = {
    stl = lsp_stl,
    event = { 'LspProgress', 'LspAttach', 'LspDetach', 'BufEnter' },
    attr = 'Function',
  }

  return result
end

local function gitsigns_data(bufnr, type)
  local ok, dict = pcall(api.nvim_buf_get_var, bufnr, 'gitsigns_status_dict')
  if not ok or vim.tbl_isempty(dict) or not dict[type] then
    return 0
  end

  return dict[type]
end

local function gitadd()
  local result = {
    stl = function(args)
      local res = gitsigns_data(args.buf, 'added')
      return res > 0 and '+' .. res or ''
    end,
    event = { 'User GitSignsUpdate' },
    attr = 'DiffAdd',
  }
  return result
end

local function gitchange()
  local result = {
    stl = function(args)
      local res = gitsigns_data(args.buf, 'changed')
      return res > 0 and '~' .. res or ''
    end,
    event = { 'User GitSignsUpdate' },
    attr = 'DiffChange',
  }

  return result
end

local function gitdelete()
  local result = {
    stl = function(args)
      local res = gitsigns_data(args.buf, 'removed')
      return res > 0 and '-' .. res or ''
    end,
    event = { 'User GitSignsUpdate' },
    attr = 'DiffDelete',
  }

  return result
end

local function branch()
  local result = {
    stl = function(args)
      local icon = ' '
      local res = gitsigns_data(args.buf, 'head')
      return res and icon .. res or ''
    end,
    event = { 'User GitSignsUpdate' },
    attr = 'Include',
  }
  return result
end

local function pad()
  return {
    stl = '%=',
  }
end

local function lnumcol()
  local result = {
    stl = '%-4.(%l:%c%)',
    event = { 'CursorHold' },
    attr = 'Number',
  }

  return result
end

local function diagnostic_info(severity)
  if vim.diagnostic.is_disabled(0) then
    return ''
  end

  local tbl = {
    'E',
    'W',
    'I',
    'H',
  }
  local count = vim.diagnostic.count(0)[severity]
  return not count and '' or tbl[severity] .. tostring(count) .. ' '
end

local function diagError()
  local result = {
    stl = function()
      return diagnostic_info(1)
    end,
    event = { 'DiagnosticChanged', 'BufEnter' },
    attr = 'DiagnosticError',
  }
  return result
end

local function diagWarn()
  local result = {
    stl = function()
      return diagnostic_info(2)
    end,
    event = { 'DiagnosticChanged', 'BufEnter' },
    attr = 'DiagnosticWarn',
  }
  return result
end

local function diagInfo()
  local result = {
    stl = function()
      return diagnostic_info(3)
    end,
    event = { 'DiagnosticChanged', 'BufEnter' },
    attr = 'DiagnosticInfo',
  }
  return result
end

local function diagHint()
  local result = {
    stl = function()
      return diagnostic_info(4)
    end,
    event = { 'DiagnosticChanged', 'BufEnter' },
    attr = 'DiagnosticHint',
  }
  return result
end

local function stl_format(name, val)
  return '%#' .. (name or 'StatusLine') .. '#' .. val .. '%*'
end

local function default()
  local comps = {
    fileinfo(),
    sep(),
    lspinfo(),
    sep(),
    diagError(),
    diagWarn(),
    diagInfo(),
    diagHint(),
    search(),

    pad(),

    lnumcol(),
    sep(),
    branch(),
    sep(),
    gitadd(),
    gitchange(),
    gitdelete(),
  }
  local e, pieces = {}, {}
  vim
    .iter(ipairs(comps))
    :map(function(key, item)
      if type(item.stl) == 'string' then
        pieces[#pieces + 1] = stl_format(item.attr, item.stl)
      else
        pieces[#pieces + 1] = item.default and stl_format(item.attr, item.default) or ''
        for _, event in ipairs({ unpack(item.event or {}) }) do
          if not e[event] then
            e[event] = {}
          end
          e[event][#e[event] + 1] = key
        end
      end
    end)
    :totable()
  return comps, e, pieces
end

local function render(comps, events, pieces)
  return co.create(function(args)
    while true do
      local event = args.event == 'User' and args.event .. ' ' .. args.match or args.event
      for _, idx in ipairs(events[event]) do
        pieces[idx] = stl_format(comps[idx].attr, comps[idx].stl(args))
      end

      -- because setup use a timer to defer parse and render this will cause missing
      -- `BufEnter` event so add a safe check
      pieces[3] = stl_format(comps[3].attr, comps[3].stl(args))

      vim.opt.stl = table.concat(pieces)
      args = co.yield()
    end
  end)
end

function whk.setup()
  -- move to next event loop
  -- that mean must lazyload this plugin
  vim.defer_fn(function()
    local comps, events, pieces = default()
    local stl_render = render(comps, events, pieces)
    for _, e in ipairs(vim.tbl_keys(events)) do
      local tmp = e
      local pattern
      if e:find('User') then
        pattern = vim.split(e, '%s')[2]
        tmp = 'User'
      end

      api.nvim_create_autocmd(tmp, {
        pattern = pattern,
        callback = function(args)
          vim.schedule(function()
            local ok, res = co.resume(stl_render, args)
            if not ok then
              vim.notify('[Whisky] render failed ' .. res, vim.log.levels.ERROR)
            end
          end)
        end,
      })
    end
  end, 0)
end

return whk
