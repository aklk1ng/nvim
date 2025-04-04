local M = {}

function M.blink()
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
  require('blink.cmp').setup({
    keymap = {
      ['<Tab>'] = { 'snippet_forward', 'fallback' },
      ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
      ['<C-n>'] = { 'show', 'select_next', 'fallback' },
      ['<C-p>'] = { 'show', 'select_prev', 'fallback' },
      ['<C-y>'] = { 'select_and_accept' },
      ['<C-e>'] = { 'cancel' },
      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
    },
    sources = {
      providers = {
        buffer = {
          opts = {
            get_bufnrs = function()
              return vim.tbl_filter(function(bufnr)
                return vim.bo[bufnr].buftype == ''
              end, vim.api.nvim_list_bufs())
            end,
          },
        },
      },
    },
    completion = {
      menu = {
        draw = {
          padding = 0,
          columns = {
            { 'kind_icon' },
            { 'label', 'label_description', gap = 1 },
          },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 50,
        update_delay_ms = 50,
      },
      ghost_text = { enabled = false },
    },
    signature = {
      enabled = true,
    },
    appearance = {
      kind_icons = cmp_kinds,
    },
    cmdline = { enabled = false },
  })
end

function M.treesitter()
  require('nvim-treesitter.configs').setup({
    ensure_installed = {
      'c',
      'cpp',
      'lua',
      'rust',
      'python',
      'markdown',
      'markdown_inline',
      'query',
      'vimdoc',
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
    {
      'max-perf',
      'ivy',
    },
    winopts = {
      height = 0.60,
      backdrop = 100,
      title_flags = false,
      preview = {
        horizontal = 'right:50%',
      },
    },
    keymap = {
      builtin = {
        false,
        ['<F1>'] = 'toggle-help',
      },
      fzf = {
        false,
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
    git = {
      bcommits = {
        prompt = 'Logs:',
        actions = {
          ['ctrl-]'] = function(...)
            local curwin = vim.api.nvim_get_current_win()
            actions.git_buf_vsplit(...)
            vim.cmd('windo diffthis')
            vim.api.nvim_set_current_win(curwin)
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
          { 'typedefs', prefix = require('fzf-lua').utils.ansi_codes.red('tdef') },
        },
      },
    },
  })
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
    },
    confirmation = {
      border = vim.o.winborder,
    },
    float = {
      border = vim.o.winborder,
    },
    progress = {
      border = vim.o.winborder,
    },
    ssh = {
      border = vim.o.winborder,
    },
    keymaps_help = {
      border = vim.o.winborder,
    },
  })
end

function M.gitsigns()
  require('gitsigns').setup()
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
      query = { 'format-queries' },
    },
    formatters = {
      clang_format = {
        command = 'clang-format',
        args = {
          '--style={'
            .. 'IndentWidth: '
            .. vim.api.nvim_get_option_value('shiftwidth', {})
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

function M.align()
  require('mini.align').setup({
    mappings = {
      start = 'gl',
      start_with_preview = 'gL',
    },
  })
end

return M
