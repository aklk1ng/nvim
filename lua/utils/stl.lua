-- https://github.com/nvimdev/modeline.nvim

local function stl_attr(group)
  local color = vim.api.nvim_get_hl(0, { name = group, link = false })
  return {
    bg = vim.api.nvim_get_hl(0, { name = 'StatusLine' }).bg or 'black',
    fg = color.fg,
  }
end

local function sep()
  return {
    name = 'sep',
    stl = ' ',
  }
end

local function fileinfo()
  return {
    name = 'fileinfo',
    stl = '%f%r%m',
    event = { 'BufEnter' },
    attr = stl_attr('Normal'),
  }
end

local function lspinfo()
  return {
    name = 'lspinfo',
    stl = function(args)
      local client = vim.lsp.get_clients({ bufnr = 0 })[1]
      if not client then
        return ''
      end

      local msg = ''
      if args.data and args.data.params then
        local val = args.data.params.value
        if val.message and val.kind ~= 'end' then
          msg = ('%s %s%s'):format(
            val.title,
            (val.message and val.message .. ' ' or ''),
            (val.percentage and val.percentage .. '%' or '')
          )
        end
      elseif args.event == 'LspDetach' then
        msg = ''
      end
      return '%.40{"' .. msg .. '"}'
    end,
    event = { 'LspProgress', 'LspAttach', 'LspDetach', 'BufEnter' },
    attr = stl_attr('Normal'),
  }
end

local function pad()
  return {
    name = 'pad',
    stl = '%=',
  }
end

local function lnumcol()
  return {
    name = 'lnumcol',
    stl = '%l:%c %P',
    event = { 'CursorHold' },
    attr = stl_attr('Normal'),
  }
end

local function diagnostic_info(severity)
  if not vim.diagnostic.is_enabled({ bufnr = 0 }) or #vim.lsp.get_clients({ bufnr = 0 }) == 0 then
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
    name = 'diagError',
    stl = function()
      return diagnostic_info(vim.diagnostic.severity.ERROR)
    end,
    event = { 'DiagnosticChanged', 'BufEnter', 'LspAttach' },
    attr = stl_attr('DiagnosticError'),
  }
end

local function diagWarn()
  return {
    name = 'diagWarn',
    stl = function()
      return diagnostic_info(vim.diagnostic.severity.WARN)
    end,
    event = { 'DiagnosticChanged', 'BufEnter', 'LspAttach' },
    attr = stl_attr('DiagnosticWarn'),
  }
end

local function diagInfo()
  return {
    name = 'diagInfo',
    stl = function()
      return diagnostic_info(vim.diagnostic.severity.INFO)
    end,
    event = { 'DiagnosticChanged', 'BufEnter', 'LspAttach' },
    attr = stl_attr('DiagnosticInfo'),
  }
end

local function diagHint()
  return {
    name = 'diagHint',
    stl = function()
      return diagnostic_info(vim.diagnostic.severity.HINT)
    end,
    event = { 'DiagnosticChanged', 'BufEnter', 'LspAttach' },
    attr = stl_attr('DiagnosticHint'),
  }
end

local function stl_format(name, val)
  return ('%%#Stl%s#%s%%*'):format(name, val)
end

local function default()
  local comps = {
    fileinfo(),
    sep(),
    diagError(),
    diagWarn(),
    diagInfo(),
    diagHint(),
    sep(),
    lspinfo(),

    pad(),
    pad(),

    lnumcol(),
  }
  local e, pieces = {}, {}
  vim
    .iter(ipairs(comps))
    :map(function(key, item)
      if type(item) == 'string' then
        pieces[#pieces + 1] = item
      elseif type(item.stl) == 'string' then
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
      if item.attr and item.name then
        vim.api.nvim_set_hl(0, ('Stl%s'):format(item.name), item.attr)
      end
    end)
    :totable()
  return comps, e, pieces
end

local function render(comps, events, pieces)
  return coroutine.create(function(args)
    while true do
      for _, idx in ipairs(events[args.event]) do
        pieces[idx] = stl_format(comps[idx].name, comps[idx].stl(args))
      end

      vim.opt.stl = table.concat(pieces)
      args = coroutine.yield()
    end
  end)
end

return {
  setup = function()
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
  end,
}
