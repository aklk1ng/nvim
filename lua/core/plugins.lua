local pack = require('core.pack').add_plugin
-------------------- startup time analysis
pack({ "dstein64/vim-startuptime", lazy = true, cmd = 'StartupTime' })

-------------------- colorscheme
pack({
    'aklk1ng/zephyr-nvim',
    priority = 1000,
    dependencies = { 'nvim-treesitter/nvim-treesitter',"lukas-reineke/indent-blankline.nvim", lazy = true },
    config = function()
        vim.cmd("colorscheme zephyr")
    end
})

-------------------- dashboard(the start page)
pack({
    'glepnir/dashboard-nvim',
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
pack({ "glepnir/lspsaga.nvim",
    event = "LspAttach",
    branch = "main",
    config = require('modules.ui.lspsaga').config
})

-------------------- lspconfig
pack({ "neovim/nvim-lspconfig",
    event = {"BufReadPre","BufNewFile"},
    config = require('modules.completion.lspconfig').setup,
    dependencies = {
        -------------------- Standalone UI for nvim-lsp progress
        { 'j-hui/fidget.nvim',
            config = require('modules.tools.fidget').setup,
        },
    },
})

pack({
    -------------------- luaine
    { 'nvim-lualine/lualine.nvim',
        event = "UIEnter",
        config = require('modules.ui.lualine').setup,
        dependencies = { 'kyazdani42/nvim-web-devicons' }
    },
})

-- nvim-cmp
pack({ 'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    dependencies = {
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'saadparwaiz1/cmp_luasnip' },
        { 'hrsh7th/cmp-path' },
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-cmdline' },
        { 'hrsh7th/cmp-emoji' },
        { 'kdheepak/cmp-latex-symbols' },
        { 'onsails/lspkind.nvim'},
    },
    config = require('modules.completion.cmp').config
})
pack({ 'L3MON4D3/LuaSnip', event = 'InsertEnter', config = require('modules.completion.cmp').lua_snip })

-------------------- some useful plugins for coding
pack({ 'tpope/vim-commentary', event = 'CursorHold' })

pack({ 'tpope/vim-surround', event = 'CursorHold' })

pack({ 'gcmt/wildfire.vim', event = 'CursorHold' })

-------------------- show the contents of the registers
pack({ 'junegunn/vim-peekaboo', event = "BufRead" })

--cursor movement
pack({ 'ggandor/leap.nvim',
    event = { "BufRead", "BufNewFile"},
    config = require('modules.tools.leap').setup
})

-- multi cursor
pack({ 'mg979/vim-visual-multi',
    event = 'CursorHold',
    config = require('modules.tools.vim-visual-multi').config()
})

pack({ 'rmagatti/alternate-toggler', cmd = "ToggleAlternate"})

pack({ 'dinhhuy258/git.nvim',
    cmd = {"GitBlame","GitDiff"},
    config = function()
        require('git').setup()
    end
})

pack({ 'lewis6991/gitsigns.nvim',
    event = { 'BufRead', 'BufNewfile' },
    version = "v0.5",
    config = function()
        require('gitsigns').setup()
    end
})

pack({ "mfussenegger/nvim-dap",
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

-------------------- fzf and fzflua
-- if you already have fzf installed you do not need to install the next plugin
--  { 'junegunn/fzf', run = './install --bin' }
pack({ 'ibhagwan/fzf-lua',
    cmd = 'FzfLua',
    config = require('modules.tools.fzflua').config,
})

--place the VIM bookmark
pack({ 'MattesGroeger/vim-bookmarks', event = 'BufRead' })

-------------------- tree-sitter
pack({ 'nvim-treesitter/nvim-treesitter',
    event = { 'BufRead', 'BufNewfile' },
    build = ':TSUpdate',
    config = require('modules.language.treesitter').setup,
    dependencies = {
        { "aklk1ng/nvim-ts-rainbow" },
        { "windwp/nvim-ts-autotag" },
        { 'nvim-treesitter/playground' },
        { 'nvim-treesitter/nvim-treesitter-textobjects' }
    }
})

pack({ "windwp/nvim-autopairs", event = 'InsertEnter', config = require('modules.completion.cmp').nvim_autopairs })

-------------------- colorizer(highlight the color)
pack({ 'NvChad/nvim-colorizer.lua', cmd = "ColorizerToggle", config = require('modules.ui.colorizer').config })

-------------------- highlight the current word
pack({ 'itchyny/vim-cursorword', event = {'BufRead', 'BufNewfile'} })

-------------------- bufferline
pack({ 'kyazdani42/nvim-web-devicons', lazy = true})

pack({ 'akinsho/bufferline.nvim',
    event = "UIEnter",
    config = require('modules.ui.bufferline').config,
    version = "v2.*",
    dependencies = { 'kyazdani42/nvim-web-devicons' }
})

pack({'famiu/bufdelete.nvim', keys = "<leader>d"})

-------------------- markdown preview and toc
-- use nodejs and yarn to build this plugin(make sure you have installed them)
pack({ "iamcco/markdown-preview.nvim",
    config = require('modules.language.markdown').config,
    dependencies = {
        { 'mzlogin/vim-markdown-toc', cmd = 'MarkdownPreview', ft = 'markdown' },
        { 'dhruvasagar/vim-table-mode', cmd = 'MarkdownPreview', ft = 'markdown' },
    },
    build = "cd app && npm install",
    cmd = 'MarkdownPreview',
    ft = 'markdown'
})

-------------------- file explorer
pack({ 'nvim-tree/nvim-tree.lua',
    config = require('modules.tools.nvim-tree').config,
    cmd = "NvimTreeToggle",
})

-------------------- ranger
pack({ 'francoiscabrol/ranger.vim', cmd = 'Ranger' })

-------------------- delete a unuse VIM buffer in VIM automatically
pack({ 'rbgrouleff/bclose.vim', event = {'BufRead','BufNewfile'} })

-------------------- indent-line
pack({ "lukas-reineke/indent-blankline.nvim",
    event = { "BufRead", "BufNewFile"},
    config = require('modules.ui.indent-blankline').config,
})

------------------- automatically toggle the fcitx5
pack({
    "yaocccc/vim-fcitx2en",
    event = "InsertLeavePre"
})
