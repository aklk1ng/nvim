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

        -------------------- colorscheme
        -- use {"aklk1ng/onedarkpro", config = function ()
        --     vim.cmd("colorscheme onedarkpro")
        -- end}
        use({
            'aklk1ng/zephyr-nvim',
            requires = { 'nvim-treesitter/nvim-treesitter', opt = true },
            config = function ()
                vim.cmd("colorscheme zephyr")
            end
        })

        -------------------- alpha(the start page)
        use { 'goolord/alpha-nvim', requires = { 'kyazdani42/nvim-web-devicons' }, config = require('pack.ui.alpha').setup }
        -------------------- lspsaga
        use({ "glepnir/lspsaga.nvim", after = 'nvim-lspconfig', branch = "main", config = "require('pack.ui.lspsaga')"})
        -------------------- notification manager
        use({
            "rcarriga/nvim-notify",
            config = function()
                vim.notify = require("notify")
                -- hardcoded background color
                vim.notify.setup({ background_colour = "#282c34" }) end
        })

        -------------------- a plugin for interating with database
        require('pack.tools.vim-dadbod').config()
        use { 'tpope/vim-dadbod' }
        use { 'kristijanhusak/vim-dadbod-ui', cmd = { 'DBUIToggle', 'DBUIAddConnection', 'DBUI', 'DBUIFindBuffer', 'DBUIRenameBuffer' },
            config = "require('pack.tools.vim-dadbod').setup()",
            after = 'vim-dadbod'
        }

        -------------------- lspconfig,for telescope's lsp support
        use {"neovim/nvim-lspconfig",
            ft = {'c', 'cpp', 'lua', 'cmake', 'go', 'sh', 'typescript', 'python', 'html', 'css', 'json', 'typescriptreact', 'markdown'},
            config = require('pack.completion.lspconfig').setup
        }
        -------------------- provide another way to download language server
        use { "williamboman/mason.nvim", cmd = 'Mason',
            config = function ()
                require("mason").setup()
        end}
        -- nvim-cmp 
        use { 'hrsh7th/nvim-cmp', after = 'LuaSnip', config = require('pack.completion.cmp').config}
        use { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' }
        use { 'hrsh7th/cmp-nvim-lsp', after = 'cmp_luasnip' }
        use { 'hrsh7th/cmp-path', after = 'cmp-nvim-lsp' }
        use { 'hrsh7th/cmp-buffer', after = 'cmp-path' }
        use { 'hrsh7th/cmp-cmdline', after = 'cmp-buffer'}
        use { 'hrsh7th/cmp-emoji', after = 'cmp-cmdline'}
        use { 'L3MON4D3/LuaSnip', event = 'InsertEnter', config = require('pack.completion.cmp').lua_snip}
        use { "onsails/lspkind.nvim"}

        -------------------- some useful plugins for coding
        use { 'tpope/vim-commentary'}
        use { 'tpope/vim-surround', event = 'CursorHold' }
        use {'gcmt/wildfire.vim'}
        use { 'glepnir/mcc.nvim', event = 'InsertEnter',config = "require('pack.tools.mcc')"}
        -------------------- show the contents of the registers
        use { 'junegunn/vim-peekaboo', event = "BufRead"}
        --cursor movement
        use { 'ggandor/leap.nvim'}
        -- multi cursor
        require('pack.tools.vim-visual-multi').config()
        use { 'mg979/vim-visual-multi', event = 'CursorHold', config = "require('pack.tools.vim-visual-multi').setup()" }
        use { 'rmagatti/alternate-toggler', cmd = 'ToggleAlternate'}
        use { 'lewis6991/gitsigns.nvim', event = { 'BufRead', 'BufNewfile' },tag ="v0.5", config = function()
            require('gitsigns').setup()
        end}
        use {"theHamsta/nvim-dap-virtual-text",require("nvim-dap-virtual-text").setup()}
        use { "mfussenegger/nvim-dap", config = "require('pack.tools.dap')"}
        use { "rcarriga/nvim-dap-ui",
            config = "require('pack.tools.dapui')"
        }
        use {'voldikss/vim-floaterm', cmd = 'FloatermNew'}


        -------------------- fzf and fzflua
        -- if you already have fzf installed you do not need to install the next plugin
        -- use { 'junegunn/fzf', run = './install --bin' }
        use { 'ibhagwan/fzf-lua',
            cmd = 'FzfLua',
            config = require('pack.tools.fzflua').config,
            requires = { 'nvim-tree/nvim-web-devicons' }
        }

        --place the VIM bookmark
        use { 'MattesGroeger/vim-bookmarks', event = 'BufRead'}

        -------------------- tree-sitter
        use { 'nvim-treesitter/nvim-treesitter', event = 'BufRead', run = ':TSUpdate', config = "require('pack.language.treesitter').setup()" }
        use { "p00f/nvim-ts-rainbow", after = { 'nvim-treesitter' } }
        use { "windwp/nvim-ts-autotag", after = { 'nvim-treesitter' } }
        use { 'nvim-treesitter/nvim-treesitter-textobjects', after = { 'nvim-treesitter' }}
        use { "windwp/nvim-autopairs", event = 'InsertEnter', config = require('pack.completion.cmp').nvim_autopairs}
        --colorizer(highlight the color)
        use { 'NvChad/nvim-colorizer.lua', cmd = "ColorizerToggle", config = "require('pack.ui.colorizer')"}

        -------------------- highlight the current word
        use { 'itchyny/vim-cursorword', event = 'BufRead'}

        -------------------- bufferline
        use {'kyazdani42/nvim-web-devicons' }
        use { 'akinsho/bufferline.nvim',
            event = "BufWinEnter",
            config = "require('pack.ui.bufferline')",
            tag = "v2.*",
            requires = { 'kyazdani42/nvim-web-devicons' }
        }
        use { 'famiu/bufdelete.nvim', after = 'bufferline.nvim' }

        -------------------- markdown preview and toc
        require('pack.language.markdown').config()
        --use nodejs and yarn to build this plugin(make sure you have installed them)
        use { "iamcco/markdown-preview.nvim", run = "cd app && npm install", cmd = 'MarkdownPreview', ft = 'markdown' }
        use { 'mzlogin/vim-markdown-toc', cmd = 'MarkdownPreview', after = 'markdown-preview.nvim', ft = 'markdown' }
        use { 'dhruvasagar/vim-table-mode' , cmd = 'MarkdownPreview', after = 'markdown-preview.nvim',ft = 'markdown'}

        -------------------- file explorer
        use { 'nvim-tree/nvim-tree.lua',
            config = "require('pack.tools.nvim-tree').config()",
            cmd = "NvimTreeToggle",
        }
        -------------------- ranegr
        use { 'francoiscabrol/ranger.vim', cmd = 'Ranger'}
        --delete a VIM buffer in VIM automatically
        use { 'rbgrouleff/bclose.vim', event = 'BufWinEnter' }

        -------------------- luaine
        use { 'nvim-lualine/lualine.nvim',
            event = "BufWinEnter",
            config = "require('pack.ui.lualine').setup()",
            requires = { 'kyazdani42/nvim-web-devicons' }
        }

        -------------------- yaocccc's plugins
        use {'yaocccc/nvim-hlchunk', event = "BufRead"}
        use { 'yaocccc/vim-fcitx2en', event = 'InsertLeavePre' }
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

