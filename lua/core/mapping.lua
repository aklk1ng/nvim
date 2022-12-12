local map = vim.api.nvim_set_keymap
local opt = { noremap = true, silent = true }

---------------------------- map('model','old keymap','new keymap',opt)
map("n", "W", ":write<CR>", opt)
map("n", "Q", ":q<CR>", opt)


---------------------------- change letter case
map("n", "..", "~", opt)
---------------------------- find pair
map("n", ",.", "%", opt)
map("v", ",.", "%", opt)

---------------------------- open the nvim config file anytime
map("n", "<leader>e", ":e ~/.config/nvim/lua/core/pack.lua<CR>", opt)
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
map("n", ";", "<C-w>w", opt)
map("n", "te", ":tabedit<CR>", opt)
map("n", "ss", ":split<CR>", opt)
map("n", "sv", ":vsplit<CR> ", opt)
map("n", "sh", "<C-w>h<CR>", opt)
map("n", "sj", "<C-w>j<CR>", opt)
map("n", "sk", "<C-w>k<CR>", opt)
map("n", "sl", "<C-w>l<CR>", opt)
---------------------------- resize split windows
map("n", "<leader>h", ":vertical resize+5<CR>", opt)
map("n", "<leader>l", ":vertical resize-5<CR> ", opt)
map("n", "<leader>j", ":resize-5<CR> ", opt)
map("n", "<leader>k", ":resize+5<CR> ", opt)
---------------------------- packer
map("n", "<leader><leader>i", ":PackerInstall<CR>", opt)
map("n", "<leader><leader>d", ":PackerClean<CR>", opt)
map("n", "<leader><leader>s", ":PackerSync<CR>", opt)
map("n", "<leader><leader>c", ":PackerCompile<CR>", opt)

---------------------------- nvim-tree
map('n', '<leader>t', ':NvimTreeToggle<CR>', opt)
map('n', 'tf', ':NvimTreeFocus<CR>', opt)

---------------------------- bufferline
map("n", "<leader>p", ":BufferLineCyclePrev<CR>", opt)
map("n", "<leader>n", ":BufferLineCycleNext<CR>", opt)
map("n", "<leader>d", ":bdelete<CR>", opt)

---------------------------- markdown
map("n", "<leader>m", ":MarkdownPreview<CR>", opt)
map("n", "<leader>tm", ":TableModeToggle<CR>", opt)
---------------------------- markdown-toc
map("n", "tg", ":GenTocGFM<CR>", opt)
map("n", "tr", ":GenTocRedcarpet<CR>", opt)

---------------------------- ranger
vim.cmd([[
    let g:ranger_map_keys = 0
    let g:NERDTreeHijackNetrw = 0
]])
map("n", "ra", ":Ranger<CR>", opt)

---------------------------- vim-bookmarks
map("n", "mm", ":BookmarkToggle<CR>", opt)
map("n", "mp", ":BookmarkPrev<CR>", opt)
map("n", "mn", ":BookmarkNext<CR>", opt)
map("n", "ma", ":BookmarkShowAll<CR>", opt)
map("n", "mc", ":BookmarkClear<CR>", opt)
map("n", "mC", ":BookmarkClearAll<CR>", opt)
map("n", "<leader>mn", ":BookmarkMoveDown<CR>", opt)
map("n", "<leader>mp", ":BookmarkMoveUp<CR>", opt)

---------------------------- FzfLua
map("n", "ff", ":FzfLua files<CR>", opt) -- find files at current folder
map("n", "fb", ":FzfLua buffers<CR>", opt) -- find buffers
map("n", "fc", ":FzfLua command_history<CR>", opt) -- find the history of command
map("n", "fo", ":FzfLua oldfiles<CR>", opt) -- find old files
map("n", "fs", ":FzfLua lsp_document_symbols<CR>", opt) -- find lsp symbols in the current buffer
map("n", "fS", ":FzfLua lsp_workspace_symbols<CR>", opt) -- find lsp symbols in all buffers
map("n", "fa", ":FzfLua lsp_code_actions<CR>", opt) -- find useable code actions
map("n", "fd", ":FzfLua diagnostics_document<CR>", opt) -- find diagnostics document in current buffer
map("n", "fD", ":FzfLua diagnostics_workspace<CR>", opt) -- find diagnostics document in all buffers
map("n", "fk", ":FzfLua keymaps<CR>", opt) -- find the keymaps
map("n", "fw", ":FzfLua live_grep<CR>", opt) -- find the word int current buffer

---------------------------- floaterm
map("n", "fn", ":FloatermNew<CR>", opt) --open a terminal window

---------------------------- colorizer
map("n", "<leader>co", ":ColorizerToggle<CR>", opt)

---------------------------- alternate
map("n", "ta", ":ToggleAlternate<CR>", opt)

---------------------------- lazygit
map("n", "<leader>lg", ":tabe<CR>:-tabmove<CR>:terminal lazygit<CR>", opt)
---------------------------- lazynpm
map("n", "<leader>lnm", ":tabe<CR>:-tabmove<CR>:terminal lazynpm<CR>", opt)
