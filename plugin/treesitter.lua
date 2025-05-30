local parsers = {
  'c',
  'cpp',
  'lua',
  'rust',
  'python',
  'markdown',
  'markdown_inline',
  'query',
  'vimdoc',
}
require('nvim-treesitter').install(parsers)

vim.api.nvim_create_autocmd('FileType', {
  pattern = parsers,
  callback = function(args)
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

    local max_filesize = 500 * 1024
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    if ok and stats and stats.size > max_filesize then
      return
    end

    vim.treesitter.start()
    -- https://github.com/nvim-treesitter/nvim-treesitter/issues/6436
    if args.match == 'python' then
      vim.bo[args.buf].syntax = 'on'
    end
  end,
})
