local methods = vim.lsp.protocol.Methods

vim.opt.completeopt = 'menu,menuone,noselect,fuzzy,popup'
vim.opt.completeitemalign = 'kind,abbr,menu'

vim.lsp.config('*', { root_markers = { '.git' } })
vim.lsp.enable(vim
  .iter(vim.api.nvim_get_runtime_file('lsp/*.lua', true))
  :map(function(f)
    return vim.fn.fnamemodify(f, ':t:r')
  end)
  :totable())

vim.diagnostic.config({
  signs = false,
  jump = {
    on_jump = function(diagnostic, bufnr)
      vim.diagnostic.open_float({ bufnr = bufnr, scope = 'cursor', focus = false })
    end,
  },
})

vim.lsp.log.set_level(vim.log.levels.OFF)

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
    vim.keymap.set({ 'i', 's' }, '<C-g>', vim.lsp.buf.signature_help, { buffer = bufnr })
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
    vim.keymap.set('n', 'gp', _G._cmd('FzfLua lsp_definitions'), { buffer = bufnr })
  end

  vim.keymap.set('n', ']e', function()
    vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
  end, { buffer = bufnr })
  vim.keymap.set('n', '[e', function()
    vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
  end, { buffer = bufnr })

  if client:supports_method(methods.textDocument_completion) then
    local chars = client.server_capabilities.completionProvider.triggerCharacters
    if chars then
      for i = string.byte('a'), string.byte('z') do
        if not vim.list_contains(chars, string.char(i)) then
          table.insert(chars, string.char(i))
        end
      end

      for i = string.byte('A'), string.byte('Z') do
        if not vim.list_contains(chars, string.char(i)) then
          table.insert(chars, string.char(i))
        end
      end
    end
    vim.lsp.completion.enable(true, client.id, bufnr, {
      autotrigger = true,
      convert = function(item)
        local kind = vim.lsp.protocol.CompletionItemKind[item.kind]
        local doc = item.documentation or {}
        local info = doc.value or ''
        return {
          menu = '',
          kind = _G._cmp_kinds[kind] or ' ',
          kind_hlgroup = string.format('Kind%s', kind),
          info = info and info:gsub('\n+%s*\n$', '') or nil,
        }
      end,
    })

    if
      #vim.api.nvim_get_autocmds({
        buffer = bufnr,
        event = { 'CompleteChanged' },
        group = _G._augroup,
      }) == 0
    then
      -- https://github.com/neovim/neovim/pull/32553
      vim.api.nvim_create_autocmd('CompleteChanged', {
        buffer = bufnr,
        group = _G._augroup,
        callback = function()
          local info = vim.fn.complete_info({ 'selected' })
          if info.preview_bufnr and vim.bo[info.preview_bufnr].filetype == '' then
            vim.bo[info.preview_bufnr].filetype = 'markdown'
            vim.wo[info.preview_winid].conceallevel = 2
            vim.wo[info.preview_winid].concealcursor = 'niv'
            vim.wo[info.preview_winid].wrap = true
          end
        end,
      })
    end
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = _G._augroup,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if not client then
      return
    end

    on_attach(client, args.buf)
  end,
})
