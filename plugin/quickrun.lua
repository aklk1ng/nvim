vim.api.nvim_set_keymap("n", "<leader>r", ":call CompileRunGcc()<CR>", { noremap = true, silent = true })
vim.cmd([[
func! CompileRunGcc()
	exec "w"
	if &filetype == 'c'
		set splitbelow
		:sp
		:res -5
		term gcc % -o %< && time ./%<
	elseif &filetype == 'cpp'
		set splitbelow
		exec "!g++ -std=c++17 % -Wall -o %<"
		:sp
		:res -5
		:term ./%<
	elseif &filetype == 'sh'
		:!time bash %
	elseif &filetype == 'python'
		set splitbelow
		:sp
		:term python %
	elseif &filetype == 'html'
		silent! exec "!".g:mkdp_browser." % &"
	elseif &filetype == 'javascript'
		set splitbelow
		:sp
		:term export DEBUG="INFO,ERROR,WARNING"; node --trace-warnings .
	elseif &filetype == 'go'
		set splitbelow
		:sp
		:term go run %
	elseif &filetype == 'lua'
		set splitbelow
		:sp
		:term lua %
	elseif &filetype == 'rust'
		set splitbelow
		:sp
		:term cargo run %
	endif
endfunc
]])
