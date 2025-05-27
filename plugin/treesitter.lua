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
