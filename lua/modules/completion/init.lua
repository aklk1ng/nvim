local M = {}
local helper = require('core.helper')

function M.lua_snip()
  local ls = require('luasnip')
  ls.config.set_config({
    -- disable the jump when i move outside the selection
    history = false,
    -- dynamic udpate the snippets when i type
    updateevents = 'TextChanged,TextChangedI',
  })
  require('luasnip.loaders.from_vscode').lazy_load({
    paths = { helper.get_config_path() .. '/lua/snippets/' },
  })
end

function M.cmp()
  local status, cmp = pcall(require, 'cmp')
  if not status then
    vim.notify('cmp not found')
    return
  end
  local luasnip = require('luasnip')
  local kind_icons = require('utils.icons')

  local keymap = require('cmp.utils.keymap')
  local feedkeys = require('cmp.utils.feedkeys')

  local keymap_cinkeys = function(expr)
    return string.format(keymap.t('<Cmd>set cinkeys=%s<CR>'), expr and vim.fn.escape(expr, '| \t\\') or '')
  end
  local confirm = function(fallback)
    if cmp.visible() then
      feedkeys.call(keymap_cinkeys(), 'n')
      cmp.confirm({ select = true })
      feedkeys.call(keymap_cinkeys(vim.bo.cinkeys), 'n')
    else
      fallback()
    end
  end

  cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    window = {
      completion = {
        cmp.config.window.bordered(),
        scrollbar = false,
      },
    },
    completion = {
      -- make the completion trigged when i type a letter not other invalid characters
      keyword_length = 1,
    },
    preselect = cmp.PreselectMode.None,
    mapping = cmp.mapping.preset.insert({
      ['<C-e>'] = cmp.mapping.abort(),
      ['<C-Space>'] = cmp.mapping(confirm, { 'i' }),
      ['<C-j>'] = cmp.mapping(function(fallback)
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<C-k>'] = cmp.mapping(function(fallback)
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'async_path' },
      { name = 'buffer' },
    }),
    formatting = {
      fields = { 'kind', 'abbr', 'menu' },
      format = function(_, vim_item)
        vim_item.menu = vim_item.kind
        vim_item.kind = kind_icons.get(vim_item.kind, false)
        return vim_item
      end,
    },
  })
end

function M.smarkpairs()
  require('pairs'):setup()
end

function M.neodev()
  require('neodev').setup({
    library = {
      runtime = '~/neovim/runtime/',
    },
  })
end

function M.lspconfig()
  local kind_icons = require('utils.icons')
  local signs = {
    Error = kind_icons.get('Error', false),
    Warn = kind_icons.get('Warn', false),
    Info = kind_icons.get('Info', false),
    Hint = kind_icons.get('Hint', false),
  }
  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
  vim.diagnostic.config({
    signs = false,
    severity_sort = true,
    underline = true,
    update_in_insert = false,
    virtual_text = true,
  })
  ---@diagnostic disable-next-line: unused-local
  local on_attach = function(client, bufnr)
    vim.opt.omnifunc = 'v:lua.vim.lsp.omnifunc'
    -- disable semantic token provided by lsp
    client.server_capabilities.semanticTokensProvider = nil
  end
  --Enable (broadcasting) snippet capability for completion
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  vim.lsp.handlers['workspace/diagnostic/refresh'] = function(_, _, ctx)
    local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
    local bufnr = vim.api.nvim_get_current_buf()
    vim.diagnostic.reset(ns, bufnr)
    return true
  end

  --activate language clients
  require('lspconfig').clangd.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = {
      'clangd',
      '--background-index',
      '--suggest-missing-includes',
      '--clang-tidy',
      '--header-insertion=iwyu',
    },
    filetypes = {
      'c',
      'cpp',
      'objc',
      'objcpp',
      'cuda',
    },
  })
  require('lspconfig').pyright.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = 'workspace',
          useLibraryCodeForTypes = true,
        },
      },
    },
  })
  require('lspconfig').zls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      zls = {
        enable_snippets = true,
        enable_ast_check_diagnostics = true,
        enable_autofix = true,
        operator_completions = true,
        enable_inlay_hints = true,
        inlay_hints_show_builtin = true,
        inlay_hints_exclude_single_argument = true,
        inlay_hints_hide_redundant_param_names = true,
        inlay_hints_hide_redundant_param_names_last_token = true,
      },
    },
  })
  require('lspconfig').bashls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
  require('lspconfig').cmake.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
  require('lspconfig').jsonls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  require('lspconfig').gopls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      gopls = {
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
  })
  require('lspconfig').marksman.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
  require('lspconfig').lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' },
          disable = {
            'missing-fields',
            'no-unknown',
          },
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
          library = { vim.env.VIMRUNTIME },
          checkThirdParty = false,
        },
        hint = {
          enable = true,
        },
      },
    },
  })
  require('lspconfig').rust_analyzer.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      ['rust-analyzer'] = {
        imports = {
          granularity = {
            group = 'module',
          },
          prefix = 'self',
        },
        cargo = {
          buildScripts = {
            enable = true,
          },
        },
        procMacro = {
          enable = true,
        },
      },
    },
  })
end

return M
