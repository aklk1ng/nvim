---@type vim.lsp.Config
return {
  cmd = { 'clangd', '--clang-tidy', '--header-insertion-decorators=false' },
  filetypes = { 'c', 'cpp' },
  root_markers = { '.clangd', '.clang-format', 'compile_commands.json' },
  init_options = { fallbackFlags = { vim.bo.filetype == 'cpp' and '-std=c++23' or nil } },
  capabilities = {
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
    offsetEncoding = { 'utf-8', 'utf-16' },
  },
  on_attach = function(client, bufnr)
    -- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/clangd.lua#L4
    vim.api.nvim_buf_create_user_command(bufnr, 'ClangdSwitchSourceHeader', function()
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
      end)
    end, {})

    vim.api.nvim_create_autocmd('LspDetach', {
      buffer = bufnr,
      callback = function(args)
        if args.data.client_id == client.id then
          vim.api.nvim_buf_del_user_command(bufnr, 'ClangdSwitchSourceHeader')
          return true -- Delete this autocmd.
        end
      end,
    })
  end,
}
