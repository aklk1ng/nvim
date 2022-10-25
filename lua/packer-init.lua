--make sure to download the packer automatically
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    local compiled_path = fn.stdpath('config')..'/plugin/packer_compiled.lua'
    if fn.empty(fn.glob(install_path)) > 0 then
        print('Installing packer.nvim...')
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()
require('packer').startup({
    function(use)
        use { 'wbthomason/packer.nvim' }
        -- startup time analysis
        use({ "dstein64/vim-startuptime" })
        
        use {'rmehri01/onenord.nvim', config = function() require('pack.onenord') vim.cmd("colorscheme onenord") end,}

        --alpha(the start page)
        use { 'goolord/alpha-nvim', requires = { 'kyazdani42/nvim-web-devicons' }, config = "require('pack.alpha')" }
        --lspsaga
        use({ "glepnir/lspsaga.nvim", branch = "main", config = "require('pack.lspsaga')"})
        --null-ls
        use { 'jose-elias-alvarez/null-ls.nvim', config = "require('pack.null-ls')" } -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua

        -- notification manager
        use({
            "rcarriga/nvim-notify",
            config = function()
                vim.notify = require("notify")
                -- hardcoded background color
                vim.notify.setup({ background_colour = "#282c34" }) end
        })

        -- lspconfig,for telescope's lsp support
        use { 'neovim/nvim-lspconfig' }

        -- nvim-cmp
        use 'hrsh7th/cmp-nvim-lsp' -- { name = nvim_lsp }
        use 'hrsh7th/cmp-buffer' -- { name = 'buffer' },
        use 'hrsh7th/cmp-path' -- { name = 'path' }
        use 'hrsh7th/cmp-cmdline'
        use {'hrsh7th/cmp-emoji'}
        use { 'hrsh7th/nvim-cmp', config = "require('pack.cmp')" }
        use { 'L3MON4D3/LuaSnip' }
        use { "rafamadriz/friendly-snippets" }
        use { 'saadparwaiz1/cmp_luasnip' }
        use { "onsails/lspkind.nvim" }

        use { 'tpope/vim-commentary' }
        use { 'tpope/vim-surround' }
        use { 'gcmt/wildfire.vim' }
        --cursor movement
        use { 'easymotion/vim-easymotion' }
        -- multi cursor
        require('pack.vim-visual-multi').config()
        use { 'mg979/vim-visual-multi', config = "require('pack/vim-visual-multi').setup()" }
        use { 'rmagatti/alternate-toggler', config = "require('pack.alternate-toggle')" }
        use { 'preservim/tagbar' }
        use { 'lewis6991/gitsigns.nvim', config = "require('pack.gitsigns')" }
        use { 'dinhhuy258/git.nvim', config = "require('pack.git')"}
        use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" }, config = "require('pack.dap')" }

        --telescope
        use { 'nvim-telescope/telescope.nvim', config = "require('pack/telescope')", tag = '0.1.0',
            requires = { { 'nvim-lua/plenary.nvim' } } }
        use { 'nvim-lua/popup.nvim' }
        --preview img
        use { "nvim-telescope/telescope-media-files.nvim" }
        use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
        use 'nvim-telescope/telescope-file-browser.nvim'
        --place the VIM bookmark
        use { 'MattesGroeger/vim-bookmarks' }
        use { 'tom-anders/telescope-vim-bookmarks.nvim' }

        -- tree-sitter
        use { 'nvim-treesitter/nvim-treesitter', config = "require('pack.treesitter').setup()" }
        use { 'nvim-treesitter/playground', after = { 'nvim-treesitter' } }
        use { "p00f/nvim-ts-rainbow", after = { 'nvim-treesitter' } }
        use { "windwp/nvim-ts-autotag", after = { 'nvim-treesitter' } }
        use { "windwp/nvim-autopairs" }
        --colorizer(highlight the color)
        use { 'NvChad/nvim-colorizer.lua', config = "require('pack.colorizer')" }

        --bufferline
        use { 'akinsho/bufferline.nvim', config = "require('pack.bufferline')", tag = "v2.*",
            requires = 'kyazdani42/nvim-web-devicons' }
        use 'famiu/bufdelete.nvim'

        -- markdown preview and toc
        require('pack.markdown').config()
        use { 'mzlogin/vim-markdown-toc' }
        use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", cmd = 'MarkdownPreview', ft = 'markdown' })
        use { 'dhruvasagar/vim-table-mode' }

        -- file explorer
        use { 'nvim-tree/nvim-tree.lua', config = "require('pack.nvim-tree')", required = { 'kyazdani42/nvim-web-devicons' }, }
        --ranegr
        use 'francoiscabrol/ranger.vim'
        --delete a VIM buffer in VIM without closing the window
        use 'rbgrouleff/bclose.vim'

        --luaine
        use { 'nvim-lualine/lualine.nvim', config = "require('pack.lualine')" , requires = { 'kyazdani42/nvim-web-devicons', opt = true } }

        --scolling
        use { 'declancm/cinnamon.nvim', config = function() require('cinnamon').setup() end }

        --highlight the word and find them efficient
        use { 'lfv89/vim-interestingwords' }
        use { 'yaocccc/nvim-hlchunk' } -- 高亮{}范围
        use { 'yaocccc/vim-fcitx2en', event = 'InsertLeavePre' } -- 退出输入模式时自动切换到英文
    end,
    --set up to download plugins as a floating window
    config = {
        git = { clone_timeout = 120 },
        display = {
            working_sym = '[ ]', error_sym = '[✗]', done_sym = '[✓]', removed_sym = ' - ', moved_sym = ' → ',
            header_sym = '─',
            open_fn = function() return require("packer.util").float({ border = "rounded" }) end
        }
    }
})

if packer_bootstrap then
    require('packer').sync()
end
