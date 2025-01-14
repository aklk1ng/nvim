local methods = vim.lsp.protocol.Methods

_G.on_attach = function(client, bufnr)
  client.server_capabilities.semanticTokensProvider = nil
end
_G._capabilities = vim.lsp.protocol.make_client_capabilities()

vim.lsp.config(
  '*',
  { root_markers = { '.git' }, on_attach = _G.on_attach, _capabilities = _G._capabilities }
)

-- https://github.com/neovim/neovim/commit/3f1d09bc94d02266d6fa588a2ccd1be1ca084cf7
local lsp_dir = vim.fs.joinpath(vim.fn.stdpath('config') --[[@as string]], 'lsp')
vim.lsp.enable(vim
  .iter(vim.fs.dir(lsp_dir))
  :filter(function(f)
    return vim.fn.fnamemodify(f, ':e') == 'lua'
  end)
  :map(function(f)
    return vim.fn.fnamemodify(f, ':t:r')
  end)
  :totable())

---Sets up LSP keymaps and autocommands for the given buffer.
---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
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

  if client:supports_method('textDocument/inlayHint') then
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

  -- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/clangd.lua#L4
  if client.name == 'clangd' then
    vim.api.nvim_create_user_command('ClangdSwitchSourceHeader', function()
      local params = vim.lsp.util.make_text_document_params(bufnr)
      client:request('textDocument/switchSourceHeader', params, function(err, result)
        if err then
          error(tostring(err))
        end
        if not result then
          print('Corresponding file cannot be determined')
          return
        end
        vim.api.nvim_command('edit ' .. vim.uri_to_fname(result))
      end, bufnr)
    end, {})
  end
end

vim.diagnostic.config({
  signs = false,
})

--- HACK: Override `vim.lsp.util.stylize_markdown` to use Treesitter.
---@param bufnr integer
---@param contents string[]
---@param opts table
---@return string[]
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.util.stylize_markdown = function(bufnr, contents, opts)
  contents = vim.lsp.util._normalize_markdown(contents, {
    width = vim.lsp.util._make_floating_popup_size(contents, opts),
  })
  vim.bo[bufnr].filetype = 'markdown'
  pcall(vim.treesitter.start, bufnr)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)

  return contents
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- I don't think this can happen but it's a wild world out there.
    if not client then
      return
    end

    on_attach(client, args.buf)
  end,
})
