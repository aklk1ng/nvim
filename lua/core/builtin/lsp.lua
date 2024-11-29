-- Most of the code comes from MariaSolOs.

local api, lsp = vim.api, vim.lsp
local methods = lsp.protocol.Methods
local hover = lsp.buf.hover

---@diagnostic disable-next-line: duplicate-set-field
lsp.buf.hover = function()
  return hover({
    border = 'rounded',
  })
end

--- Sets up LSP keymaps and autocommands for the given buffer.
---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
  if client:supports_method(methods.textDocument_signatureHelp) then
    _G.map({ 'i', 's' }, '<C-k>', function()
      -- Close the completion menu first (if open).
      local cmp = require('cmp')
      if cmp.visible() then
        cmp.close()
      end
      -- local cmp = require('blink.cmp')
      -- cmp.hide()

      lsp.buf.signature_help()
    end)
  end

  if client:supports_method(methods.textDocument_documentHighlight) then
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
  _G.map('n', 'K', lsp.buf.hover, { buffer = bufnr })
  _G.map('n', 'grn', lsp.buf.rename, { buffer = bufnr })
  _G.map('n', 'ga', function()
    -- Use the fzf-lua wrapper.
    require('fzf-lua').register_ui_select({}, true)
    lsp.buf.code_action()
  end, { buffer = bufnr })
  _G.map('n', 'gd', lsp.buf.definition, { buffer = bufnr })
  _G.map('n', 'gD', lsp.buf.type_definition, { buffer = bufnr })
  _G.map('n', 'grr', lsp.buf.references, { buffer = bufnr })
end

vim.diagnostic.config({
  signs = false,
  virtual_text = false,
  float = {
    border = 'rounded',
  },
})

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
