require('conform').setup({
  formatters_by_ft = {
    c = { 'clang_format' },
    cpp = { 'clang_format' },
    lua = { 'stylua' },
    go = { 'gofmt' },
    python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },
    rust = { 'rustfmt' },
    sh = { 'shfmt' },
    toml = { 'taplo' },
    typescript = { 'prettier' },
    javascript = { 'prettier' },
    typescriptreact = { 'prettier' },
    javascriptreact = { 'prettier' },
    markdown = { 'prettier' },
    json = { 'prettier' },
    json5 = { 'prettier' },
    jsonc = { 'prettier' },
    yaml = { 'prettier' },
    html = { 'prettier' },
    css = { 'prettier' },
    fish = { 'fish_indent' },
    query = { 'format-queries' },
  },
  formatters = {
    clang_format = {
      command = 'clang-format',
      args = {
        '--style={'
          .. 'IndentWidth: '
          .. vim.api.nvim_get_option_value('shiftwidth', {})
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
    },
    stylua = {
      command = 'stylua',
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
    },
    shfmt = {
      cmd = 'shfmt',
      args = { '-i', 4 },
      stdin = true,
    },
  },
  format_on_save = function(bufnr)
    -- Disable autoformat on certain filetypes
    local ignore_filetypes = { 'c', 'cpp' }
    if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
      return
    end
    -- Disable autoformat for files in a certain path
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if bufname:match('/node_modules/') or bufname:match('neovim') then
      return
    end

    return { timeout_ms = 500, lsp_format = 'fallback', quiet = true }
  end,
})

vim.keymap.set({ 'n', 'x' }, 'gqq', function()
  require('conform').format({ async = true, lsp_fallback = 'fallback', quiet = true }, function(err)
    if not err then
      if vim.startswith(string.lower(vim.fn.mode()), 'v') then
        vim.api.nvim_feedkeys(vim.keycode('<Esc>'), 'n', true)
      end
    end
  end)
end)
