--download the packer automatically
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
        -------------------- startup time analysis 
        use({ "dstein64/vim-startuptime", cmd = 'StartupTime' })

        -------------------- my colorscheme,i change many styles with the normal onedarkpro theme
        use {"aklk1ng/onedarkpro", config = function ()
            vim.cmd("colorscheme onedarkpro")
        end}

        -------------------- alpha(the start page)
        use { 'goolord/alpha-nvim', requires = { 'kyazdani42/nvim-web-devicons' }, config = "require('pack.alpha')" }
        -------------------- lspsaga
        use({ "glepnir/lspsaga.nvim", branch = "main", config = "require('pack.lsp.lspsaga')"})
        -------------------- notification manager
        use({
            "rcarriga/nvim-notify",
            config = function()
                vim.notify = require("notify")
                -- hardcoded background color
                vim.notify.setup({ background_colour = "#282c34" }) end
        })
        -------------------- provide another way to download language servers and deguggers if you can' download them easily
        use {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
            "jayp0521/mason-nvim-dap.nvim",
        }

        -------------------- a plugin for interating with database
        require('pack/vim-dadbod').config()
        use { 'tpope/vim-dadbod' }
        use { 'kristijanhusak/vim-dadbod-ui', config = "require('pack/vim-dadbod').setup()", after = 'vim-dadbod' }

        -------------------- lspconfig,for telescope's lsp support
        use {"neovim/nvim-lspconfig"}
        -- nvim-cmp 
        use 'hrsh7th/cmp-nvim-lsp' -- { name = nvim_lsp }
        use 'hrsh7th/cmp-buffer' -- { name = 'buffer' },
        use 'hrsh7th/cmp-path' -- { name = 'path' }
        use 'hrsh7th/cmp-cmdline'
        use("hrsh7th/cmp-nvim-lua")
        use {'hrsh7th/cmp-emoji'}
        use { 'hrsh7th/nvim-cmp', config = "require('pack.cmp')" }
        use { 'L3MON4D3/LuaSnip' }
        use { "rafamadriz/friendly-snippets" }
        use { 'saadparwaiz1/cmp_luasnip' }
        use { "onsails/lspkind.nvim"}

        -------------------- some useful plugins for coding
        use { 'tpope/vim-commentary' }
        use { 'tpope/vim-surround' }
        use { 'tpope/vim-repeat'}
        use { 'gcmt/wildfire.vim' }
        --cursor movement
        use { 'easymotion/vim-easymotion' }
        -- multi cursor
        require('pack.vim-visual-multi').config()
        use { 'mg979/vim-visual-multi', config = "require('pack/vim-visual-multi').setup()" }
        use { 'rmagatti/alternate-toggler'}
        use { 'preservim/tagbar' }
        use { 'lewis6991/gitsigns.nvim',tag ="v0.5", config = function()
            require('gitsigns').setup()
        end}
        use { 'dinhhuy258/git.nvim', config = "require('pack.git')"}
        use { "rcarriga/nvim-dap-ui", requires = {{ "mfussenegger/nvim-dap" },{ "theHamsta/nvim-dap-virtual-text" }}, config = "require('pack.dap')" }
        use 'voldikss/vim-floaterm'

        -------------------- telescope
        use { 'nvim-telescope/telescope.nvim', config = "require('pack/telescope')", tag = '0.1.0',
            requires = { { 'nvim-lua/plenary.nvim' } } }
        use { 'nvim-lua/popup.nvim' }
        use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
        use 'nvim-telescope/telescope-file-browser.nvim'
        --place the VIM bookmark
        use { 'MattesGroeger/vim-bookmarks' }
        use { 'tom-anders/telescope-vim-bookmarks.nvim' }

        -------------------- tree-sitter
        use { 'nvim-treesitter/nvim-treesitter', config = "require('pack.treesitter').setup()" }
        use { 'nvim-treesitter/playground', after = { 'nvim-treesitter' } }
        use { "p00f/nvim-ts-rainbow", after = { 'nvim-treesitter' } }
        use { "windwp/nvim-ts-autotag", after = { 'nvim-treesitter' } }
        use { "windwp/nvim-autopairs" }
        --colorizer(highlight the color)
        use { 'NvChad/nvim-colorizer.lua', config = "require('pack.colorizer')"}

        -------------------- bufferline
        use { 'akinsho/bufferline.nvim', config = "require('pack.bufferline')", tag = "v2.*",
            requires = 'kyazdani42/nvim-web-devicons' }
        use 'famiu/bufdelete.nvim'

        -------------------- markdown preview and toc
        require('pack.markdown').config()
        use { 'mzlogin/vim-markdown-toc', cmd = 'MarkdownPreview', ft = 'markdown' }
        --use nodejs and yarn to build this plugin(make sure you have installed them)
        use { "iamcco/markdown-preview.nvim", run = "cd app && npm install", cmd = 'MarkdownPreview', ft = 'markdown' }
        use { 'dhruvasagar/vim-table-mode' , cmd = 'MarkdownPreview', ft = 'markdown'}

        -------------------- file explorer
        use { 'nvim-tree/nvim-tree.lua', config = "require('pack.nvim-tree')", cmd = "NvimTreeToggle", required = { 'kyazdani42/nvim-web-devicons' }, }
        -------------------- ranegr
        use { 'francoiscabrol/ranger.vim', cmd = 'Ranger' }
        --delete a VIM buffer in VIM automatically
        use 'rbgrouleff/bclose.vim'

        -------------------- luaine
        use { 'nvim-lualine/lualine.nvim', config = "require('pack.lualine')" , requires = { 'kyazdani42/nvim-web-devicons', opt = true } }

        -------------------- scolling
        use { 'declancm/cinnamon.nvim', config = function() require('cinnamon').setup() end }
        use { 'gen740/SmoothCursor.nvim',
            config = function()
                require('pack.smoothcursor')
            end
        }

        -------------------- yaocccc's plugins
        use {'yaocccc/nvim-hlchunk'}
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

