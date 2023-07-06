local aklk1ng = vim.api.nvim_create_augroup('aklk1ngGroup', {})
local api = vim.api

api.nvim_create_autocmd('FileType', {
  group = aklk1ng,
  pattern = '*',
  callback = function()
    vim.cmd('syntax off')
  end,
})

api.nvim_create_autocmd('FileType', {
  group = aklk1ng,
  pattern = { 'help', 'man', 'checkhealth', 'dashboard' },
  callback = function(event)
    vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = event.buf, silent = true, nowait = true })
  end,
})

api.nvim_create_autocmd('TextYankPost', {
  group = aklk1ng,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 100 })
  end,
})

api.nvim_create_autocmd('LspAttach', {
  group = aklk1ng,
  pattern = '*.c,*.cpp,*.lua,*.rs,*.go,*.zig,*.ts,*.js',
  callback = function()
    vim.lsp.inlay_hint(0, true)
  end,
})

api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = aklk1ng,
  pattern = '*',
  callback = function()
    -- Formatter
    local current_dir = vim.fn.expand('%:p:h')
    if current_dir:find('neovim', 1, true) or current_dir:find('dwm', 1, true) then
      vim.w.format = false
    else
      vim.w.format = true
    end
  end,
})

api.nvim_create_autocmd('BufWritePost', {
  group = aklk1ng,
  pattern = '*',
  callback = function()
    if vim.w.format then
      vim.cmd('FormatWrite')
    else
      vim.cmd([[%s/\s\+$//e]])
    end
  end,
})

api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = aklk1ng,
  pattern = '*',
  callback = function()
    local url_match =
      '\\v\\c%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)%([&:#*@~%_\\-=?!+;/0-9a-z]+%(%([.;/?]|[.][.]+)[&:#*@~%_\\-=?!+/0-9a-z]+|:\\d+|,%(%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)@![0-9a-z]+))*|\\([&:#*@~%_\\-=?!+;/.0-9a-z]*\\)|\\[[&:#*@~%_\\-=?!+;/.0-9a-z]*\\]|\\{%([&:#*@~%_\\-=?!+;/.0-9a-z]*|\\{[&:#*@~%_\\-=?!+;/.0-9a-z]*})\\})+'

    for _, match in ipairs(vim.fn.getmatches()) do
      if match.group == 'HighlightURL' then
        vim.fn.matchdelete(match.id)
      end
    end
    vim.fn.matchadd('HighlightURL', url_match, 15)
  end,
})

if vim.fn.executable('fcitx5-remote') == 1 then
  api.nvim_create_autocmd('InsertLeavePre', {
    group = aklk1ng,
    pattern = '*',
    callback = function()
      os.execute('fcitx5-remote -c')
    end,
  })
end

api.nvim_create_autocmd('BufReadPost', {
  group = aklk1ng,
  pattern = '*',
  callback = function()
    -- auto place to last edit
    vim.cmd([[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g'\"" | endif]])
  end,
})
