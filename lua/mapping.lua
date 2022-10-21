-- 保存本地变量
local G = require('G')
local map = G.api.nvim_set_keymap
local opt = {noremap = true, silent = true }

-- 之后就可以这样映射按键了
-- map('模式','按键','映射为XX',opt)
map("n", "W", ":write<CR>", opt)
map("n", "Q", ":q!<CR>", opt)


-- . 与 ~ 作用在nvim中都是更改字母大小写
--find pair
map("n", ",.", "%", opt)

--open the nvim config file anytime
map("n", "en", ":e ~/.config/nvim/lua/packer-init.lua<CR>", opt)
--cursor movement
map("n", "<C-a>", "<Home>", opt)
map("n", "<C-p>", "<End>", opt)

map("n", "sp", ":split ", opt)
map("n", "vsp", ":vsplit ", opt)
--resize split windows
map("n", "<leader><left>", ":vertical resize+5<CR>", opt)
map("n", "<leader><right>", ":vertical resize-5<CR> ", opt)
--packer
map("n", "<leader><leader>i", ":PackerInstall<CR>", opt)
map("n", "<leader><leader>d", ":PackerClean<CR>", opt)
map("n", "<leader><leader>s", ":PackerSync<CR>", opt)
map("n", "<leader><leader>c", ":PackerCompile<CR>", opt)

--nvim-tree
map('n', '<leader>t', ':NvimTreeToggle<CR>', opt)

-- bufferline 左右Tab切换
map("n", "<leader>p", ":BufferLineCyclePrev<CR>", opt)
map("n", "<leader>n", ":BufferLineCycleNext<CR>", opt)
map("n", "<leader>d", ":bdelete<CR>", opt)

--markdonw
map("n", "<leader>m", ":MarkdownPreview<CR>", opt)
map("n", "<leader>tm", ":TableModeToggle<CR>", opt)

--ranger
G.cmd([[
    let g:ranger_map_keys = 0
    let g:NERDTreeHijackNetrw = 0
]])
map("n", "ra", ":Ranger<CR>", opt)

--tabgar
G.cmd([[
     let g:tagbar_width = 45
]])
map("n", "tt", ":TagbarToggle<CR>", opt)

--markdown-toc
map("n", "tg", ":GenTocGFM<CR>", opt)
map("n", "tr", ":GenTocRedcarpet<CR>", opt)

--easymoton
map("n", "<leader>w", "<Plug>(easymotion-overwin-w)", opt)


--vim-bookmarks
map("n", "mm", ":BookmarkToggle<CR>", opt)
map("n", "mp", ":BookmarkPrev<CR>", opt)
map("n", "mn", ":BookmarkNext<CR>", opt)
map("n", "ma", ":BookmarkShowAll<CR>", opt)
map("n", "mc", ":BookmarkClear<CR>", opt)
map("n", "mC", ":BookmarkClearAll<CR>", opt)

--telescope
map("n", "ff", ":Telescope find_files<CR>", opt)--列出当前工作目录中的文件
map("n", "fb", ":Telescope buffers<CR>", opt)--列出当前neovim实例中打开的缓冲区
map("n", "fp", ":Telescope media_files<CR>", opt)--
map("n", "fc", ":Telescope command_history<CR>", opt)--查找命令历史
map("n", "fo", ":Telescope oldfiles<CR>", opt)--查找文件历史
map("n", "fm", ":Telescope vim_bookmarks current_file<CR>", opt)--显示当前文件标签
map("n", "fM", ":Telescope vim_bookmarks all<CR>", opt)--查找工程所有的标签
map("n", "fs", ":Telescope lsp_document_symbols<CR>", opt)--查找当前文件所有的标识符
map("n", "fS", ":Telescope lsp_workspace_symbols<CR>", opt)--查找当前工程所有的标识符
map("n", "fd", ":Telescope diagnostics<CR>", opt)--查找当前工程所有的诊断信息
map("n", "fk", ":Telescope keymaps<CR>", opt)--查找键盘映射
map("n", "fw", ":Telelscope live_grep<CR>", opt)--查找当前目录的字符串


--floaterm
map("n", "ft", ":FloatermToggle<CR>", opt)
-- map("n", "fk", ":FloatermKill<CR>", opt)

--alternate(逻辑取反)
map("n", "ta", ":ToggleAlternate<CR>", opt)

--lazygit
map("n", "lg", ":tabe<CR>:-tabmove<CR>:terminal lazygit<CR>", opt)
--lazynpm
map("n", "lnm", ":tabe<CR>:-tabmove<CR>:terminal lazynpm<CR>", opt)
