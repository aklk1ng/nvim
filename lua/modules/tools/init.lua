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
      'diff',
      'go',
      'gomod',
      'markdown',
      'markdown_inline',
      'make',
      'vimdoc',
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
end

function M.lspsaga()
  local saga = require('lspsaga')

  saga.setup({
    definition = {
      width = 0.7,
      height = 0.6,
      keys = {
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
      selection_caret = ' ',
      layout_config = {
        horizontal = {
          prompt_position = 'top',
          preview_width = 0.55,
          results_width = 0.8,
        },
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

function M.ufo()
  local handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = (' 󰁂 %d '):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
      local chunkText = chunk[1]
      local chunkWidth = vim.fn.strdisplaywidth(chunkText)
      if targetWidth > curWidth + chunkWidth then
        table.insert(newVirtText, chunk)
      else
        chunkText = truncate(chunkText, targetWidth - curWidth)
        local hlGroup = chunk[2]
        table.insert(newVirtText, { chunkText, hlGroup })
        chunkWidth = vim.fn.strdisplaywidth(chunkText)
        -- str width returned from truncate() may less than 2nd argument, need padding
        if curWidth + chunkWidth < targetWidth then
          suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
        end
        break
      end
      curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, { suffix, 'Function' })
    return newVirtText
  end
  require('ufo').setup({
    fold_virt_text_handler = handler,
    provider_selector = function(bufnr, filetype, buftype)
      return { 'treesitter', 'indent' }
    end,
  })
end

function M.statuscol()
  local builtin = require('statuscol.builtin')
  require('statuscol').setup({
    bt_ignore = { 'terminal', 'nofile' },
    relculright = true,
    segments = {
      { text = { builtin.lnumfunc } },
      {
        sign = {
          name = { '.*' },
          namespace = { '.*' },
          maxwidth = 1,
          colwidth = 1,
        },
      },
      { text = { builtin.foldfunc, ' ' }, click = 'v:lua.ScFa' },
    },
  })
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

function M.move()
  require('mini.move').setup({
    mappings = {
      -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
      left = '<M-h>',
      right = '<M-l>',
      down = '<M-j>',
      up = '<M-k>',

      -- Move current line in Normal mode
      line_left = '',
      line_right = '',
      line_down = '',
      line_up = '',
    },
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
    ignore_patterns = { 'neovim', 'vim' },
  }
  ft('c,cpp'):fmt(clang_format)
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
    ignore_patterns = '%w_spec%.lua',
  })
  ft('zig'):fmt('zigfmt')
  ft('rust'):fmt('rustfmt')
  ft('python'):fmt('ruff'):lint('ruff')
  ft('toml'):fmt('taplo')
  ft('sh'):fmt({
    cmd = 'shfmt',
    args = { '-i', 4 },
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
