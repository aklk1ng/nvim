local map = vim.api.nvim_set_keymap
local opt = { noremap = true, silent = true }

---------------------------- map('mode','old keymap','new keymap',opt)
map("n", "Q", ":q<CR>", opt)

---------------------------- change letter case
map("n", "<C-,>", "~", opt)
---------------------------- find pair
map("n", ",.", "%", opt)
map("v", ",.", "%", opt)
map("n", [[\]], ":nohlsearch<CR>",opt)

---------------------------- open the nvim plugins file anytime
map("n", "<leader>e", ":e ~/.config/nvim/lua/core/plugins.lua<CR>", opt)
---------------------------- cursor movement
map("n", "<C-i>", "0", opt)
map("n", "<C-p>", "$", opt)
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
map('n', '<leader>cc', ':CMakeClose<CR>', opt)

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

---------------------------- html preview
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
map("n", "ra", ":Ranger<CR>", opt)

---------------------------- neovim-session-manager
map("n", ";s", ":SessionManager save_current_session<CR>", opt)
map("n", ";l", ":SessionManager load_session<CR>", opt)
map("n", ";ll", ":SessionManager load_last_session<CR>", opt)

---------------------------- todo-comments.nvim
map("n", "tl", ":TodoLocList<CR>", opt)

---------------------------- neogen
map("n", "gn", ":Neogen<CR>", opt)


---------------------------- Lspsaga
-- Diagnsotic jump can use `<c-o>` to jump back
map('n', '[n', '<Cmd>Lspsaga diagnostic_jump_next<CR>', opt)
map('n', ']n', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', opt)
-- Diagnostic jump with filter like Only jump to error
map("n", "[e", [[<Cmd>lua require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })<CR>]], opt)
map("n", "]e", [[<Cmd>lua require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })<CR>]], opt)
-- Show line diagnostics
map("n", "<leader>sd", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })
-- Show cursor diagnostic
map("n", "<leader>sd", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { silent = true })
-- Hover Doc
map('n', '<S-h>', '<Cmd>Lspsaga hover_doc<CR>', opt)
map('n', ',,', '<Cmd>Lspsaga hover_doc ++keep<CR>', opt)
-- Callhierarchy
map("n", "<Leader>ic", "<cmd>Lspsaga incoming_calls<CR>", opt)
map("n", "<Leader>oc", "<cmd>Lspsaga outgoing_calls<CR>", opt)
-- Lsp finder find the symbol definition implement reference
-- if there is no implement it will hide
-- when you use action in finder like open vsplit then you can
-- use <C-t> to jump back
map('n', 'gh', '<Cmd>Lspsaga lsp_finder<CR>', opt)
-- goto_definition
map('n', 'gd', '<Cmd>Lspsaga goto_definition<CR>', opt)
-- Code action
map("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opt)
map("v", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opt)
-- Peek Definition
-- you can edit the definition file in this flaotwindow
-- also support open/vsplit/etc operation check definition_action_keys
-- support tagstack C-t jump back
map('n', 'gp', '<Cmd>Lspsaga peek_definition<CR>', opt)
-- Rename
map('n', '<leader>rn', '<Cmd>Lspsaga rename<CR>', opt)
-- outline / show symbols in some files when the lsp is supported
map("n","<leader>o", "<cmd>Lspsaga outline<CR>",opt)


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
