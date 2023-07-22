local M = {}

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
          icon = '  ',
          icon_hi = 'DashboardIcon',
          desc = 'Old Files       ',
          desc_hi = 'DashboardDesc',
          key = 'o',
          key_hi = 'DashboardKey',
          action = 'Telescope oldfiles',
        },
      },
    },
    hide = {
      tabline = false,
    },
    preview = {
      command = 'cat | lolcat -F 0.3', -- preview command
      file_path = home .. '/.config/nvim/static/girl.cat', -- preview file path
      file_height = 20, -- prefview file height
      file_width = 65, -- preview file width
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
