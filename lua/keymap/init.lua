_G.map('n', '<leader>g', _G.cmd('Gitsigns diffthis vertical=true'))
_G.map('n', ']c', function()
  if vim.wo.diff then
    vim.cmd.normal({ ']c', bang = true })
  else
    require('gitsigns').nav_hunk('next', { target = 'all' })
  end
end, { silent = true })
_G.map('n', '[c', function()
  if vim.wo.diff then
    vim.cmd.normal({ '[c', bang = true })
  else
    require('gitsigns').nav_hunk('prev', { target = 'all' })
  end
end, { silent = true })
_G.map('n', '<leader>b', _G.cmd('Gitsigns toggle_current_line_blame'))

_G.map('n', '<leader>e', _G.cmd('Oil'))
_G.map('n', '<C-x>d', ':Oil ~/')

_G.map('n', '<leader>o', _G.cmd('ColorizerToggle'))

_G.map('n', '<leader>ff', _G.cmd('FzfLua files'))
_G.map('n', '<leader>fb', _G.cmd('FzfLua buffers'))
_G.map('n', '<leader>fc', _G.cmd('FzfLua command_history'))
_G.map('n', '<leader>fo', _G.cmd('FzfLua oldfiles'))
_G.map('n', '<leader>fs', _G.cmd('FzfLua lsp_document_symbols'))
_G.map('n', '<leader>fS', _G.cmd('FzfLua lsp_workspace_symbols'))
_G.map('n', '<leader>fh', _G.cmd('FzfLua helptags'))
_G.map('n', '<leader>fk', _G.cmd('FzfLua keymaps'))
_G.map('n', '<leader>ft', _G.cmd('FzfLua tabs'))
_G.map('n', '<leader>fd', _G.cmd('FzfLua lsp_workspace_diagnostics'))
_G.map('n', '<leader>fl', _G.cmd('FzfLua live_grep_native'))
_G.map('n', '<leader>/', _G.cmd('FzfLua grep_curbuf'))
_G.map('n', '<leader>fg', _G.cmd('FzfLua git_status'))
_G.map('n', '<leader>fr', _G.cmd('FzfLua lsp_reference'))
_G.map('n', '<leader>fq', _G.cmd('FzfLua quickfix_stack'))
_G.map('n', 'gh', _G.cmd('FzfLua lsp_finder'))
_G.map('n', '<leader>fw', _G.cmd('FzfLua grep_cword'))
