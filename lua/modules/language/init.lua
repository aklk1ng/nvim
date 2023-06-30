local M = {}

function M.markdown_preview()
  local helper = require('core.helper')
  vim.g.mkdp_page_title = '${name}'
  vim.g.mkdp_preview_options = { hide_yaml_meta = 1, disable_filename = 1 }
  vim.g.mkdp_browser = 'surf'
  vim.g.mkdp_markdown_css = helper.get_config_path() .. '/lua/utils/markdown.css'
end

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
      'json5',
      'jsonc',
      'tsx',
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
      'gitignore',
      'gitcommit',
      'gitattributes',
      'git_config',
      'git_rebase',
    },
    sync_install = true,
    highlight = {
      enable = true,
      disable = function(_, buf)
        local max_filesize = 200 * 1024 -- 200 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
        return false
      end,
    },
    rainbow = {
      enable = true,
      hlgroups = {
        'RainBow1',
        'RainBow2',
        'RainBow3',
        'RainBow4',
        'RainBow5',
        'RainBow6',
        'RainBow7',
      },
    },
    autopairs = { enable = true },
    textobjects = {
      select = {
        enable = true,
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = {
            query = '@class.inner',
            desc = 'Select inner part of a class region',
          },
          ['as'] = { query = '@scope', query_group = 'locals', desc = 'Select language scope' },
        },
        selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          ['@function.outer'] = 'V', -- linewise
          ['@class.outer'] = '<c-v>', -- blockwise
        },
        include_surrounding_whitespace = true,
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
