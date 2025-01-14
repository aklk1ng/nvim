return {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
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
