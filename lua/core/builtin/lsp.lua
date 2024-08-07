-- most of the code comes from MariaSolOs

local api, lsp = vim.api, vim.lsp
local methods = vim.lsp.protocol.Methods
local ns_id = api.nvim_create_namespace('Aklk1ngLsp')

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
    api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave', 'BufEnter' }, {
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

  -- _G.map('n', ']d', function()
  --   vim.diagnostic.jump({ count = 1, float = true })
  -- end, { buffer = bufnr })
  -- _G.map('n', '[d', function()
  --   vim.diagnostic.jump({ count = -1, float = true })
  -- end, { buffer = bufnr })
  -- _G.map('n', ']e', function()
  --   vim.diagnostic.jump({ count = 1, float = true, severity = 'ERROR' })
  -- end, { buffer = bufnr })
  -- _G.map('n', '[e', function()
  --   vim.diagnostic.jump({ count = -1, float = true, severity = 'ERROR' })
  -- end, { buffer = bufnr })
  -- _G.map('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
  -- _G.map('n', 'grn', vim.lsp.buf.rename, { buffer = bufnr })
  -- _G.map('n', 'ga', function()
  --   -- use the telescope wrap builtin code action behavior
  --   if not _G.wrap_code_action then
  --     require('utils.select')
  --   end
  --   vim.lsp.buf.code_action()
  -- end, { buffer = bufnr })
  -- _G.map('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
  -- _G.map('n', 'grr', vim.lsp.buf.references, { buffer = bufnr })
  -- _G.map('n', 'gi', vim.lsp.buf.implementation, { buffer = bufnr })
end

vim.diagnostic.config({
  signs = false,
  severity_sort = true,
  underline = true,
  update_in_insert = false,
  virtual_text = true,
  float = {
    border = 'rounded',
  },
})

--- Adds extra inline highlights to the given buffer.
---@param buf integer
local function add_inline_highlights(buf)
  for l, line in ipairs(api.nvim_buf_get_lines(buf, 0, -1, false)) do
    for pattern, hl_group in pairs({
      ['@%S+'] = '@parameter',
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
          api.nvim_buf_set_extmark(buf, ns_id, l - 1, from - 1, {
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
        border = 'none',
        focusable = focusable,
        max_height = math.floor(vim.o.lines * 0.5),
        max_width = math.floor(vim.o.columns * 0.4),
      })
    )

    if not bufnr or not winnr then
      return
    end

    -- Conceal everything.
    vim.wo[winnr].concealcursor = 'n'

    -- Extra highlights.
    add_inline_highlights(bufnr)
  end
end
lsp.handlers[methods.textDocument_hover] = enhanced_float_handler(lsp.handlers.hover, true)
lsp.handlers[methods.textDocument_signatureHelp] =
  enhanced_float_handler(lsp.handlers.signature_help, true)

--- HACK: Override `vim.lsp.util.stylize_markdown` to use Treesitter.
---@param bufnr integer
---@param contents string[]
---@param opts table
---@return string[]
---@diagnostic disable-next-line: duplicate-set-field
lsp.util.stylize_markdown = function(bufnr, contents, opts)
  contents = vim.lsp.util._normalize_markdown(contents, {
    width = vim.lsp.util._make_floating_popup_size(contents, opts),
  })
  vim.bo[bufnr].filetype = 'markdown'
  vim.treesitter.start(bufnr)
  api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)

  add_inline_highlights(bufnr)

  return contents
end

-- actually i like the border for hover
lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = 'rounded',
})

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
