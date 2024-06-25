--@see https://github.com/nvimdev

local co, fn, api, lsp, iter = coroutine, vim.fn, vim.api, vim.lsp, vim.iter

local function sep()
  return {
    stl = ' ',
  }
end

local function fileinfo()
  return {
    stl = '%f%r%m',
    event = { 'BufEnter' },
    attr = 'Operator',
  }
end

local function search()
  return {
    stl = function()
      local s = fn.searchcount()
      if vim.v.hlsearch == 0 or s.total == 0 then
        return ''
      end
      local current = s.current
      local cnt = math.min(s.total, s.maxcount)
      return string.format('[%d/%d]', current, cnt)
    end,
    event = { 'CursorHold' },
    attr = 'Repeat',
  }
end

local function lspinfo()
  return {
    stl = function(args)
      local client = lsp.get_clients({ bufnr = 0 })[1]
      if not client then
        return ''
      end

      local msg = client and client.name or ''
      if args.data and args.data.params then
        local val = args.data.params.value
        if not val.message or val.kind == 'end' then
          msg = ('%s:%s'):format(
            client.name,
            client.root_dir and fn.fnamemodify(client.root_dir, ':t') or 'single'
          )
        else
          msg = val.title
            .. ' '
            .. (val.message and val.message .. ' ' or '')
            .. (val.percentage and val.percentage .. '%' or '')
        end
      elseif args.event == 'BufEnter' then
        msg = ('%s:%s'):format(
          client.name,
          client.root_dir and fn.fnamemodify(client.root_dir, ':t') or 'single'
        )
      elseif args.event == 'LspDetach' then
        msg = ''
      end
      return '%.40{"' .. msg .. '"}'
    end,
    event = { 'LspProgress', 'LspAttach', 'LspDetach', 'BufEnter' },
    attr = 'Function',
  }
end

local function branch()
  return {
    stl = function()
      local icon = ' '
      local cmd = 'cd '
        .. fn.fnamemodify(api.nvim_buf_get_name(0), ':h')
        .. ' 2>/dev/null'
        .. ' && git branch --show-current 2>/dev/null'
      local handle = io.popen(cmd, 'r')
      if not handle then
        return ''
      end
      local res = handle:read('*a')
      handle:close()
      return #res > 0 and icon .. vim.trim(res) or ''
    end,
    event = { 'BufEnter' },
    attr = 'Include',
  }
end

local function pad()
  return {
    stl = '%=',
  }
end

local function lnumcol()
  return {
    stl = '%l:%c %P',
    event = { 'CursorHold' },
    attr = 'Number',
  }
end

local function diagnostic_info(severity)
  if not vim.diagnostic.is_enabled({ bufnr = 0 }) then
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
  return {
    stl = function()
      return diagnostic_info(1)
    end,
    event = { 'DiagnosticChanged', 'BufEnter' },
    attr = 'DiagnosticError',
  }
end

local function diagWarn()
  return {
    stl = function()
      return diagnostic_info(2)
    end,
    event = { 'DiagnosticChanged', 'BufEnter' },
    attr = 'DiagnosticWarn',
  }
end

local function diagInfo()
  return {
    stl = function()
      return diagnostic_info(3)
    end,
    event = { 'DiagnosticChanged', 'BufEnter' },
    attr = 'DiagnosticInfo',
  }
end

local function diagHint()
  return {
    stl = function()
      return diagnostic_info(4)
    end,
    event = { 'DiagnosticChanged', 'BufEnter' },
    attr = 'DiagnosticHint',
  }
end

-- just use the attr as the name
-- so i don't need to set the highlight group
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
    pad(),

    lnumcol(),
    sep(),
    branch(),
  }
  local e, pieces = {}, {}
  iter(ipairs(comps))
    :map(function(key, item)
      if type(item.stl) == 'string' then
        pieces[#pieces + 1] = stl_format(item.attr, item.stl)
      else
        pieces[#pieces + 1] = ''
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
      local event = args.event
      for _, idx in ipairs(events[event]) do
        pieces[idx] = stl_format(comps[idx].attr, comps[idx].stl(args))
      end

      vim.opt.stl = table.concat(pieces)
      args = co.yield()
    end
  end)
end

return {
  setup = function()
    local comps, events, pieces = default()
    local stl_render = render(comps, events, pieces)
    iter(vim.tbl_keys(events)):map(function(e)
      local tmp = e

      api.nvim_create_autocmd(tmp, {
        callback = function(args)
          vim.schedule(function()
            local ok, res = co.resume(stl_render, args)
            if not ok then
              vim.notify('StatusLine render failed ' .. res, vim.log.levels.ERROR)
            end
          end)
        end,
      })
    end)
  end,
}
