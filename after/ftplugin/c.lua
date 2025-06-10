vim.opt_local.commentstring = '// %s'
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4

-- Jump to current function definition
vim.cmd([[map <C-p> :call getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW')) <CR> %%b]])
