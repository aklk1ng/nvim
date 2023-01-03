local M = {}
function M.setup()

--highlight the signcolumn not use symbol
vim.cmd [[
  highlight! DiagnosticLineNrError guibg=#51202A guifg=#FF0000 gui=bold
  highlight! DiagnosticLineNrWarn guibg=#51412A guifg=#FFA500 gui=bold
  highlight! DiagnosticLineNrInfo guibg=#1E535D guifg=#00FFFF gui=bold
  highlight! DiagnosticLineNrHint guibg=#1E205D guifg=#0AAA35 gui=bold

  sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=DiagnosticLineNrError
  sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=DiagnosticLineNrWarn
  sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=DiagnosticLineNrInfo
  sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=DiagnosticLineNrHint
]]

    --the lspconfig maps
    ---@diagnostic disable-next-line: unused-local
    local on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
    end
    --Enable (broadcasting) snippet capability for completion
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    --activate language clients
    require 'lspconfig'.clangd.setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
    require'lspconfig'.pylsp.setup{
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            pylsp = {
                plugins = {
                    pycodestyle = {
                        ignore = {'W391'},
                        maxLineLength = 100
                    }
                }
            }
        }
    }
    -- require 'lspconfig'.jedi_language_server.setup {
    --     on_attach = on_attach,
    --     capabilities = capabilities,
    -- }
    require 'lspconfig'.bashls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
    require 'lspconfig'.cmake.setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
    require 'lspconfig'.jsonls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
    require('lspconfig').cssls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
    require 'lspconfig'.gopls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
    require 'lspconfig'.sumneko_lua.setup {
        on_attach = on_attach,
        settings = {
            Lua = {
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { 'vim' },
                },
                runtime = { version = 'LuaJIT' },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false
                },
            },
        },
    }
    require 'lspconfig'.tsserver.setup {
        on_attach = on_attach,
        filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
        cmd = { "typescript-language-server", "--stdio" },
        capabilities = capabilities,
    }
    require 'lspconfig'.marksman.setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
    require'lspconfig'.rust_analyzer.setup{
        on_attach = on_attach,
        settings = {
            ["rust-analyzer"] = {
                imports = {
                    granularity = {
                        group = "module",
                    },
                    prefix = "self",
                },
                cargo = {
                    buildScripts = {
                        enable = true,
                    },
                },
                procMacro = {
                    enable = true
                },
            }
        },
        capabilities = capabilities,
    }
end
return M
