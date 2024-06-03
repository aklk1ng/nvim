_G.map('n', '<leader>g', _G.cmd('Gitsigns diffthis'))
_G.map('n', ']g', _G.cmd('silent! Gitsigns next_hunk'), { silent = true })
_G.map('n', '[g', _G.cmd('silent! Gitsigns prev_hunk'), { silent = true })
_G.map('n', '<leader>b', _G.cmd('Gitsigns toggle_current_line_blame'))

_G.map('n', '<leader>e', _G.cmd('lua MiniFiles.open()'))

_G.map('n', '<leader>cf', _G.cmd('GuardFmt'))

_G.map('n', '<leader>a', _G.cmd('ColorizerToggle'))

_G.map('n', '<leader>m', _G.cmd('RenderMarkdownToggle'))

_G.map('n', 'zp', function()
  require('ufo').peekFoldedLinesUnderCursor()
end)

_G.map('n', ']d', _G.cmd('Lspsaga diagnostic_jump_next'))
_G.map('n', '[d', _G.cmd('Lspsaga diagnostic_jump_prev'))
_G.map(
  'n',
  '[e',
  _G.cmd("lua require('lspsaga.diagnostic'):goto_next({severity = vim.diagnostic.severity.ERROR})")
)
_G.map(
  'n',
  ']e',
  _G.cmd("lua require('lspsaga.diagnostic'):goto_prev({severity = vim.diagnostic.severity.ERROR})")
)
_G.map('n', 'K', _G.cmd('Lspsaga hover_doc'))
_G.map('n', 'gh', _G.cmd('Lspsaga finder'))
_G.map('n', 'gd', _G.cmd('Lspsaga goto_definition'))
_G.map('n', 'ga', _G.cmd('Lspsaga code_action'))
_G.map('n', 'gp', _G.cmd('Lspsaga peek_definition'))
_G.map('n', 'gr', _G.cmd('Lspsaga rename'))
_G.map('n', '<leader>o', _G.cmd('Lspsaga outline'))
_G.map('n', '<leader>rn', _G.cmd('Lspsaga rename ++project'))

_G.map('n', '<leader>ff', _G.cmd('Telescope find_files find_command=rg,--ignore,--hidden,--files'))
_G.map('n', '<leader>fb', _G.cmd('Telescope buffers'))
_G.map('n', '<leader>fc', _G.cmd('Telescope command_history'))
_G.map('n', '<leader>fo', _G.cmd('Telescope oldfiles'))
_G.map('n', '<leader>fs', _G.cmd('Telescope lsp_document_symbols'))
_G.map('n', '<leader>fS', _G.cmd('Telescope lsp_workspace_symbols'))
_G.map('n', '<leader>fd', _G.cmd('Telescope diagnostics bufnr=0'))
_G.map('n', '<leader>fD', _G.cmd('Telescope diagnostics'))
_G.map('n', '<leader>fh', _G.cmd('Telescope help_tags'))
_G.map('n', '<leader>fk', _G.cmd('Telescope keymaps'))
_G.map('n', '<leader>fw', _G.cmd('Telescope live_grep'))
_G.map('n', '<leader>fg', _G.cmd('Telescope git_status'))
_G.map('n', '<leader>fr', _G.cmd('Telescope lsp_references'))
_G.map('n', '<leader>fW', function()
  -- word under cursor
  local word = vim.fn.expand('<cword>')
  local builtin = require('telescope.builtin')
  builtin.grep_string({ search = word })
end)
