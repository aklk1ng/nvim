function _G.OilBar()
  local dir = require('oil').get_current_dir()
  if dir then
    return vim.fn.fnamemodify(dir, ':~')
  else
    -- If there is no current directory (e.g. over ssh), just show the buffer name
    return vim.api.nvim_buf_get_name(0)
  end
end
require('oil').setup({
  delete_to_trash = true,
  watch_for_changes = true,
  columns = { '' },
  win_options = {
    number = false,
    relativenumber = false,
    winbar = '%{v:lua.OilBar()}',
  },
  keymaps = {
    ['<C-h>'] = false,
    ['<C-l>'] = false,
    ['<C-k>'] = false,
    ['<C-j>'] = false,
    ['<C-s>'] = false,
    ['gh'] = { '<cmd>edit $HOME<CR>', desc = 'Go to HOME directory' },
    ['<M-v>'] = {
      'actions.select',
      opts = { vertical = true },
      desc = 'Open the entry in a vertical split',
    },
    ['<M-s>'] = {
      'actions.select',
      opts = { horizontal = true },
      desc = 'Open the entry in a horizontal split',
    },
    ['gl'] = {
      desc = 'Toggle detail view',
      callback = function()
        local oil = require('oil')
        local config = require('oil.config')
        if #config.columns == 1 then
          oil.set_columns({ 'permissions', 'size', 'mtime' })
        else
          oil.set_columns({ '' })
        end
      end,
    },
  },
  view_options = {
    is_always_hidden = function(name, bufnr)
      return name == '..'
    end,
    show_hidden = true,
  },
  confirmation = {
    border = vim.o.winborder,
  },
  float = {
    border = vim.o.winborder,
  },
  progress = {
    border = vim.o.winborder,
  },
  ssh = {
    border = vim.o.winborder,
  },
  keymaps_help = {
    border = vim.o.winborder,
  },
})

vim.keymap.set('n', '<leader>e', _G._cmd('Oil'))
