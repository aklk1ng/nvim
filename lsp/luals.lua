return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = {
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
  },
  on_init = function(client)
    local path = client.workspace_folders and client.workspace_folders[1].name
    local fs_stat = vim.uv.fs_stat
    if path and (fs_stat(path .. '/.luarc.json') or fs_stat(path .. '/.luarc.jsonc')) then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT',
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          '${3rd}/luv/library',
        },
      },
      completion = {
        callSnippet = 'Replace',
      },
      hint = {
        enable = true,
      },
    })
  end,
  settings = {
    Lua = {},
  },
}
