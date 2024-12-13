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
