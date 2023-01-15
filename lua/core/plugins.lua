local pack = require('core.pack').add_plugin
-------------------- startup time analysis
pack({
    "dstein64/vim-startuptime",
    cmd = 'StartupTime'
})

-------------------- colorscheme
pack({
    "aklk1ng/zephyr-nvim",
    priority = 1000,
    config = function()
        vim.cmd("colorscheme zephyr")
    end
})

-------------------- dashboard(the start page)
pack({
    "glepnir/dashboard-nvim",
    event = "BufWinEnter",
    config = require('modules.ui.dashboard').setup
})

-------------------- notification manager
pack({
    "rcarriga/nvim-notify",
    event = { "BufRead", "BufNewFile"},
    config = function ()
        vim.notify = require("notify")
    end
})

-------------------- lspsaga
pack({
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
    branch = "main",
    config = require('modules.ui.lspsaga').config
})

-------------------- lspconfig
pack({
    "neovim/nvim-lspconfig",
    event = {"BufReadPre","BufNewFile"},
    config = require('modules.completion.lspconfig').setup,
    dependencies = {
        -------------------- Standalone UI for nvim-lsp progress
        { "j-hui/fidget.nvim",
            config = require('modules.ui.fidget').setup,
        },
    },
})

-------------------- lualine
pack({
    "nvim-lualine/lualine.nvim",
    event = { 'BufRead', 'BufNewfile' },
    config = require('modules.ui.lualine').setup,
    dependencies = { "kyazdani42/nvim-web-devicons" }
})

-- nvim-cmp
pack({
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        { "hrsh7th/cmp-nvim-lsp" },
        { "saadparwaiz1/cmp_luasnip" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-emoji" },
        { "kdheepak/cmp-latex-symbols" },
        { "onsails/lspkind.nvim"},
    },
    config = require('modules.completion.cmp').config
})
pack({
    "L3MON4D3/LuaSnip",
    event = 'InsertEnter',
    config = require('modules.completion.cmp').lua_snip
})

-------------------- some useful plugins for coding
pack({
    "tpope/vim-commentary",
    event = 'CursorHold'
})

pack({
    "tpope/vim-surround",
    event = 'CursorHold'
})

pack({
    "gcmt/wildfire.vim",
    event = 'CursorHold'
})

-------------------- show the contents of the registers
pack({
    "junegunn/vim-peekaboo",
    event = "BufRead"
})

-------------------- cursor movement
pack({
    "ggandor/leap.nvim",
    event = { "BufRead", "BufNewFile"},
    config = require('modules.tools.leap').setup
})

-- multi cursor
pack({
    "mg979/vim-visual-multi",
    event = 'CursorHold',
    config = require('modules.tools.vim-visual-multi').config()
})

pack({
    "rmagatti/alternate-toggler",
    cmd = "ToggleAlternate"
})

pack({
    "lewis6991/gitsigns.nvim",
    event = { 'BufRead', 'BufNewfile' },
    config = function()
        require('gitsigns').setup()
    end
})

pack({
    "mfussenegger/nvim-dap",
    keys = {
        "<F5>","<F6>","<F7>","<F8>","<leader>db","<leader>dB"
    },
    config = require('modules.tools.dap').config,
    dependencies = {
        { "rcarriga/nvim-dap-ui",
            config = require('modules.tools.dapui').config,
},
    }
})

-------------------- fzflua
-- if you already have installed fzf you don't need the plugin
-- pack({ 'junegunn/fzf', build = './install --bin' }) 
pack({
    "ibhagwan/fzf-lua",
    cmd = 'FzfLua',
    config = require('modules.tools.fzflua').config,
})

-------------------- tree-sitter
pack({
    "nvim-treesitter/nvim-treesitter",
    event = { 'BufRead', 'BufNewfile' },
    build = ':TSUpdate',
    config = require('modules.language.treesitter').setup,
    dependencies = {
        { "aklk1ng/nvim-ts-rainbow" },
        { "windwp/nvim-ts-autotag" },
        { "nvim-treesitter/playground" },
        { "nvim-treesitter/nvim-treesitter-textobjects" }
    }
})

