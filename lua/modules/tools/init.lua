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
      sign = true,
      sign_priority = 40,
      virtual_text = true,
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
    symbol_in_winbar = {
      enable = true,
      show_file = true,
      folder_level = 1,
      dely = 300,
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
      signature = {
        enabled = true,
        auto_open = {
          enabled = true,
          trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
          luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
          throttle = 50, -- Debounce lsp signature help request by 50ms
        },
        view = nil, -- when nil, use defaults from documentation
        ---@type NoiceViewOptions
        opts = {}, -- merged with defaults from documentation
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
          vim.notify([[Press P or "*p to paste this emoji]] .. emoji.value)
        end,
      },
    },
  })
  require('telescope').load_extension('fzy_native')
  require('telescope').load_extension('emoji')
end

function M.surround()
  require('nvim-surround').setup({})
end

function M.flash()
  return {
    {
      's',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').jump()
      end,
      desc = 'Flash',
    },
  }
end

function M.dyninput()
  local ms = require('dyninput.lang.misc')
  local rs = require('dyninput.lang.rust')
  require('dyninput').setup({
    go = {
      [';'] = {
        { ' := ', ms.go_variable_define },
        { ': ', ms.go_struct_field },
      },
    },
    rust = {
      [';'] = {
        { '=> ', rs.fat_arrow },
      },
      ['-'] = {
        { ' -> ', rs.thin_arrow },
      },
    },
  })
end

function M.dbsession()
  require('dbsession').setup({
    auto_save_on_exit = false,
  })
end

function M.statuscol()
  local builtin = require('statuscol.builtin')
  require('statuscol').setup({
    relculright = true,
    segments = {
      { text = { '%s' }, click = 'v:lua.ScSa' },
      { text = { builtin.lnumfunc }, click = 'v:lua.ScLa' },
      { text = { ' ', builtin.foldfunc, ' ' }, click = 'v:lua.ScFa' },
    },
  })
end

function M.handler(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (' 󱦶 %d '):format(endLnum - lnum)
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
  table.insert(newVirtText, { suffix, 'MoreMsg' })
  return newVirtText
end

function M.ufo()
  require('ufo').setup({
    fold_virt_text_handler = M.handler,
    provider_selector = function()
      return { 'treesitter', 'indent' }
    end,
  })
end

function M.gitsigns()
  require('gitsigns').setup()
end

function M.formatter()
  local util = require('formatter.util')
  -- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
  require('formatter').setup({
    logging = true,
    log_level = vim.log.levels.WARN,
    filetype = {
      lua = {
        function()
          if util.get_current_buffer_file_name() == 'special.lua' then
            return nil
          end
          return {
            exe = 'stylua',
            args = {
              '--column-width 110',
              '--quote-style ' .. 'AutoPreferSingle',
              '--indent-type ' .. 'Spaces',
              '--indent-width ' .. '2',
              '-',
            },
            stdin = true,
          }
        end,
      },
      c = {
        function()
          return {
            exe = 'clang-format',
            args = {
              '-style="{'
                .. 'IndentWidth: '
                .. vim.api.nvim_buf_get_option(0, 'tabstop')
                .. ','
                .. 'AlwaysBreakTemplateDeclarations: true'
                .. ','
                .. 'ColumnLimit: 100'
                .. ','
                .. '}"',
              '-assume-filename',
              util.escape_path(util.get_current_buffer_file_name()),
            },
            stdin = true,
            try_node_modules = true,
          }
        end,
      },
      cpp = {
        function()
          return {
            exe = 'clang-format',
            args = {
              '-style="{'
                .. 'IndentWidth: '
                .. vim.api.nvim_buf_get_option(0, 'tabstop')
                .. ','
                .. 'AlwaysBreakTemplateDeclarations: true'
                .. ','
                .. 'ColumnLimit: 100'
                .. ','
                .. '}"',
              '-assume-filename',
              util.escape_path(util.get_current_buffer_file_name()),
            },
            stdin = true,
            try_node_modules = true,
          }
        end,
      },
      cmake = {
        require('formatter.filetypes.cmake').cmakeformat,
      },
      rust = {
        require('formatter.filetypes.rust').rustfmt,
      },
      go = {
        function()
          return {
            exe = 'golines',
            args = {
              '--max-len=110',
            },
            stdin = true,
          }
        end,
      },
      zig = {
        require('formatter.filetypes.zig').zigfmt,
      },
      python = {
        require('formatter.filetypes.python').black,
      },
      sh = {
        require('formatter.filetypes.sh').shfmt,
      },
      html = {
        require('formatter.filetypes.html').prettier,
      },
      css = {
        require('formatter.filetypes.css').prettier,
      },
      toml = {
        require('formatter.filetypes.toml').taplo,
      },
      -- i change the json filetype to jsonc to enable comment
      jsonc = {
        require('formatter.filetypes.json').jq,
      },
      javascript = {
        require('formatter.filetypes.javascript').prettier,
      },
      typescript = {
        require('formatter.filetypes.typescript').prettier,
      },
      markdown = {
        require('formatter.filetypes.markdown').prettier,
      },
      yaml = {
        require('formatter.filetypes.yaml').prettier,
      },
      ['*'] = {
        require('formatter.filetypes.any').remove_trailing_whitespace,
      },
    },
  })
end

function M.comment()
  require('Comment').setup()
end

return M
