return {
  cmd = { 'clangd', '--clang-tidy', '--header-insertion-decorators=false' },
  filetypes = { 'c', 'cpp' },
  init_options = { fallbackFlags = { vim.bo.filetype == 'cpp' and '-std=c++23' or nil } },
}
