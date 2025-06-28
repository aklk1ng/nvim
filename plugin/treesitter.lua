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
require('nvim-treesitter-textobjects').setup({
  select = {
    -- Automatically jump forward to textobj, similar to targets.vim
    lookahead = false,
    selection_modes = {
      ['@parameter.outer'] = 'v', -- charwise
      ['@function.outer'] = 'V', -- linewise
      ['@class.outer'] = '<c-v>', -- blockwise
    },
  },
  move = {
    -- whether to set jumps in the jumplist
    set_jumps = true,
  },
})

vim.keymap.set({ 'x', 'o' }, 'af', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
end)
vim.keymap.set({ 'x', 'o' }, 'if', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
end)
vim.keymap.set({ 'x', 'o' }, 'ac', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects')
end)
vim.keymap.set({ 'x', 'o' }, 'ic', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
  require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
  require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
  require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
  require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, ']o', function()
  require('nvim-treesitter-textobjects.move').goto_next_start('@loop.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, '[o', function()
  require('nvim-treesitter-textobjects.move').goto_previous_start('@loop.outer', 'textobjects')
end)

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
