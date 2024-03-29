local M = {}

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
      'go',
      'gomod',
      'markdown',
      'markdown_inline',
      'make',
      'vimdoc',
      'query',
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

  -- set indent for jsx tsx
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'javascriptreact', 'typescriptreact' },
    callback = function(opt)
      vim.bo[opt.buf].indentexpr = 'nvim_treesitter#indent()'
    end,
  })

  local swap = require('utils.api.swap')
  local select = require('utils.api.select')
  local map = require('keymap')
  map.n('ts', swap.swap)

  map.v({
    ['if'] = function()
      select.select(false, 'function')
    end,
    ['af'] = function()
      select.select(true, 'function')
    end,
    ['ic'] = function()
      select.select(false, 'class')
    end,
    ['ac'] = function()
      select.select(true, 'class')
    end,
    ['il'] = function()
      select.select(false, 'loop')
    end,
    ['al'] = function()
      select.select(true, 'loop')
    end,
  })
end

function M.lspsaga()
  local saga = require('lspsaga')

  saga.setup({
    definition = {
      width = 0.7,
      height = 0.6,
      keys = {
        edit = '<C-c>o',
        vsplit = '<C-c>v',
        split = '<C-c>s',
        tabe = '<C-c>t',
        quit = 'q',
        close = '<C-c>c',
      },
    },
    lightbulb = {
      enable = false,
    },
    implement = {
      enable = true,
      sign = false,
    },
    outline = {
      win_position = 'right',
      win_width = 40,
      close_after_jump = false,
      layout = 'normal',
      max_height = 0.7,
      left_width = 0.4,
      keys = {
        toggle_or_jump = 'e',
        jump = 'o',
      },
    },
  })
end

function M.noice()
  require('noice').setup({
    cmdline = {
      enabled = false,
    },
    messages = {
      enabled = false,
    },
    lsp = {
      progress = {
        enabled = false,
      },
      override = {
        -- override the default lsp markdown formatter with Noice
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        -- override the lsp markdown formatter with Noice
        ['vim.lsp.util.stylize_markdown'] = true,
        -- override cmp documentation with Noice (needs the other options to work)
        ['cmp.entry.get_documentation'] = true,
      },
    },
    popupmenu = {
      enabled = false,
    },
  })
end

function M.telescope()
  require('telescope').setup({
    defaults = {
      layout_config = {
        horizontal = {
          prompt_position = 'top',
          preview_width = 0.55,
          results_width = 0.8,
        },
        vertical = {
          mirror = false,
        },
        preview_cutoff = 120,
        height = 0.95,
        width = 0.95,
      },
      preview = {
        timeout = 500,
      },
      sorting_strategy = 'ascending',
    },
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      },
    },
  })
  require('telescope').load_extension('fzy_native')
end

function M.surround()
  require('nvim-surround').setup()
end

function M.oil()
  require('oil').setup({
    -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
    delete_to_trash = false,
    -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
    skip_confirm_for_simple_edits = false,
    -- Set to true to watch the filesystem for changes and reload oil
    experimental_watch_for_changes = true,
    keymaps = {
      ['g?'] = 'actions.show_help',
      ['<CR>'] = 'actions.select',
      ['<C-s>'] = 'actions.select_vsplit',
      ['<C-h>'] = 'actions.select_split',
      ['<C-t>'] = 'actions.select_tab',
      ['<C-p>'] = 'actions.preview',
      ['<C-c>'] = 'actions.close',
      ['<C-u>'] = 'actions.refresh',
      ['-'] = 'actions.parent',
      ['_'] = 'actions.open_cwd',
      ['`'] = 'actions.cd',
      ['~'] = 'actions.tcd',
      ['gs'] = 'actions.change_sort',
      ['gx'] = 'actions.open_external',
      ['g.'] = 'actions.toggle_hidden',
      ['g\\'] = 'actions.toggle_trash',
    },
    use_default_keymaps = false,
  })
end

function M.gitsigns()
  require('gitsigns').setup({
    attach_to_untracked = true,
  })
end

function M.guard()
  local ft = require('guard.filetype')
  local clang_format = {
    cmd = 'clang-format',
    args = {
      '--style={'
        .. 'IndentWidth: 2,'
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
  }
  ft('c'):fmt(clang_format)
  ft('cpp'):fmt(clang_format)
  ft('go'):fmt({
    cmd = 'golines',
    args = {
      '--max-len=100',
    },
    stdin = true,
  })
  ft('lua'):fmt({
    cmd = 'stylua',
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
  })
  ft('rust'):fmt('rustfmt')
  ft('python'):fmt('ruff'):lint('ruff')
  ft('zig'):fmt({
    cmd = 'zig',
    args = { 'fmt', '--stdin' },
    stdin = true,
  })
  ft('toml'):fmt('taplo')
  ft('sh'):fmt({
    cmd = 'shfmt',
    args = { '-i', 4 },
    stdin = true,
  })
  ft('cmake'):fmt({
    cmd = 'cmake-format',
    args = { '-' },
    stdin = true,
  })
  ft('json'):fmt({
    cmd = 'jq',
    args = { '.' },
    stdin = true,
  })
  ft('fish'):fmt({
    cmd = 'fish_indent',
    stdin = true,
  })

  for _, item in ipairs({
    'typescript',
    'javascript',
    'typescriptreact',
    'javascriptreact',
    'markdown',
    'yaml',
    'html',
    'css',
  }) do
    ft(item):fmt('prettier')
  end
  -- call setup LAST
  require('guard').setup({
    -- the only option for the setup function
    fmt_on_save = false,
  })
end

function M.hipatterns()
  local hipatterns = require('mini.hipatterns')
  hipatterns.setup({
    highlighters = {
      -- Highlight hex color strings (`#rrggbb`) using that color
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end

function M.indentmini()
  require('indentmini').setup({
    char = '▏',
    exclude = {
      'erlang',
      'markdown',
      'help',
    },
  })
end

function M.scriptease()
  vim.api.nvim_create_user_command('Mes', function()
    vim.api.nvim_command('Message')
  end, {})
end

return M
