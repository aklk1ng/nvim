local G = require('G')
local map = G.api.nvim_set_keymap
local opt = { noremap = true, silent = true }

-- map('模式','按键','映射为XX',opt)
map("n", "W", ":write<CR>", opt)
map("n", "Q", ":q<CR>", opt)
map("n", "<C-a>", "gg<S-v>G", opt)


---------------------------- change letter case
map("n", "..", "~", opt)
---------------------------- find pair
map("n", ",.", "%", opt)

---------------------------- open the nvim config file anytime
map("n", "en", ":e ~/.config/nvim/lua/packer-init.lua<CR>", opt)
---------------------------- cursor movement
map("n", "<C-i>", "<Home>", opt)
map("n", "<C-p>", "<End>", opt)

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

---------------------------- markdonw
map("n", "<leader>m", ":MarkdownPreview<CR>", opt)
map("n", "<leader>tm", ":TableModeToggle<CR>", opt)
---------------------------- markdown-toc
map("n", "tg", ":GenTocGFM<CR>", opt)
map("n", "tr", ":GenTocRedcarpet<CR>", opt)

---------------------------- ranger
G.cmd([[
    let g:ranger_map_keys = 0
    let g:NERDTreeHijackNetrw = 0
]])
map("n", "ra", ":Ranger<CR>", opt)

G.cmd([[ 
    silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)
]])

---------------------------- tabgar(a list of functions,variables,defines and so on)
G.cmd([[
     let g:tagbar_width = 45
]])
map("n", "tt", ":TagbarToggle<CR>", opt)

---------------------------- easymoton
map("n", "<leader>w", "<Plug>(easymotion-overwin-w)", opt)


---------------------------- vim-bookmarks
map("n", "mm", ":BookmarkToggle<CR>", opt)
map("n", "mp", ":BookmarkPrev<CR>", opt)
map("n", "mn", ":BookmarkNext<CR>", opt)
map("n", "ma", ":BookmarkShowAll<CR>", opt)
map("n", "mc", ":BookmarkClear<CR>", opt)
map("n", "mC", ":BookmarkClearAll<CR>", opt)

---------------------------- telescope
map("n", "fl", ":Telescope file_browser<CR>", opt) --列出当前工作目录中的目录及文件，非递归(与nvim-tree类似)
map("n", "ff", ":Telescope find_files<CR>", opt) --列出当前工作目录中的文件
map("n", "fb", ":Telescope buffers<CR>", opt) --列出当前打开的缓冲区
map("n", "fc", ":Telescope command_history<CR>", opt) --查找命令历史
map("n", "fo", ":Telescope oldfiles<CR>", opt) --查找文件历史
map("n", "fm", ":Telescope vim_bookmarks current_file<CR>", opt) --显示当前文件标签
map("n", "fM", ":Telescope vim_bookmarks all<CR>", opt) --查找当前工程所有的标签
map("n", "fs", ":Telescope lsp_document_symbols<CR>", opt) --查找当前文件所有的标识符
map("n", "fS", ":Telescope lsp_workspace_symbols<CR>", opt) --查找当前工程所有的标识符
map("n", "fd", ":Telescope diagnostics<CR>", opt) --查找当前工程所有的诊断信息
map("n", "fk", ":Telescope keymaps<CR>", opt) --查找键盘映射
map("n", "fw", ":Telescope live_grep<CR>", opt) --查找当前目录的字符串

---------------------------- floaterm
map("n", "fn", ":FloatermNew<CR>", opt) --open a terminal window
map("n", "ft", ":FloatermKill<CR>", opt) --kill the terminal window


----------------------------- fzf
map("n", "fz", ":FZF<CR>", opt) --fuzzy finder

---------------------------- alternate(逻辑取反)
map("n", "ta", ":ToggleAlternate<CR>", opt)

---------------------------- lazygit
map("n", "lg", ":tabe<CR>:-tabmove<CR>:terminal lazygit<CR>", opt)
---------------------------- lazynpm
map("n", "lnm", ":tabe<CR>:-tabmove<CR>:terminal lazynpm<CR>", opt)
