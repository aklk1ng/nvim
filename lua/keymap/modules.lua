local map = require('keymap')
local cmd = map.cmd

map.n({
  ['<leader>g'] = cmd('Gitsigns diffthis'),
  ['<leader><leader>p'] = cmd('Gitsigns preview_hunk'),
  [';n'] = cmd('Gitsigns next_hunk<CR>'),
  [';p'] = cmd('Gitsigns prev_hunk<CR>'),
  ['<leader>b'] = cmd('Gitsigns toggle_current_line_blame'),

  ['<leader>f'] = cmd('GuardFmt'),

  ['<leader>e'] = cmd('lua MiniFiles.open()'),

  ['<leader>a'] = cmd('ColorizerToggle'),

  ['[n'] = cmd('Lspsaga diagnostic_jump_next'),
  [']n'] = cmd('Lspsaga diagnostic_jump_prev'),
  ['[e'] = cmd(
    'lua require("lspsaga.diagnostic"):goto_prev({severity = vim.diagnostic.severity.ERROR})'
  ),
  [']e'] = cmd(
    'lua require("lspsaga.diagnostic"):goto_next({severity = vim.diagnostic.severity.ERROR})'
  ),
  [';h'] = cmd('Lspsaga hover_doc'),
  [',,'] = cmd('Lspsaga hover_doc ++keep'),
  ['gh'] = cmd('Lspsaga finder'),
  ['gd'] = cmd('Lspsaga goto_definition'),
  ['ga'] = cmd('Lspsaga code_action'),
  ['gp'] = cmd('Lspsaga peek_definition'),
  ['gr'] = cmd('Lspsaga rename'),
  ['<leader>rn'] = cmd('Lspsaga rename ++project'),

  [';f'] = cmd('Telescope find_files find_command=rg,--ignore,--hidden,--files'),
  [';b'] = cmd('Telescope buffers'),
  [';c'] = cmd('Telescope command_history'),
  [';o'] = cmd('Telescope oldfiles'),
  [';s'] = cmd('Telescope lsp_document_symbols'),
  ['<leader>o'] = cmd('Telescope lsp_document_symbols symbols=function'),
  [';S'] = cmd('Telescope lsp_workspace_symbols'),
  [';d'] = cmd('Telescope diagnostics bufnr=0'),
  [';D'] = cmd('Telescope diagnostics'),
  [';;'] = cmd('Telescope help_tags'),
  [';k'] = cmd('Telescope keymaps'),
  [';w'] = cmd('Telescope live_grep'),
  [';g'] = cmd('Telescope git_status'),
  [';r'] = cmd('Telescope lsp_references'),
  [';W'] = function()
    -- word under cursor
    local word = vim.fn.expand('<cword>')
    local builtin = require('telescope.builtin')
    builtin.grep_string({ search = word })
  end,
  [';t'] = cmd("lua require('telescope-tabs').list_tabs()"),
})
