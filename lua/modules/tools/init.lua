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

function M.tabs()
  require('telescope').load_extension('telescope-tabs')
  require('telescope-tabs').setup({
    entry_formatter = function(tab_id, _, _, file_paths, is_current)
      local entry_string = table.concat(
        vim.tbl_map(function(v)
          return v:gsub(vim.fn.getcwd() .. '/', './')
        end, file_paths),
        ', '
      )
      return string.format('%d: %s%s', tab_id, entry_string, is_current and ' <' or '')
    end,
  })
end

function M.surround()
  require('nvim-surround').setup()
end

function M.files()
  require('mini.files').setup()

  local map_split = function(buf_id, lhs, direction)
    local rhs = function()
      -- Make new window and set it as target
      local new_target_window
      vim.api.nvim_win_call(MiniFiles.get_target_window(), function()
        vim.cmd(direction .. ' split')
        new_target_window = vim.api.nvim_get_current_win()
      end)

      MiniFiles.set_target_window(new_target_window)
    end

    -- Adding `desc` will result into `show_help` entries
    local desc = 'Split ' .. direction
    vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
  end

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
      local buf_id = args.data.buf_id
      -- Tweak keys to your liking
      map_split(buf_id, '<C-s>', 'belowright horizontal')
      map_split(buf_id, '<C-v>', 'belowright vertical')
    end,
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
  ft('go'):fmt('lsp'):append('golines')
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

function M.colorizer()
  require('colorizer').setup()
end

return M
