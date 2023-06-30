local M = {}

function M.lspsaga()
  local status, saga = pcall(require, 'lspsaga')
  if not status then
    vim.notify('lspsaga not found')
    return
  end

  saga.setup({
    preview = {
      lines_above = 0,
      lines_below = 20,
    },
    rename = {
      quit = '<C-c>',
      exec = '<CR>',
      mark = 'x',
      confirm = '<CR>',
      in_select = true,
      whole_project = true,
    },
    definition = {
      edit = '<C-c>o',
      vsplit = '<C-c>v',
      split = '<C-c>i',
      tabe = '<C-c>t',
      quit = 'q',
      close = '<Esc>',
    },
    lightbulb = {
      enable = false,
      enable_in_insert = false,
      sign = true,
      sign_priority = 40,
      virtual_text = true,
    },
    outline = {
      win_position = 'right',
      win_with = '',
      win_width = 30,
      custom_sort = nil,
      keys = {
        jump = 'o',
        expand_collaspe = 'u',
        quit = 'q',
      },
    },
    ui = {
      border = 'rounded',
    },
    diagnostic = {
      on_insert = true,
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
  require('telescope').load_extension('workspace')
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

function M.neotree()
  require('neo-tree').setup({
    window = { -- see https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup for
      position = 'left', -- left, right, top, bottom, float, current
      width = 30, -- applies to left and right positions
      height = 10, -- applies to top and bottom positions
      auto_expand_width = false, -- expand the window when file exceeds the window width. does not work with position = "float"
      same_level = false, -- Create and paste/move files/directories on the same level as the directory under cursor (as opposed to within the directory under cursor).
      insert_as = 'child', -- Affects how nodes get inserted into the tree during creation/pasting/moving of files if the node under the cursor is a directory:
      -- "child":   Insert nodes as children of the directory under cursor.
      -- "sibling": Insert nodes  as siblings of the directory under cursor.
      -- Mappings for tree window. See `:h neo-tree-mappings` for a list of built-in commands.
      -- You can also create your own commands by providing a function instead of a string.
      mapping_options = {
        noremap = true,
        nowait = true,
      },
      mappings = {
        ['<space>'] = {
          'toggle_node',
          nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
        },
        ['<2-LeftMouse>'] = 'open',
        ['<cr>'] = 'open',
        ['<esc>'] = 'revert_preview',
        ['P'] = { 'toggle_preview', config = { use_float = true } },
        ['l'] = 'focus_preview',
        ['S'] = 'open_split',
        -- ["S"] = "split_with_window_picker",
        ['s'] = 'open_vsplit',
        -- ["s"] = "vsplit_with_window_picker",
        ['t'] = 'open_tabnew',
        -- ["<cr>"] = "open_drop",
        -- ["t"] = "open_tab_drop",
        ['C'] = 'close_node',
        ['z'] = 'close_all_nodes',
        --["Z"] = "expand_all_nodes",
        ['R'] = 'refresh',
        ['a'] = {
          'add',
          -- some commands may take optional config options, see `:h neo-tree-mappings` for details
          config = {
            show_path = 'none', -- "none", "relative", "absolute"
          },
        },
        ['A'] = 'add_directory', -- also accepts the config.show_path and config.insert_as options.
        ['d'] = 'delete',
        ['r'] = 'rename',
        ['y'] = 'copy_to_clipboard',
        ['x'] = 'cut_to_clipboard',
        ['p'] = 'paste_from_clipboard',
        ['c'] = 'copy', -- takes text input for destination, also accepts the config.show_path and config.insert_as options
        ['m'] = 'move', -- takes text input for destination, also accepts the config.show_path and config.insert_as options
        ['e'] = 'toggle_auto_expand_width',
        ['q'] = 'close_window',
        ['?'] = 'show_help',
        ['<'] = 'prev_source',
        ['>'] = 'next_source',
      },
    },
    filesystem = {
      window = {
        mappings = {
          ['H'] = 'toggle_hidden',
          ['/'] = 'fuzzy_finder',
          ['D'] = 'fuzzy_finder_directory',
          --["/"] = "filter_as_you_type", -- this was the default until v1.28
          ['#'] = 'fuzzy_sorter', -- fuzzy sorting using the fzy algorithm
          -- ["D"] = "fuzzy_sorter_directory",
          ['f'] = 'filter_on_submit',
          ['<C-x>'] = 'clear_filter',
          ['<bs>'] = 'navigate_up',
          ['.'] = 'set_root',
          ['[g'] = 'prev_git_modified',
          [']g'] = 'next_git_modified',
        },
      },
    },
    git_status = {
      window = {
        mappings = {
          ['A'] = 'git_add_all',
          ['gu'] = 'git_unstage_file',
          ['ga'] = 'git_add_file',
          ['gr'] = 'git_revert_file',
          ['gc'] = 'git_commit',
          ['gp'] = 'git_push',
          ['gg'] = 'git_commit_and_push',
        },
      },
    },
  })
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

function M.indentmini()
  require('indentmini').setup({
    char = '|',
    exclude = {
      'erlang',
      'markdown',
    },
  })
end

return M
