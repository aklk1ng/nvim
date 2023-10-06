local M = {}

function M.treesitter()
  require('nvim-treesitter.configs').setup({
    ensure_installed = {
      'c',
      'cpp',
      'dockerfile',
      'python',
      'lua',
      'bash',
      'zig',
      'yaml',
      'html',
      'css',
      'json',
      'jsonc',
      'rust',
      'go',
      'gomod',
      'gosum',
      'gowork',
      'markdown',
      'markdown_inline',
      'javascript',
      'typescript',
      'cmake',
      'make',
      'ninja',
      'sql',
      'toml',
      'vim',
      'query',
      'regex',
      'proto',
      'fish',
      'diff',
      'gitcommit',
      'gitattributes',
      'git_config',
      'git_rebase',
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
    textobjects = {
      select = {
        enable = true,
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        keymaps = {
          ['if'] = '@function.inner',
          ['af'] = '@function.outer',
          ['ic'] = '@class.inner',
          ['ac'] = '@class.outer',
          ['il'] = '@loop.inner',
          ['al'] = '@loop.outer',
        },
        selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          ['@function.outer'] = 'V', -- linewise
          ['@class.outer'] = '<c-v>', -- blockwise
        },
        include_surrounding_whitespace = true,
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
    playground = {
      enable = true,
      updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
      persist_queries = false, -- Whether the query persists across vim sessions
    },
  })

  local swap_ternary = require('utils.api.swap_ternary')
  vim.keymap.set('n', 'ts', swap_ternary.swap_ternary, { silent = true, noremap = true })
end

return M
