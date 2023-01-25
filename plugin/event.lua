local aklk1ng = vim.api.nvim_create_augroup('aklk1ngGroup', {}) -- A global group for all your config autocommands

vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = "SessionSavePost",
    group = aklk1ng,
    callback = function()
        vim.notify("Session is saved!")
    end,
})
vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = "SessionLoadPost",
    group = aklk1ng,
    callback = function()
        vim.notify("Session is loaded!")
    end,
})

vim.api.nvim_create_autocmd('Filetype', {
    group = aklk1ng,
    pattern = '*.c,*.cpp,*.lua,*.go,*.rs,*.py,*.ts,*.tsx,*.html,*json,*.sh,*markdown',
    callback = function()
        vim.cmd('syntax off')
    end,
})
