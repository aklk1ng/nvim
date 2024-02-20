local M = {}

function M.lua_snip()
  local ls = require('luasnip')
  ls.config.set_config({
    -- disable the jump when i move outside the selection
    history = false,
    -- dynamic udpate the snippets when i type
    updateevents = 'TextChanged,TextChangedI',
  })
  require('luasnip.loaders.from_vscode').lazy_load({
    paths = { vim.fn.stdpath('config') .. '/lua/snippets/' },
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
    view = {
      entries = {
        follow_cursor = true,
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
      { name = 'buffer', keyword_length = 3 },
    }),
    formatting = {
      fields = { 'kind', 'abbr' },
      format = function(_, vim_item)
        vim_item.kind = kind_icons.get(vim_item.kind, false)
        return vim_item
      end,
    },
  })

  -- Override the documentation handler to remove the redundant detail section.
  ---@diagnostic disable-next-line: duplicate-set-field
  require('cmp.entry').get_documentation = function(self)
    local item = self:get_completion_item()

    if item.documentation then
      return vim.lsp.util.convert_input_to_markdown_lines(item.documentation)
    end

    -- Use the item's detail as a fallback if there's no documentation.
    if item.detail then
      local ft = self.context.filetype
      local dot_index = string.find(ft, '%.')
      if dot_index ~= nil then
        ft = string.sub(ft, 0, dot_index - 1)
      end
      return (vim.split(('```%s\n%s```'):format(ft, vim.trim(item.detail)), '\n'))
    end

    return {}
  end
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

  local lspconfig = require('lspconfig')
  lspconfig.clangd.setup({
    cmd = { 'clangd', '--background-index' },
    on_attach = on_attach,
    capabilities = capabilities,
  })
  lspconfig.pyright.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
  lspconfig.zls.setup({
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
  lspconfig.gopls.setup({
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
  lspconfig.lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        diagnostics = {
          unusedLocalExclude = { '_*' },
          globals = { 'vim' },
          disable = {
            'missing-fields',
            'no-unknown',
          },
        },
        workspace = {
          checkThirdParty = false,
          library = { vim.env.VIMRUNTIME },
        },
        completion = {
          callSnippet = 'Replace',
        },
      },
    },
  })
  lspconfig.rust_analyzer.setup({
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
