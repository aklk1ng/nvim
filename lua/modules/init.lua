local M = {}

function M.snippet()
  require('snippets').setup({
    search_paths = { vim.fn.stdpath('config') .. '/snippets' },
  })
end

function M.cmp()
  local cmp_kinds = {
    Text = '',
    Method = '',
    Function = '',
    Constructor = '',
    Field = '',
    Variable = '',
    Class = '',
    Interface = ' ',
    Module = '',
    Property = '',
    Unit = '',
    Value = '',
    Enum = '',
    Keyword = '',
    Snippet = '',
    Color = '',
    File = '',
    Reference = '',
    Folder = '',
    EnumMember = '',
    Constant = '',
    Struct = '',
    Event = '',
    Operator = '',
    TypeParameter = '',
  }
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
        winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu',
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
    mapping = cmp.mapping.preset.insert({
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-e>'] = cmp.mapping.abort(),
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
    formatting = {
      fields = { 'kind', 'abbr', 'menu' },
      format = function(_, vim_item)
        vim_item.kind = cmp_kinds[vim_item.kind] or ''
        return vim_item
      end,
    },
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

function M.treesitter()
  require('nvim-treesitter.configs').setup({
    ensure_installed = {
      'c',
      'cpp',
      'lua',
      'markdown',
      'markdown_inline',
      'query',
      'vimdoc',
      'comment',
    },
    highlight = {
      enable = true,
      disable = function(_, buf)
        local max_filesize = 500 * 1024
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
        return false
      end,
    },
  })
end

function M.fzflua()
  local actions = require('fzf-lua.actions')
  require('fzf-lua').setup({
    winopts = {
      height = 0.60,
      width = 1,
      row = 1,
      col = 0,
      backdrop = 100,
      preview = {
        border = 'noborder',
        scrollbar = 'float',
      },
    },
    keymap = {
      builtin = {
        false,
        ['<F1>'] = 'toggle-help',
      },
      fzf = {
        false,
        ['ctrl-y'] = 'toggle-all',
      },
    },
    actions = {
      files = {
        false,
        ['enter'] = actions.file_edit,
        ['ctrl-s'] = actions.file_split,
        ['ctrl-v'] = actions.file_vsplit,
        ['ctrl-t'] = actions.file_tabedit,
        ['ctrl-q'] = actions.file_sel_to_ll,
      },
    },
    files = {
      file_icons = false,
      git_icons = false,
      color_icons = false,
    },
    buffers = {
      preview_opts = 'hidden',
    },
    git = {
      bcommits = {
        prompt = 'Logs:',
        actions = {
          ['ctrl-]'] = function(...)
            actions.git_buf_vsplit(...)
            vim.cmd('windo diffthis')
            local switch = vim.api.nvim_replace_termcodes('<C-w>h', true, false, true)
            vim.api.nvim_feedkeys(switch, 't', false)
          end,
        },
      },
    },
    lsp = {
      async_or_timeout = true,
      includeDeclaration = false,
      code_actions = {
        winopts = {
          preview = {
            layout = 'horizontal',
            horizontal = 'up:55%',
          },
        },
      },
      finder = {
        providers = {
          { 'references', prefix = require('fzf-lua').utils.ansi_codes.blue('ref ') },
          { 'definitions', prefix = require('fzf-lua').utils.ansi_codes.green('def ') },
          { 'implementations', prefix = require('fzf-lua').utils.ansi_codes.green('impl') },
        },
      },
    },
    registers = {
      preview_opts = 'hidden',
    },
  })
end

function M.surround()
  require('nvim-surround').setup()
end

function M.oil()
  function _G.OilBar()
    local dir = require('oil').get_current_dir()
    if dir then
      return vim.fn.fnamemodify(dir, ':~')
    else
      -- If there is no current directory (e.g. over ssh), just show the buffer name
      return vim.api.nvim_buf_get_name(0)
    end
  end
  require('oil').setup({
    delete_to_trash = true,
    watch_for_changes = true,
    columns = { '' },
    win_options = {
      number = false,
      relativenumber = false,
      winbar = '%{v:lua.OilBar()}',
    },
    keymaps = {
      ['<C-h>'] = false,
      ['<C-l>'] = false,
      ['<C-k>'] = false,
      ['<C-j>'] = false,
      ['<C-s>'] = false,
      ['gh'] = { '<cmd>edit $HOME<CR>', desc = 'Go to HOME directory' },
      ['<M-v>'] = {
        'actions.select',
        opts = { vertical = true },
        desc = 'Open the entry in a vertical split',
      },
      ['<M-s>'] = {
        'actions.select',
        opts = { horizontal = true },
        desc = 'Open the entry in a horizontal split',
      },
      ['gl'] = {
        desc = 'Toggle detail view',
        callback = function()
          local oil = require('oil')
          local config = require('oil.config')
          if #config.columns == 1 then
            oil.set_columns({ 'permissions', 'size', 'mtime' })
          else
            oil.set_columns({ '' })
          end
        end,
      },
    },
    view_options = {
      is_always_hidden = function(name, bufnr)
        return name == '..'
      end,
      show_hidden = true,
      highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
        if entry.type == 'link' and not entry.meta.link_stat and not is_link_target then
          return 'OilDelete'
        end
      end,
    },
    confirmation = {
      border = 'none',
    },
    float = {
      border = 'none',
    },
    progress = {
      border = 'none',
    },
    ssh = {
      border = 'none',
    },
    keymaps_help = {
      border = 'none',
    },
  })
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
      go = { 'gofmt' },
      python = { 'isort', 'black' },
      rust = { 'rustfmt' },
      sh = { 'shfmt' },
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
      -- Disable autoformat on certain filetypes
      local ignore_filetypes = { 'c', 'cpp' }
      if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
        return
      end
      -- Disable autoformat for files in a certain path
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      if bufname:match('/node_modules/') or bufname:match('neovim') then
        return
      end

      return { timeout_ms = 500, lsp_format = 'fallback', quiet = true }
    end,
  })
end

function M.colors()
  require('ccc').setup()
end

return M
