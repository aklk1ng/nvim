local M = {}

function M.snippet()
  require('snippets').setup({
    search_paths = { vim.fn.stdpath('config') .. '/lua/snippets/' },
  })
end

function M.cmp()
  local cmp = require('cmp')

  local function expand(snippet)
    -- Native sessions don't support nested snippet sessions.
    -- Always use the top-level session.
    -- Otherwise, when on the first placeholder and selecting a new completion,
    -- the nested session will be used instead of the top-level session.
    -- See: https://github.com/LazyVim/LazyVim/issues/3199
    local session = vim.snippet.active() and vim.snippet._session or nil

    local ok, err = pcall(vim.snippet.expand, snippet)
    if not ok then
      local fixed = M.snippet_fix(snippet)
      ok = pcall(vim.snippet.expand, fixed)

      local msg = ok and 'Failed to parse snippet,\nbut was able to fix it automatically.'
        or ('Failed to parse snippet.\n' .. err)
      vim.notify(
        ([[%s
```%s
%s
```]]):format(msg, vim.bo.filetype, snippet),
        vim.log.levels.WARN
      )
    end

    -- Restore top-level session when needed
    if session then
      vim.snippet._session = session
    end
  end

  local function snippet_replace(snippet, fn)
    return snippet:gsub('%$%b{}', function(m)
      local n, name = m:match('^%${(%d+):(.+)}$')
      return n and fn({ n = n, text = name }) or m
    end) or snippet
  end

  local function snippet_preview(snippet)
    local ok, parsed = pcall(function()
      return vim.lsp._snippet_grammar.parse(snippet)
    end)
    return ok and tostring(parsed)
      or snippet_replace(snippet, function(placeholder)
        return snippet_preview(placeholder.text)
      end):gsub('%$0', '')
  end

  local function add_missing_snippet_docs(window)
    local Kind = cmp.lsp.CompletionItemKind
    local entries = window:get_entries()
    for _, entry in ipairs(entries) do
      if entry:get_kind() == Kind.Snippet then
        local item = entry:get_completion_item()
        if not item.documentation and item.insertText then
          item.documentation = {
            kind = cmp.lsp.MarkupKind.Markdown,
            value = string.format(
              '```%s\n%s\n```',
              vim.bo.filetype,
              snippet_preview(item.insertText)
            ),
          }
        end
      end
    end
  end

  cmp.setup({
    snippet = {
      expand = function(args)
        expand(args.body)
      end,
    },
    window = {
      completion = {
        side_padding = 0,
        scrollbar = false,
      },
      documentation = {
        winhighlight = 'Normal:Pmenu,FloatBorder:CursorLine',
      },
    },
    view = {
      entries = {
        follow_cursor = true,
      },
    },
    completion = {
      keyword_length = 1,
    },
    preselect = cmp.PreselectMode.None,
    mapping = cmp.mapping.preset.insert({
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      -- builtin <C-e>/<C-y> behavior in insert mode is interesting
      _G.map({ 'i', 's' }, '<C-e>', function()
        if cmp.visible() then
          cmp.mapping.abort()
        else
          return '<C-e>'
        end
      end, { expr = true }),
      ['<C-y>'] = cmp.mapping.confirm({ select = true }),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if vim.snippet.active({ direction = 1 }) then
          vim.snippet.jump(1)
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if vim.snippet.active({ direction = -1 }) then
          vim.snippet.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'buffer' },
      { name = 'snippets', priority = 100 },
    }),
  })

  cmp.event:on('menu_opened', function(event)
    add_missing_snippet_docs(event.window)
  end)

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
  require('mason').setup()
  require('mason-lspconfig').setup({
    ensure_installed = { 'clangd', 'zls', 'lua_ls', 'pyright', 'bashls' },
  })
  ---@diagnostic disable-next-line: unused-local
  M._attach = function(client, bufnr)
    vim.opt.omnifunc = 'v:lua.vim.lsp.omnifunc'
    -- client.server_capabilities.semanticTokensProvider = nil
  end
  --Enable (broadcasting) snippet capability for completion
  M.capabilities = vim.lsp.protocol.make_client_capabilities()
  if pcall(require, 'cmp_nvim_lsp') then
    M.capabilities = require('cmp_nvim_lsp').default_capabilities(M.capabilities)
  end

  local lspconfig = require('lspconfig')
  lspconfig.clangd.setup({
    cmd = { 'clangd', '--background-index' },
    on_attach = M._attach,
    capabilities = M.capabilities,
  })
  lspconfig.zls.setup({
    on_attach = M._attach,
    capabilities = M.capabilities,
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
    on_attach = M._attach,
    capabilities = M.capabilities,
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
    on_attach = M._attach,
    capabilities = M.capabilities,
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
          library = { vim.env.VIMRUNTIME, '${3rd}/busted/library', '${3rd}/luv/library' },
        },
        completion = {
          callSnippet = 'Replace',
        },
        hint = {
          enable = true,
        },
      },
    },
  })
  lspconfig.rust_analyzer.setup({
    on_attach = M._attach,
    capabilities = M.capabilities,
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

  local servers = {
    'pyright',
    'bashls',
  }
  for _, server in ipairs(servers) do
    lspconfig[server].setup({
      on_attach = M._attach,
      capabilities = M.capabilities,
    })
  end
end

function M.treesitter()
  require('nvim-treesitter.configs').setup({
    ensure_installed = {
      'c',
      'cpp',
      'python',
      'lua',
      'bash',
      'zig',
      'rust',
      'diff',
      'go',
      'markdown',
      'markdown_inline',
      'vimdoc',
      'comment',
    },
    sync_install = true,
    highlight = {
      enable = true,
      disable = function(_, buf)
        local max_filesize = 500 * 1024
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
        return false
      end,
    },
  })
end

function M.lspsaga()
  require('lspsaga').setup({
    lightbulb = {
      enable = false,
    },
  })
end

function M.telescope()
  require('telescope').setup({
    defaults = {
      selection_caret = ' ',
      layout_config = {
        horizontal = {
          prompt_position = 'top',
          preview_width = 0.55,
          results_width = 0.8,
        },
        height = 0.9,
        width = 0.9,
      },
      sorting_strategy = 'ascending',
    },
    pickers = {
      buffers = {
        theme = 'dropdown',
        previewer = false,
        ignore_current_buffer = true,
      },
      lsp_references = { theme = 'ivy' },
      colorscheme = { enable_preview = true },
    },
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      },
    },
  })
  require('telescope').load_extension('fzf')
