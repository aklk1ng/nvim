local map = vim.api.nvim_set_keymap
local opt = { noremap = true, silent = true }

---------------------------- map('mode','old keymap','new keymap',opt)
map("n", "Q", ":q<CR>", opt)

---------------------------- change letter case
map("n", "..", "~", opt)
---------------------------- find pair
map("n", ",.", "%", opt)
map("v", ",.", "%", opt)

---------------------------- open the nvim plugins file anytime
map("n", "<leader>e", ":e ~/.config/nvim/lua/core/plugins.lua<CR>", opt)
---------------------------- cursor movement
map("n", "<C-i>", "<Home>", opt)
map("n", "<C-p>", "<End>", opt)
map("n", "<S-y>", "y$", opt)
map("n", "<S-c>", "c$", opt)
map("n", "<S-d>", "d$", opt)
map("n", "<S-j>", "5j", opt)
map("v", "<S-j>", "5j", opt)
map("n", "<S-k>", "5k", opt)
map("v", "<S-k>", "5k", opt)
map("n", "<", "<<", opt)
map("n", ">", ">>", opt)
map("v", "<", "<<", opt)
map("v", ">", ">>", opt)

---------------------------- window touch and movement(now have some problems)
map("n", "te", ":tabedit<CR>", opt)
map("n", "<leader>s", ":split<CR>", opt)
map("n", "<leader>v", ":vsplit<CR> ", opt)
map("n", ";", "<C-w>w<CR>", opt)
map("n", "<leader>h", "<C-w>h<CR>", opt)
map("n", "<leader>j", "<C-w>j<CR>", opt)
map("n", "<leader>k", "<C-w>k<CR>", opt)
map("n", "<leader>l", "<C-w>l<CR>", opt)
---------------------------- resize split windows
map("n", "<leader><leader>h", ":vertical resize+5<CR>", opt)
map("n", "<leader><leader>l", ":vertical resize-5<CR> ", opt)
map("n", "<leader><leader>j", ":resize-5<CR> ", opt)
map("n", "<leader><leader>k", ":resize+5<CR> ", opt)

---------------------------- plugin manager
map("n", "<leader><leader>i", ":Lazy<CR>", opt)

---------------------------- vim-dadbod-ui
map("n", "<leader><leader>d", ":DBUI<CR>", opt)

---------------------------- nvim-tree
map('n', '<leader>t', ':NvimTreeToggle<CR>', opt)
map('n', 'tf', ':NvimTreeFocus<CR>', opt)

---------------------------- vim-cmake
map('n', '<leader>cg', ':CMakeGenerate<CR>', opt)
map('n', '<leader>cb', ':CMakeBuild<CR>', opt)

---------------------------- vim-floaterm
map('n', 'fn', ':FloatermNew<CR>', opt)

---------------------------- gitsigns
map('n', ';d', ':Gitsigns diffthis<CR>', opt)
map('n', '<leader><leader>p', ':Gitsigns preview_hunk<CR>', opt)
map('n', ';n', ':Gitsigns next_hunk<CR>', opt)
map('n', ';p', ':Gitsigns prev_hunk<CR>', opt)

---------------------------- bufferline
map("n", "<leader>p", ":BufferLineCyclePrev<CR>", opt)
map("n", "<leader>n", ":BufferLineCycleNext<CR>", opt)
map("n", "<leader>d", ":bdelete<CR>", opt)

---------------------------- Html
map("n", ",g", ":! google-chrome-stable % &<CR>", opt)
map("n", ",s", ":! surf % &<CR>", opt)

---------------------------- Markdown
map("n", "<leader>m", ":MarkdownPreview<CR>", opt)
map("n", "<leader>tm", ":TableModeToggle<CR>", opt)
---------------------------- markdown-toc
map("n", "tg", ":GenTocGFM<CR>", opt)
map("n", "tr", ":GenTocRedcarpet<CR>", opt)

---------------------------- nvim-playground
map("n", ";h", ":TSHighlightCapturesUnderCursor<CR>", opt)

---------------------------- ranger
vim.cmd([[
    let g:ranger_map_keys = 0
]])
map("n", "ra", ":Ranger<CR>", opt)

---------------------------- neovim-session-manager
map("n", ";s", ":SessionManager save_current_session<CR>", opt)
map("n", ";l", ":SessionManager load_session<CR>", opt)
map("n", ";ll", ":SessionManager load_last_session<CR>", opt)

---------------------------- todo-comments.nvim
map("n", "tl", ":TodoLocList<CR>", opt)

---------------------------- neogen
map("n", "gn", ":Neogen<CR>", opt)

---------------------------- FzfLua
map("n", "ff", ":FzfLua files<CR>", opt)
map("n", "fb", ":FzfLua buffers<CR>", opt)
map("n", "fc", ":FzfLua command_history<CR>", opt)
map("n", "fo", ":FzfLua oldfiles<CR>", opt)
map("n", "fs", ":FzfLua lsp_document_symbols<CR>", opt)
map("n", "fS", ":FzfLua lsp_workspace_symbols<CR>", opt)
map("n", "fa", ":FzfLua lsp_code_actions<CR>", opt) -- find useable code actions
map("n", "fd", ":FzfLua diagnostics_document<CR>", opt)
map("n", "fD", ":FzfLua diagnostics_workspace<CR>", opt)
map("n", "fk", ":FzfLua keymaps<CR>", opt)
map("n", "fw", ":FzfLua live_grep<CR>", opt) -- find the word in current workspace
map("n", "fm", ":FzfLua marks<CR>", opt) -- find marks in current workspace
---------------------------- colorizer
map("n", "<leader>co", ":ColorizerToggle<CR>", opt)

---------------------------- alternate
map("n", "ta", ":ToggleAlternate<CR>", opt)

---------------------------- lazygit
map("n", "<leader>g", ":tabe<CR>:-tabmove<CR>:terminal lazygit<CR>", opt)
