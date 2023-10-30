local g = vim.g
-- disable_distribution_plugins
g.loaded_gzip = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_matchit = 1
g.loaded_2html_plugin = 1
g.loaded_logiPat = 1
g.loaded_rrhelper = 1
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

vim.g.lsp_ft = {
  'go',
  'lua',
  'rust',
  'c',
  'cpp',
  'zig',
  'python',
  'json',
  'cmake',
}

local function check()
  local cmds = {
    'git',
    'node',
    'npm',
    'python3',
  }
  for _, cmd in ipairs(cmds) do
    if vim.fn.executable(cmd) ~= 1 then
      print(cmd .. ' not found')
      return false
    else
      return true
    end
  end
end

if check() then
  vim.api.nvim_create_autocmd('UIEnter', {
    once = true,
    callback = function()
      vim.cmd.colorscheme('aklk1ng')
      require('utils.api.stc').setup()
      require('utils.api.fold')
      require('keymap.basic')
      require('core.event')
    end,
  })
  require('core.options')
  require('core.pack'):boot_strap()
  require('keymap.modules')
end
