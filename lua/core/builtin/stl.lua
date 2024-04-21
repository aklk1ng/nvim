--@see https://github.com/nvimdev/whiskyline.nvim

local co, api, lsp, iter = coroutine, vim.api, vim.lsp, vim.iter

local function sep()
  return {
    stl = ' ',
    name = 'sep',
  }
end

local function fileinfo()
  return {
    stl = '%t%r%m',
    event = { 'BufEnter' },
    attr = 'Operator',
    name = 'fileinfo',
  }
end

local function search()
  return {
    stl = function()
      if vim.v.hlsearch == 0 then
        return ''
      end
      local s = vim.fn.searchcount()
      local current = s.current
      local cnt = math.min(s.total, s.maxcount)
      return string.format('[%d/%d]', current, cnt)
    end,
    event = { 'CursorHold' },
    attr = 'Repeat',
    name = 'search',
  }
end

local function lspinfo()
  return {
    stl = function(args)
      local client = lsp.get_clients({ bufnr = args.buf })[1]
      if not client then
        return ''
      end

      local msg = client and client.name or ''
      if args.data and args.data.params then
        local val = args.data.params.value
        msg = val.title
          .. ' '
          .. (val.message and val.message .. ' ' or '')
          .. (val.percentage and val.percentage .. '%' or '')
        if not val.message or val.kind == 'end' then
          msg = client.name
        end
      elseif args.event == 'BufEnter' then
        msg = client.name
      elseif args.event == 'LspDetach' then
        msg = ''
      end
      return '%.40{"' .. msg .. '"}'
    end,
    event = { 'LspProgress', 'LspAttach', 'LspDetach', 'BufEnter' },
    attr = 'Function',
    name = 'lspinfo',
  }
end

local function branch()
  return {
    stl = function()
      local icon = ' '
      local cmd = 'cd '
        .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':h')
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
    event = { 'User GitSignsUpdate', 'BufEnter' },
    attr = 'Include',
    name = 'branch',
  }
end

local function pad()
  return {
    stl = '%=',
    name = 'pad',
  }
end

local function lnumcol()
  return {
    stl = '%-4.(%l:%c%)',
    event = { 'CursorHold' },
    attr = 'Number',
    name = 'lnumcol',
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
    name = 'diagError',
  }
end

local function diagWarn()
  return {
    stl = function()
      return diagnostic_info(2)
    end,
    event = { 'DiagnosticChanged', 'BufEnter' },
    attr = 'DiagnosticWarn',
    name = 'diagWarn',
  }
end

local function diagInfo()
  return {
    stl = function()
      return diagnostic_info(3)
    end,
    event = { 'DiagnosticChanged', 'BufEnter' },
    attr = 'DiagnosticInfo',
    name = 'diagInfo',
  }
end

local function diagHint()
  return {
    stl = function()
      return diagnostic_info(4)
    end,
    event = { 'DiagnosticChanged', 'BufEnter' },
    attr = 'DiagnosticHint',
    name = 'diagHint',
  }
end

local function stl_format(name, val)
  return '%#' .. 'StatusLine' .. name .. '#' .. val .. '%*'
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
        pieces[#pieces + 1] = stl_format(item.name, item.stl)
      else
        pieces[#pieces + 1] = ''
        for _, event in ipairs({ unpack(item.event or {}) }) do
          if not e[event] then
            e[event] = {}
          end
          e[event][#e[event] + 1] = key
        end
      end
      api.nvim_set_hl(0, ('StatusLine%s'):format(item.name), {
        link = item.attr,
      })
    end)
    :totable()
  return comps, e, pieces
end

local function render(comps, events, pieces)
  return co.create(function(args)
    while true do
      local event = args.event == 'User' and args.event .. ' ' .. args.match or args.event
      for _, idx in ipairs(events[event]) do
        pieces[idx] = stl_format(comps[idx].name, comps[idx].stl(args))
      end

      pieces[3] = stl_format(comps[3].name, comps[3].stl(args))
      vim.opt.stl = table.concat(pieces)
      args = co.yield()
    end
  end)
end

return {
  setup = function()
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
  end,
}
