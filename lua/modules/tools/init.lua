local M = {}

function M.lspsaga()
  local saga = require('lspsaga')

  saga.setup({
    rename = {
      quit = '<Esc>',
      mark = 'x',
      exec = '<CR>',
      in_select = true,
    },
    definition = {
      width = 0.7,
      height = 0.6,
      keys = {
        edit = '<C-c>o',
        vsplit = '<C-c>v',
        split = '<C-c>i',
        tabe = '<C-c>t',
        quit = 'q',
        close = '<C-c>k',
      },
    },
    finder = {
      max_height = 0.6,
      keys = {
        vsplit = 'v',
      },
    },
    lightbulb = {
      enable = false,
    },
    outline = {
      win_position = 'right',
      win_width = 30,
      close_after_jump = false,
      layout = 'float',
      max_height = 0.7,
      left_width = 0.4,
      keys = {
        toggle_or_jump = 'e',
        jump = 'o',
      },
    },
    ui = {
      border = 'rounded',
    },
  })
end

function M.noice()
  local status, noice = pcall(require, 'noice')
  if not status then
    vim.notify('noice not found')
    return
  end
  noice.setup({
    cmdline = {
      enabled = true, -- enables the Noice cmdline UI
      view = 'cmdline', -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
      opts = {}, -- global options for the cmdline. See section on views
    },
    messages = {
      enabled = false, -- enables the Noice messages UI
    },
    lsp = {
      progress = {
        enabled = false,
      },
    },
  })
end

function M.telescope()
  require('telescope').setup({
    defaults = {
      vimgrep_arguments = {
        'rg',
        '-L',
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case',
      },
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
      sorting_strategy = 'ascending',
      file_previewer = require('telescope.previewers').vim_buffer_cat.new,
      grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
      qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
    },
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      },
      emoji = {
        action = function(emoji)
          vim.fn.setreg('*', emoji.value)
          vim.notify([[Press "*p to paste this emoji]] .. emoji.value)
        end,
      },
    },
  })
  require('telescope').load_extension('fzy_native')
  require('telescope').load_extension('emoji')
end

function M.surround()
  require('nvim-surround').setup()
end

function M.hop()
  require('hop').setup()
end

function M.dbsession()
  require('dbsession').setup({
    auto_save_on_exit = false,
  })
end

function M.gitsigns()
  require('gitsigns').setup({})
end

function M.guard()
  local ft = require('guard.filetype')
  local clang_format = {
    cmd = 'clang-format',
    args = {
      '--style={IndentWidth: 2, AlwaysBreakTemplateDeclarations: true, ColumnLimit: 100}',
    },
    stdin = true,
  }
  ft('c'):fmt(clang_format)
  ft('cpp'):fmt(clang_format)
  ft('go'):fmt({
    cmd = 'golines',
    args = {
      '--max-len=110',
    },
    stdin = true,
  })
  ft('lua'):fmt({
    cmd = 'stylua',
    args = {
      '--column-width',
      '110',
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
  ft('rust'):fmt({
    cmd = 'rustfmt',
    args = { '--edition', '2021' },
    stdin = true,
  })
  ft('python'):fmt({
    cmd = 'black',
    args = {
      '-',
    },
  })
  ft('zig'):fmt({
    cmd = 'zig',
    args = { 'fmt', '--stdin' },
    stdin = true,
  })
  ft('toml'):fmt({
    cmd = 'taplo',
    args = { 'fmt', '-' },
    stdin = true,
  })
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
    fmt_on_save = true,
  })
end

function M.comment()
  require('Comment').setup()
end

function M.competitest()
  require('competitest').setup()
end

return M
