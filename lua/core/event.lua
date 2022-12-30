local vim = vim
local autocmd = {}

function autocmd.nvim_create_augroups(definitions)
	for group_name, definition in pairs(definitions) do
		vim.api.nvim_command("augroup " .. group_name)
		vim.api.nvim_command("autocmd!")
		for _, def in ipairs(definition) do
			local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
			vim.api.nvim_command(command)
		end
		vim.api.nvim_command("augroup END")
	end
end

function autocmd.load_autocmds()
	local definitions = {
		packer = {},
		bufs = {
			-- auto place to last edit
			{
				"BufReadPost",
				"*",
				[[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g'\"" | endif]],
			},
			-- Auto toggle fcitx5
			-- {"InsertLeave", "* :silent", "!fcitx5-remote -c"},
			-- {"BufCreate", "*", ":silent !fcitx5-remote -c"},
			-- {"BufEnter", "*", ":silent !fcitx5-remote -c "},
			-- {"BufLeave", "*", ":silent !fcitx5-remote -c "}
		},
		yank = {
			{
				"TextYankPost",
				"*",
				[[silent! lua vim.highlight.on_yank({higroup="IncSearch"})]],
			},
		},
		inputer = {
			{"InsertLeave", "*", [[call system("fcitx5-remote -c")]]},
			{"BufCreate", "*" , [[call system("fcitx5-remote -c")]]},
			{"BufEnter", "*" , [[call system("fcitx5-remote -c")]]},
			{"BufLeave", "*" , [[call system("fcitx5-remote -c")]]}
	   },
	}

	autocmd.nvim_create_augroups(definitions)
end

autocmd.load_autocmds()
