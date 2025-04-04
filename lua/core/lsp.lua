local methods = vim.lsp.protocol.Methods

-- https://github.com/neovim/neovim/commit/3f1d09bc94d02266d6fa588a2ccd1be1ca084cf7
vim.lsp.config('*', { root_markers = { '.git' } })
vim.lsp.enable(vim
  .iter(vim.api.nvim_get_runtime_file('lsp/*.lua', true))
  :map(function(f)
    return vim.fn.fnamemodify(f, ':t:r')
  end)
  :totable())

---Sets up LSP keymaps and autocommands for the given buffer.
---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
  client.server_capabilities.semanticTokensProvider = nil

  if client:supports_method(methods.textDocument_documentHighlight) then
    local document_highlight = vim.api.nvim_create_augroup('cursor_highlights', { clear = false })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave' }, {
      group = document_highlight,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave' }, {
      group = document_highlight,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  if client:supports_method(methods.textDocument_signatureHelp) then
    vim.keymap.set({ 'i', 's' }, '<C-g>', function()
      local ok, cmp = pcall(require, 'cmp')
      if ok and cmp.visible() then
        cmp.close()
      end

      vim.lsp.buf.signature_help()
    end, { buffer = bufnr })
  end

  if client:supports_method(methods.textDocument_inlayHint) then
    vim.keymap.set('n', '<leader><leader>i', function()
      vim.lsp.inlay_hint.enable(
        not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
        { bufnr = bufnr }
      )
    end)
  end

  if client:supports_method(methods.textDocument_definition) then
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
    vim.keymap.set('n', 'gD', _G._cmd('FzfLua lsp_definitions'), { buffer = bufnr })
  end

  vim.keymap.set('n', ']d', function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, { buffer = bufnr })
  vim.keymap.set('n', '[d', function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, { buffer = bufnr })
  vim.keymap.set('n', ']e', function()
    vim.diagnostic.jump({ count = 1, float = true, severity = 'ERROR' })
  end, { buffer = bufnr })
  vim.keymap.set('n', '[e', function()
    vim.diagnostic.jump({ count = -1, float = true, severity = 'ERROR' })
  end, { buffer = bufnr })
end

vim.diagnostic.config({
  signs = false,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = _G._augroup,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- I don't think this can happen but it's a wild world out there.
    if not client then
      return
    end

    on_attach(client, args.buf)
  end,
})
