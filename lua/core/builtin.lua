local map = require('keymap')

---------------------------- lsp
-- vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
--   border = 'rounded',
-- })

vim.lsp.handlers['workspace/diagnostic/refresh'] = function(_, _, ctx)
  local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
  local bufnr = vim.api.nvim_get_current_buf()
  vim.diagnostic.reset(ns, bufnr)
  return true
end

vim.diagnostic.config({
  signs = false,
  severity_sort = true,
  underline = true,
  update_in_insert = false,
  virtual_text = true,
})

-- map.n({
--   ['[n'] = vim.diagnostic.goto_next,
--   [']n'] = vim.diagnostic.goto_prev,
--   ['gr'] = vim.lsp.buf.rename,
--   ['ga'] = vim.lsp.buf.code_action,
--   [';h'] = vim.lsp.buf.hover,
--   ['gD'] = vim.lsp.buf.declaration,
--   ['gd'] = vim.lsp.buf.definition,
--   ['gi'] = vim.lsp.buf.implementation,
--   ['gt'] = vim.lsp.buf.type_definition,
-- })
