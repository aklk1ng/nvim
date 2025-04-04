---@type vim.lsp.Config
return {
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'bash', 'sh' },
  settings = {
    bashIde = {
      shellcheckArguments = {
        '-e',
        'SC2086', -- Double quote to prevent globbing and word splitting
        '-e',
        'SC2155', -- Declare and assign separately to avoid masking return values
      },
    },
  },
}
