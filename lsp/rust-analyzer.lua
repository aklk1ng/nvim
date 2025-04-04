---@type vim.lsp.Config
return {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_dir = function(bufnr, cb)
    local root = vim.fs.root(bufnr, { 'Cargo.toml' })
    if root then
      vim.system(
        { 'cargo', 'metadata', '--no-depts', '--format-version', '1' },
        { cwd = root },
        function(obj)
          if obj.code ~= 0 then
            cb(root)
          else
            local success, result = pcall(vim.json.decode, obj.stdout)
            if success and result.workspace_root then
              cb(result.workspace_root)
            else
              cb(root)
            end
          end
        end
      )
    else
      cb(vim.fs.root(bufnr, { 'rust-project.json', '.git' }))
    end
  end,
  capabilities = {
    experimental = {
      serverStatusNotification = true,
    },
  },
  settings = {
    ['rust-analyzer'] = {
      imports = {
        granularity = {
          group = 'module',
        },
        prefix = 'self',
      },
      check = {
        command = 'clippy',
        extraArgs = {
          '--no-deps',
          '--message-format=json-diagnostic-rendered-ansi',
        },
        workspace = false,
      },
      checkOnSave = true,
      cargo = {
        buildScripts = {
          enable = true,
        },
      },
      procMacro = {
        enable = true,
      },
    },
  },
}
