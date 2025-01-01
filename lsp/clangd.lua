return {
  cmd = { 'clangd', '--clang-tidy', '--background-index', '--header-insertion-decorators=false' },
  filetypes = { 'c', 'cpp' },
  root_markers = { '.clangd', '.clang-format', 'compile_commands.json' },
  init_options = { fallbackFlags = { vim.bo.filetype == 'cpp' and '-std=c++23' or nil } },
}
