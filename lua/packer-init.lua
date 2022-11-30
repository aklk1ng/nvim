--download the packer automatically
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
---@diagnostic disable-next-line: unused-local
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
        use {"aklk1ng/onedarkpro", event = 'BufWinEnter', config = function ()
            vim.cmd("colorscheme onedarkpro")
        end}

        -------------------- alpha(the start page)
        use { 'goolord/alpha-nvim', event = "BufWinEnter", requires = { 'kyazdani42/nvim-web-devicons' }, config = "require('pack.alpha')" }
        -------------------- lspsaga
        use({ "glepnir/lspsaga.nvim", after = 'nvim-lspconfig', branch = "main", config = "require('pack.lsp.lspsaga')"})
        -------------------- notification manager
        use({
            "rcarriga/nvim-notify",
            config = function()
                vim.notify = require("notify")
                -- hardcoded background color
                vim.notify.setup({ background_colour = "#282c34" }) end
        })
        -------------------- provide another way to download language servers if you can' download them easily
        use { "williamboman/mason.nvim" }

        -------------------- a plugin for interating with database
        require('pack/vim-dadbod').config()
        use { 'tpope/vim-dadbod' }
        use { 'kristijanhusak/vim-dadbod-ui', cmd = { 'DBUIToggle', 'DBUIAddConnection', 'DBUI', 'DBUIFindBuffer', 'DBUIRenameBuffer' },
            config = "require('pack/vim-dadbod').setup()",
            after = 'vim-dadbod'
        }

        -------------------- lspconfig,for telescope's lsp support
        use {"neovim/nvim-lspconfig"}
        -- nvim-cmp 
        -- use {
        --     'hrsh7th/nvim-cmp',
        --     -- event = 'InsertEnter',
        --     config = "require('pack.cmp')",
        --     requires = {
        --         { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-lspconfig' },
        --         { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
        --         { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
        --         {'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },
        --         {'hrsh7th/cmp-emoji', after = 'nvim-cmp' },
        --         {'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp'},
        --         { 'saadparwaiz1/cmp_luasnip', after = 'LuaSnip' },
        --     },
        -- }
        use { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-lspconfig'  } -- { name = nvim_lsp }
        use {'hrsh7th/cmp-buffer', after = 'nvim-cmp'}  -- { name = 'buffer' },
        use { 'hrsh7th/cmp-path', after = 'nvim-cmp'  } -- { name = 'path' }
        use {'hrsh7th/cmp-cmdline', after = 'nvim-cmp' }
        use {'hrsh7th/cmp-emoji', after = 'nvim-cmp' }
        use { 'hrsh7th/nvim-cmp', config = "require('pack.cmp')" }
        use { 'L3MON4D3/LuaSnip'}
        use { "rafamadriz/friendly-snippets" }
        use { 'saadparwaiz1/cmp_luasnip', after = 'LuaSnip' }
        use { "onsails/lspkind.nvim"}

        -------------------- some useful plugins for coding
        use { 'tpope/vim-commentary' }
        use { 'tpope/vim-surround' }
        use { 'gcmt/wildfire.vim' }
        -------------------- show the contents of the registers
        use { 'junegunn/vim-peekaboo'}
        --cursor movement
        use { 'ggandor/leap.nvim'}
        -- multi cursor
        require('pack.vim-visual-multi').config()
        use { 'mg979/vim-visual-multi', config = "require('pack/vim-visual-multi').setup()" }
        use { 'rmagatti/alternate-toggler', cmd = 'ToggleAlternate'}
        use { 'preservim/tagbar', cmd = 'TagbarToggle' }
        use { 'lewis6991/gitsigns.nvim', event = { 'BufRead', 'BufNewfile' },tag ="v0.5", config = function()
            require('gitsigns').setup()
        end}
        use { 'dinhhuy258/git.nvim', config = "require('pack.git')"}
        use { "rcarriga/nvim-dap-ui", requires = {{ "mfussenegger/nvim-dap" },{ "theHamsta/nvim-dap-virtual-text" }}, config = "require('pack.dap')" }
        use {'voldikss/vim-floaterm', cmd = 'FloatermNew'}

        -------------------- telescope
        use { 'nvim-telescope/telescope.nvim', config = "require('pack/telescope')", tag = '0.1.0',
            requires = { { 'nvim-lua/plenary.nvim' } } }
        use { 'nvim-lua/popup.nvim' }
        use { 'nvim-telescope/telescope-file-browser.nvim'}
        use {"nvim-telescope/telescope-fzf-native.nvim", run = "make"}
        --place the VIM bookmark
        use { 'MattesGroeger/vim-bookmarks', event = 'BufRead'}

        -------------------- tree-sitter
        use { 'nvim-treesitter/nvim-treesitter', config = "require('pack.treesitter').setup()" }
        use { "p00f/nvim-ts-rainbow", after = { 'nvim-treesitter' } }
        use { "windwp/nvim-ts-autotag", after = { 'nvim-treesitter' } }
        use { "windwp/nvim-autopairs"}
        --colorizer(highlight the color)
        use { 'NvChad/nvim-colorizer.lua', config = "require('pack.colorizer')"}

        -------------------- highlight the current word
        use { 'itchyny/vim-cursorword', event = 'BufRead'}

        -------------------- bufferline
        use { 'akinsho/bufferline.nvim', event = 'BufRead', config = "require('pack.bufferline')", tag = "v2.*",
            requires = 'kyazdani42/nvim-web-devicons' }
        use { 'famiu/bufdelete.nvim', after = 'bufferline.nvim' }

        -------------------- markdown preview and toc
        require('pack.markdown').config()
        use { 'mzlogin/vim-markdown-toc', cmd = 'MarkdownPreview', after = 'markdown-preview.nvim', ft = 'markdown' }
        --use nodejs and yarn to build this plugin(make sure you have installed them)
        use { "iamcco/markdown-preview.nvim", run = "cd app && npm install", cmd = 'MarkdownPreview', ft = 'markdown' }
        use { 'dhruvasagar/vim-table-mode' , cmd = 'MarkdownPreview', after = 'markdown-preview.nvim',ft = 'markdown'}

        -------------------- file explorer
        use { 'nvim-tree/nvim-tree.lua',
            config = "require('pack.nvim-tree')",
            cmd = "NvimTreeToggle",
            event = 'BufWinEnter',
            required = { 'kyazdani42/nvim-web-devicons' },
        }
        -------------------- ranegr
        use { 'francoiscabrol/ranger.vim', cmd = 'Ranger', event = 'BufWinEnter' }
        --delete a VIM buffer in VIM automatically
        use { 'rbgrouleff/bclose.vim', event = 'BufWinEnter' }

        -------------------- luaine
        use { 'nvim-lualine/lualine.nvim', event = 'BufRead', config = "require('pack.lualine')" , requires = { 'kyazdani42/nvim-web-devicons', opt = true } }

        -------------------- scolling
        use { 'declancm/cinnamon.nvim', config = function() require('cinnamon').setup() end }

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

