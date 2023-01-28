local M = {}

function M.footer()
  local stats = require('lazy').stats()
  return '',
    '',
    '   Welcome '
      .. '  v'
      .. vim.version().major
      .. '.'
      .. vim.version().minor
      .. '.'
      .. vim.version().patch
      .. '   '
      .. stats.count
      .. ' plugins'
end

function M.dashboard()
  local home = os.getenv('HOME')
  require('dashboard').setup({
    theme = 'doom',
    config = {
      center = {
        {
          icon = '  ',
          icon_hi = 'DashboardIcon',
          desc = 'Lazy            ',
          desc_hi = 'DashboardDesc',
          key = 'i',
          key_hi = 'DashboardKey',
          action = 'Lazy',
        },
        {
          icon = '  ',
          icon_hi = 'DashboardIcon',
          desc = 'Update          ',
          desc_hi = 'DashboardDesc',
          key = 'u',
          key_hi = 'DashboardKey',
          action = 'Lazy update',
        },
        {
          icon = '  ',
          icon_hi = 'DashboardIcon',
          desc = 'Find Files      ',
          desc_hi = 'DashboardDesc',
          key = 'f',
          key_hi = 'DashboardKey',
          action = 'Telescope find_files',
        },
        {
          icon = '  ',
          icon_hi = 'DashboardIcon',
          desc = 'Old Files       ',
          desc_hi = 'DashboardDesc',
          key = 'o',
          key_hi = 'DashboardKey',
          action = 'Telescope oldfiles',
        },
      },
      footer = {
        M.footer(),
      },
    },
    hide = {
      tabline = false,
    },
    preview = {
      command = 'cat | lolcat -F 0.3', -- preview command
      file_path = home .. '/.config/nvim/static/neovim.cat', -- preview file path
      file_height = 20, -- prefview file height
      file_width = 65, -- preview file width
    },
  })
end

function M.noice()
  local status, noice = pcall(require, 'noice')
  if not status then
    vim.notify('noice not found')
    return
  end
  noice.setup({
    cmdline = {
      enabled = true, -- enables the Noice cmdline UI
      view = 'cmdline', -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
      opts = {}, -- global options for the cmdline. See section on views
    },
    messages = {
      enabled = false, -- enables the Noice messages UI
    },
    lsp = {
      progress = {
        enabled = false,
      },
      signature = {
        enabled = true,
        auto_open = {
          enabled = true,
          trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
          luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
          throttle = 50, -- Debounce lsp signature help request by 50ms
        },
        view = nil, -- when nil, use defaults from documentation
        ---@type NoiceViewOptions
        opts = {}, -- merged with defaults from documentation
      },
    },
  })
end

function M.colorizer()
  require('colorizer').setup({})
end

function M.whiskyline()
  require('whiskyline').setup()
end

return M
