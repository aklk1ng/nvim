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
  local cmp = require('cmp')
  local luasnip = require('luasnip')
  local kind_icons = require('utils.icons')

  local keymap = require('cmp.utils.keymap')
  local feedkeys = require('cmp.utils.feedkeys')

  local keymap_cinkeys = function(expr)
    return string.format(
      keymap.t('<Cmd>set cinkeys=%s<CR>'),
      expr and vim.fn.escape(expr, '| \t\\') or ''
    )
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
        luasnip.lsp_expand(args.body)
      end,
    },
    window = {
      completion = {
        scrollbar = false,
      },
      documentation = {
        winhighlight = 'Normal:Pmenu',
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
      ['<Tab>'] = cmp.mapping(function(fallback)
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip', priority = 100 },
      { name = 'buffer' },
    }),
    formatting = {
      fields = { 'kind', 'abbr' },
      format = function(_, vim_item)
        vim_item.kind = kind_icons.get(vim_item.kind, false)
        return vim_item
      end,
    },
  })
end

function M.lspconfig()
  vim.diagnostic.config({
    signs = false,
    severity_sort = true,
    underline = true,
    update_in_insert = false,
    virtual_text = true,
  })
  -- auto kill server when no buffer attach after a while
  local debounce
  vim.api.nvim_create_autocmd('LspDetach', {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client or #client.attached_buffers > 0 then
        return
      end

      if debounce and debounce:is_active() then
        debounce:stop()
        debounce:close()
        debounce = nil
      end

      debounce:start(5000, 0, function()
        vim.schedule(function()
          pcall(vim.lsp.stop_client, args.data.client_id, true)
        end)
      end)
    end,
  })
  ---@diagnostic disable-next-line: unused-local
  local on_attach = function(client, bufnr)
    vim.opt.omnifunc = 'v:lua.vim.lsp.omnifunc'
    -- client.server_capabilities.semanticTokensProvider = nil
  end
  --Enable (broadcasting) snippet capability for completion
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
  -- capabilities = vim.tbl_deep_extend('force', capabilities, require('epo').register_cap())

  vim.lsp.handlers['workspace/diagnostic/refresh'] = function(_, _, ctx)
    local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
    local bufnr = vim.api.nvim_get_current_buf()
    vim.diagnostic.reset(ns, bufnr)
    return true
  end

  require('lspconfig').clangd.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
  require('lspconfig').pylsp.setup({
    settings = {
      pylsp = {
        plugins = {
          pycodestyle = {
            maxLineLength = 88,
          },
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
      },
    },
  })
  require('lspconfig').cmake.setup({
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
  require('lspconfig').lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    on_init = function(client)
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
        Lua = {
          diagnostics = {
            globals = { 'vim' },
            disable = {
              'missing-fields',
              'no-unknown',
            },
          },
          runtime = {
            version = 'LuaJIT',
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = { vim.env.VIMRUNTIME },
          },
          completion = {
            callSnippet = 'Replace',
          },
          hint = {
            enable = true,
          },
        },
      })
      client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
      return true
    end,
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
