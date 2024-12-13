-- Most of the code comes from MariaSolOs.

local api, lsp, diagnostic = vim.api, vim.lsp, vim.diagnostic
local methods = lsp.protocol.Methods

_G._attach = function(client, bufnr)
  vim.opt.omnifunc = 'v:lua.vim.lsp.omnifunc'
  -- client.server_capabilities.semanticTokensProvider = nil
end
--Enable (broadcasting) snippet capability for completion
_G._capabilities = vim.lsp.protocol.make_client_capabilities()
if pcall(require, 'cmp_nvim_lsp') then
  _G._capabilities = require('cmp_nvim_lsp').default_capabilities(_G._capabilities)
end
if pcall(require, 'blink.cmp') then
  _G._capabilities = require('blink.cmp').get_lsp_capabilities(_G._capabilities)
end

-- https://github.com/neovim/neovim/commit/3f1d09bc94d02266d6fa588a2ccd1be1ca084cf7
lsp.config(
  '*',
  { root_markers = { '.git' }, on_attach = _G._attach, _capabilities = _G._capabilities }
)

lsp.enable(vim
  .iter(vim.fs.dir(vim.fn.stdpath('config') .. '/lsp'))
  :map(function(f)
    return vim.fn.fnamemodify(f, ':t:r')
  end)
  :totable())

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
    diagnostic.jump({ count = 1, float = true })
  end, { buffer = bufnr })
  _G.map('n', '[d', function()
    diagnostic.jump({ count = -1, float = true })
  end, { buffer = bufnr })
  _G.map('n', ']e', function()
    diagnostic.jump({ count = 1, float = true, severity = 'ERROR' })
  end, { buffer = bufnr })
  _G.map('n', '[e', function()
    diagnostic.jump({ count = -1, float = true, severity = 'ERROR' })
  end, { buffer = bufnr })
  _G.map('n', 'K', lsp.buf.hover, { buffer = bufnr })
  _G.map('n', 'gd', lsp.buf.definition, { buffer = bufnr })
  _G.map('n', 'gra', function()
    -- Use the fzf-lua wrapper.
    require('fzf-lua').register_ui_select({}, true)
    lsp.buf.code_action()
  end, { buffer = bufnr })
  _G.map('n', 'gD', lsp.buf.type_definition, { buffer = bufnr })

  -- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/clangd.lua#L4
  if client.name == 'clangd' then
    api.nvim_create_user_command('ClangdSwitchSourceHeader', function()
      local params = { uri = vim.uri_from_bufnr(bufnr) }
      client:request('textDocument/switchSourceHeader', params, function(err, result)
        if err then
          error(tostring(err))
        end
        if not result then
          print('Corresponding file cannot be determined')
          return
        end
        api.nvim_command('edit ' .. vim.uri_to_fname(result))
      end, bufnr)
    end, {})
  end
end

diagnostic.config({
  signs = false,
  virtual_text = false,
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
