-- Most of the code comes from MariaSolOs.

local api, lsp = vim.api, vim.lsp
local methods = vim.lsp.protocol.Methods
local md_ns = vim.api.nvim_create_namespace('lsp_float')

lsp.handlers['workspace/diagnostic/refresh'] = function(_, _, ctx)
  local ns = lsp.diagnostic.get_namespace(ctx.client_id)
  local bufnr = api.nvim_get_current_buf()
  vim.diagnostic.reset(ns, bufnr)
  return true
end

--- Sets up LSP keymaps and autocommands for the given buffer.
---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
  if client.supports_method(methods.textDocument_signatureHelp) then
    _G.map({ 'i', 's' }, '<C-k>', function()
      -- Close the completion menu first (if open).
      local cmp = require('cmp')
      if cmp.visible() then
        cmp.close()
      end

      lsp.buf.signature_help()
    end)
  end

  if client.supports_method(methods.textDocument_documentHighlight) then
    local document_highlight = api.nvim_create_augroup('cursor_highlights', { clear = false })
    api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave' }, {
      group = document_highlight,
      buffer = bufnr,
      callback = lsp.buf.document_highlight,
    })
    api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave' }, {
      group = document_highlight,
      buffer = bufnr,
      callback = lsp.buf.clear_references,
    })
  end

  _G.map('n', ']d', function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, { buffer = bufnr })
  _G.map('n', '[d', function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, { buffer = bufnr })
  _G.map('n', ']e', function()
    vim.diagnostic.jump({ count = 1, float = true, severity = 'ERROR' })
  end, { buffer = bufnr })
  _G.map('n', '[e', function()
    vim.diagnostic.jump({ count = -1, float = true, severity = 'ERROR' })
  end, { buffer = bufnr })
  _G.map('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
  _G.map('n', 'grn', vim.lsp.buf.rename, { buffer = bufnr })
  _G.map('n', 'ga', function()
    -- Use the fzf-lua wrapper.
    require('fzf-lua').register_ui_select({}, true)
    vim.lsp.buf.code_action()
  end, { buffer = bufnr })
  _G.map('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
  _G.map('n', 'gD', vim.lsp.buf.type_definition, { buffer = bufnr })
  _G.map('n', 'grr', vim.lsp.buf.references, { buffer = bufnr })
end

vim.diagnostic.config({
  signs = false,
  virtual_text = false,
  float = {
    border = 'rounded',
  },
})

--- Adds extra inline highlights to the given buffer.
---@param buf integer
local function add_inline_highlights(buf)
  for l, line in ipairs(api.nvim_buf_get_lines(buf, 0, -1, false)) do
    for pattern, hl_group in pairs({
      ['^%s*(Parameters:)'] = '@text.title',
      ['^%s*(Return:)'] = '@text.title',
      ['^%s*(See also:)'] = '@text.title',
      ['{%S-}'] = '@parameter',
      ['|%S-|'] = '@text.reference',
    }) do
      local from = 1 ---@type integer?
      while from do
        local to
        from, to = line:find(pattern, from)
        if from then
          api.nvim_buf_set_extmark(buf, md_ns, l - 1, from - 1, {
            end_col = to,
            hl_group = hl_group,
          })
        end
        from = to and to + 1 or nil
      end
    end
  end
end

--- LSP handler that adds extra inline highlights, keymaps, and window options.
--- Code inspired from `noice`.
---@param handler fun(err: any, result: any, ctx: any, config: any): integer?, integer?
---@param focusable boolean
---@return fun(err: any, result: any, ctx: any, config: any)
local function enhanced_float_handler(handler, focusable)
  return function(err, result, ctx, config)
    local bufnr, winnr = handler(
      err,
      result,
      ctx,
      vim.tbl_deep_extend('force', config or {}, {
        border = 'rounded',
        focusable = focusable,
      })
    )

    if not bufnr or not winnr then
      return
    end

    -- Conceal everything.
    vim.wo[winnr].concealcursor = 'nv'

    -- Extra highlights.
    add_inline_highlights(bufnr)

    -- Add keymaps for opening links.
    if focusable and not vim.b[bufnr].markdown_keys then
      _G.map('n', 'K', function()
        -- Vim help links.
        local url = (vim.fn.expand('<cWORD>') --[[@as string]]):match('|(%S-)|')
        if url then
          return vim.cmd.help(url)
        end

        -- Markdown links.
        local col = api.nvim_win_get_cursor(0)[2] + 1
        local from, to
        from, to, url = api.nvim_get_current_line():find('%[.-%]%((%S-)%)')
        if from and col >= from and col <= to then
          vim.system({ 'xdg-open', url }, nil, function(res)
            if res.code ~= 0 then
              vim.notify('Failed to open URL' .. url, vim.log.levels.ERROR)
            end
          end)
        end
      end, { buffer = bufnr, silent = true })
      vim.b[bufnr].markdown_keys = true
    end
  end
end

lsp.handlers[methods.textDocument_hover] = enhanced_float_handler(lsp.handlers.hover, true)

--- HACK: Override `vim.lsp.util.stylize_markdown` to use Treesitter.
---@param bufnr integer
---@param contents string[]
---@param opts table
---@return string[]
---@diagnostic disable-next-line: duplicate-set-field
lsp.util.stylize_markdown = function(bufnr, contents, opts)
  contents = lsp.util._normalize_markdown(contents, {
    width = lsp.util._make_floating_popup_size(contents, opts),
  })
  vim.bo[bufnr].filetype = 'markdown'
  vim.treesitter.start(bufnr)
  api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)

  add_inline_highlights(bufnr)

  return contents
end

-- Update mappings when registering dynamic capabilities.
local register_capability = lsp.handlers[methods.client_registerCapability]
lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
  local client = lsp.get_client_by_id(ctx.client_id)
  if not client then
    return
  end

  on_attach(client, api.nvim_get_current_buf())

  return register_capability(err, res, ctx)
end

api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = lsp.get_client_by_id(args.data.client_id)

    -- I don't think this can happen but it's a wild world out there.
    if not client then
      return
    end

    on_attach(client, args.buf)
  end,
})