pack({
    "windwp/nvim-autopairs",
    event = 'InsertEnter',
    config = require('modules.completion.cmp').nvim_autopairs
})

-------------------- colorizer(highlight the color)
pack({
    "NvChad/nvim-colorizer.lua",
    cmd = "ColorizerToggle",
    config = require('modules.ui.colorizer').config
})

-------------------- highlight the current word
pack({
    "itchyny/vim-cursorword",
    event = {'BufRead', 'BufNewfile'}
})

-------------------- bufferline
pack({ "kyazdani42/nvim-web-devicons", lazy = true})

pack({
    "akinsho/bufferline.nvim",
    event = { 'BufRead', 'BufNewfile' },
    config = require('modules.ui.bufferline').config,
    dependencies = { "kyazdani42/nvim-web-devicons" }
})

-- the cmd name must be capitalized, though is didfferent from my actual mapping command
pack({'famiu/bufdelete.nvim', cmd = 'Bdelete'})

-------------------- markdown preview and toc
-- use nodejs and yarn to build this plugin(make sure you have installed them)
pack({
    "iamcco/markdown-preview.nvim",
    config = require('modules.language.markdown').config,
    dependencies = {
        { "mzlogin/vim-markdown-toc", cmd = 'MarkdownPreview', ft = 'markdown' },
        { "dhruvasagar/vim-table-mode", cmd = 'MarkdownPreview', ft = 'markdown' },
    },
    build = "cd app && npm install",
    cmd = 'MarkdownPreview',
    ft = 'markdown'
})

-------------------- file explorer
pack({
    "nvim-tree/nvim-tree.lua",
    config = require('modules.tools.nvim-tree').config,
    cmd = "NvimTreeToggle",
})

-------------------- ranger
pack({
    "francoiscabrol/ranger.vim",
    cmd = 'Ranger'
})

-------------------- delete a unuse VIM buffer in VIM automatically
pack({
    "rbgrouleff/bclose.vim",
    event = {'BufRead','BufNewfile'}
})

-------------------- indent-line
pack({
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufRead", "BufNewFile"},
    config = require('modules.ui.indent-blankline').config,
})

------------------- vim-cmake
pack({
    "cdelledonne/vim-cmake",
    cmd = {'CMakeGenerate', 'CMakeBuild'}
})

------------------- vim-dadbod
pack({
    "kristijanhusak/vim-dadbod-ui",
    cmd = 'DBUI',
    dependencies = {
        "tpope/vim-dadbod",
        "kristijanhusak/vim-dadbod-completion"
    },
    config = require('modules.tools.vim-dadbod-ui').config
})
------------------- vim-floaterm
pack({
    "voldikss/vim-floaterm",
    cmd = "FloatermNew",
    config = require('modules.tools.vim-floaterm').config
})

------------------- mutchar.nvim
pack({
    "glepnir/mutchar.nvim",
    ft = { 'c', 'cpp', 'go' },
    config = require('modules.tools.mutchar').config
})

pack({
    "nvim-lua/plenary.nvim",
    lazy = true
})

------------------- todo-comments.nvim
pack({
    "folke/todo-comments.nvim",
    event = { "BufRead", "BufNewFile"},
    config = require('modules.tools.todo-comments').config,
    dependencies = {
        "nvim-lua/plenary.nvim"
    }
})

------------------- neovim-session-manager(now have a small problem with the symbol winbar)
pack({
    "Shatur/neovim-session-manager",
    cmd = { "SessionManager"},
    config = require('modules.tools.session-manager').config,
    dependencies = {
        "nvim-lua/plenary.nvim"
    }
})

------------------- neogen
pack({
    "danymat/neogen",
    cmd = "Neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = require("modules.tools.neogen").config,
})

------------------- automatically toggle the fcitx5
pack({
    "yaocccc/vim-fcitx2en",
    event = "InsertLeavePre"
})