end

function M.surround()
  require('nvim-surround').setup()
end

function M.files()
  require('mini.files').setup({
    mappings = {
      go_in = '<CR>',
      go_out = '-',
    },
  })
end

function M.move()
  require('mini.move').setup({})
end

function M.gitsigns()
  require('gitsigns').setup({
    attach_to_untracked = true,
  })
end

function M.conform()
  require('conform').setup({
    formatters_by_ft = {
      c = { 'clang_format' },
      cpp = { 'clang_format' },
      lua = { 'stylua' },
      go = { 'goimports', 'gofmt' },
      python = { 'isort', 'black' },
      rust = { 'rustfmt', lsp_format = 'fallback' },
      sh = { 'shfmt' },
      zig = { 'zigfmt' },
      toml = { 'taplo' },
      typescript = { 'prettier' },
      javascript = { 'prettier' },
      typescriptreact = { 'prettier' },
      javascriptreact = { 'prettier' },
      markdown = { 'prettier' },
      json = { 'prettier' },
      json5 = { 'prettier' },
      jsonc = { 'prettier' },
      yaml = { 'prettier' },
      html = { 'prettier' },
      css = { 'prettier' },
      fish = { 'fish_indent' },
    },
    formatters = {
      clang_format = {
        command = 'clang-format',
        args = {
          '--style={'
            .. 'IndentWidth: '
            .. vim.opt_local.shiftwidth:get()
            .. ','
            .. 'AlwaysBreakTemplateDeclarations: true,'
            .. 'AllowShortEnumsOnASingleLine: false,'
            .. 'AllowShortFunctionsOnASingleLine: true,'
            .. 'BreakAfterAttributes: Always,'
            .. 'SortIncludes: Never,'
            .. 'SeparateDefinitionBlocks: Always,'
            .. 'ColumnLimit: 80'
            .. '}',
        },
        stdin = true,
      },
      stylua = {
        command = 'stylua',
        args = {
          '--column-width',
          '100',
          '--quote-style',
          'AutoPreferSingle',
          '--indent-type',
          'Spaces',
          '--indent-width',
          '2',
          '-',
        },
        stdin = true,
      },
      shfmt = {
        cmd = 'shfmt',
        args = { '-i', 4 },
        stdin = true,
      },
    },
    format_on_save = function(bufnr)
      -- Disable autoformat for files in a certain path
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      if bufname:match('/node_modules/') or bufname:match('neovim') then
        return
      end

      return { timeout_ms = 500, lsp_format = 'fallback' }
    end,
  })
end

function M.colorizer()
  require('colorizer').setup()
end

return M
