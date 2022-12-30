local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)
vim.g.mapleader = " " -- make sure to set `mapleader` before lazy so your mappings are correct

require("lazy").setup({
    -------------------- startup time analysis
    ({ "dstein64/vim-startuptime", cmd = 'StartupTime' }),

    -------------------- colorscheme
    ({
        'aklk1ng/zephyr-nvim',
        priority = 1000,
        dependencies = { 'nvim-treesitter/nvim-treesitter', lazy = true },
        config = function()
            vim.cmd("colorscheme zephyr")
        end
    }),

    -------------------- alpha(the start page)
    { 'goolord/alpha-nvim',
        config = require('modules.ui.dashboard').setup
    },
    -------------------- notification manager
    ({
        "rcarriga/nvim-notify",
        config = function ()
            vim.notify = require("notify")
        end
    }),

    -------------------- lspsaga
    ({ "glepnir/lspsaga.nvim",
        branch = "main",
        config = require('modules.ui.lspsaga').config,
        dependencies = {'kyazdani42/nvim-web-devicons'}
    }),

    -------------------- lspconfig,for telescope's lsp support
    { "neovim/nvim-lspconfig",
        config = require('modules.completion.lspconfig').setup
    },
    -------------------- Standalone UI for nvim-lsp progress
    { 'j-hui/fidget.nvim',
        config = require('modules.tools.fidget').setup,
        dependencies = {"neovim/nvim-lspconfig"}
    },

    -- nvim-cmp
    { 'hrsh7th/nvim-cmp',
        event = "InsertEnter",
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-cmdline' },
            { 'hrsh7th/cmp-emoji' },
        },
        config = require('modules.completion.cmp').config },
    { 'L3MON4D3/LuaSnip', event = 'InsertEnter', config = require('modules.completion.cmp').lua_snip },

    -------------------- some useful plugins for coding
    { 'tpope/vim-commentary'},
    { 'tpope/vim-surround', event = 'CursorHold' },
    { 'gcmt/wildfire.vim', event = 'CursorHold' },
    -------------------- show the contents of the registers
    { 'junegunn/vim-peekaboo', event = "BufRead" },
    --cursor movement
    { 'ggandor/leap.nvim',
        config = require('modules.tools.leap').setup
    },
    -- multi cursor
    { 'mg979/vim-visual-multi', event = 'CursorHold',
        config = require('modules.tools.vim-visual-multi').config()
    },
    { 'rmagatti/alternate-toggler',cmd = "ToggleAlternate"},
    { 'lewis6991/gitsigns.nvim',
        event = { 'BufRead', 'BufNewfile' },
        version = "v0.5",
        config = function()
            require('gitsigns').setup()
        end
    },
    { "rcarriga/nvim-dap-ui",
        event = { 'BufRead', 'BufNewfile' },
        config = require('modules.tools.dapui').config,
        dependencies = {
            { "mfussenegger/nvim-dap", config = require('modules.tools.dap').config },
        }
    },


    -------------------- fzf and fzflua
    -- if you already have fzf installed you do not need to install the next plugin
    --  { 'junegunn/fzf', run = './install --bin' }
    { 'ibhagwan/fzf-lua',
        cmd = 'FzfLua',
        config = require('modules.tools.fzflua').config,
    },

    --place the VIM bookmark
    { 'MattesGroeger/vim-bookmarks', event = 'BufRead' },

    -------------------- tree-sitter
    { 'nvim-treesitter/nvim-treesitter', event = { 'BufRead', 'BufNewfile' }, build = ':TSUpdate',
        config = require('modules.language.treesitter').setup,
        dependencies = {
            { "aklk1ng/nvim-ts-rainbow" },
            { "windwp/nvim-ts-autotag" },
            { 'nvim-treesitter/playground' },
        }
    },
    { "windwp/nvim-autopairs", event = 'InsertEnter', config = require('modules.completion.cmp').nvim_autopairs },
    --colorizer(highlight the color)
    { 'NvChad/nvim-colorizer.lua', cmd = "ColorizerToggle", config = require('modules.ui.colorizer').config },

    -------------------- highlight the current word
    { 'itchyny/vim-cursorword', event = {'BufRead', 'BufNewfile'} },

    -------------------- bufferline
    { 'kyazdani42/nvim-web-devicons'},

    { 'akinsho/bufferline.nvim',
        event = "UIEnter",
        config = require('modules.ui.bufferline').config,
        version = "v2.*",
        dependencies = { 'famiu/bufdelete.nvim', 'kyazdani42/nvim-web-devicons' }
    },

    -------------------- markdown preview and toc
    -- nodejs and yarn to build this plugin(make sure you have installed them)
    { "iamcco/markdown-preview.nvim",
        config = require('modules.language.markdown').config,
        dependencies = {
            { 'mzlogin/vim-markdown-toc', cmd = 'MarkdownPreview', ft = 'markdown' },
            { 'dhruvasagar/vim-table-mode', cmd = 'MarkdownPreview', ft = 'markdown' },
        },
        build = "cd app && npm install",
        cmd = 'MarkdownPreview',
        ft = 'markdown'
    },

    -------------------- file explorer
    { 'nvim-tree/nvim-tree.lua',
        config = require('modules.tools.nvim-tree').config,
        cmd = "NvimTreeToggle",
    },
    -------------------- ranger
    { 'francoiscabrol/ranger.vim', cmd = 'Ranger' },
    --delete a VIM buffer in VIM automatically
    { 'rbgrouleff/bclose.vim', event = {'BufRead','BufNewfile'} },

    -------------------- luaine
    { 'nvim-lualine/lualine.nvim',
        config = require('modules.ui.lualine').setup,
        dependencies = { 'kyazdani42/nvim-web-devicons' }
    },

    { "lukas-reineke/indent-blankline.nvim",
        config = require('modules.ui.indent-blankline').config,
        dependencies = {'aklk1ng/zephyr-nvim'}
    },

    -------------------- yaocccc's plugins
    { 'yaocccc/vim-fcitx2en', event = 'InsertLeavePre' },
})
