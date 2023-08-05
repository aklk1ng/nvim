local keymap = require('keymap')
local opt = keymap.default_opt
local cmd = keymap.cmd
local wait_cmd = keymap.wait_cmd
local map = keymap.map

map({
  { 'n', '<leader><leader>i', cmd('Lazy'), opt },
  { 'n', ';r', cmd('LspRestart'), opt },
  { 'n', ';d', cmd('Gitsigns diffthis'), opt },
  { 'n', '<leader><leader>p', cmd('Gitsigns preview_hunk'), opt },
  { 'n', ';n', cmd('Gitsigns next_hunk'), opt },
  { 'n', ';p', cmd('Gitsigns prev_hunk'), opt },
  { 'n', ';b', cmd('Gitsigns toggle_current_line_blame'), opt },

  { 'n', ';h', cmd('TSHighlightCapturesUnderCursor'), opt },
  { 'n', '<leader>f', cmd('GuardFmt'), opt },
  { 'n', '<leader>ci', cmd('CompetiTest receive testcases'), opt },
  { 'n', '<leader>cr', cmd('CompetiTest run'), opt },
  { 'n', '<leader>cd', cmd('CompetiTest delete_testcase'), opt },
  { 'n', '<leader>cc', cmd('!rm ./%<'), opt },

  { 'n', ';s', wait_cmd('SessionSave '), opt },
  { 'n', ';l', wait_cmd('SessionLoad '), opt },
  { 'n', ';D', wait_cmd('SessionDelete '), opt },
  { 'n', '[n', cmd('Lspsaga diagnostic_jump_next'), opt },
  { 'n', ']n', cmd('Lspsaga diagnostic_jump_prev'), opt },
  {
    'n',
    '[e',
    cmd('lua require("lspsaga.diagnostic"):goto_prev({severity = vim.diagnostic.severity.ERROR})'),
    opt,
  },
  {
    'n',
    ']e',
    cmd('lua require("lspsaga.diagnostic"):goto_next({severity = vim.diagnostic.severity.ERROR})'),
    opt,
  },
  { 'n', '<leader>L', cmd('Lspsaga show_line_diagnostics'), opt },
  { 'n', ';t', cmd('Lspsaga hover_doc'), opt },
  { 'n', ',,', cmd('Lspsaga hover_doc ++keep'), opt },
  { 'n', '<Leader>ic', cmd('Lspsaga incoming_calls'), opt },
  { 'n', '<Leader>oc', cmd('Lspsaga outgoing_calls'), opt },
  { 'n', 'gh', cmd('Lspsaga finder'), opt },
  { 'n', 'gd', cmd('Lspsaga goto_definition'), opt },
  { 'n', 'gt', '<cmd>Lspsaga goto_type_definition<CR>' },
  { { 'n', 'v' }, '<leader>ca', cmd('Lspsaga code_action'), opt },
  { 'n', 'gp', cmd('Lspsaga peek_definition'), opt },
  { 'n', '<leader>rn', cmd('Lspsaga rename'), opt },
  { 'n', 'gr', cmd('Lspsaga rename ++project'), opt },
  { 'n', '<leader>o', cmd('Lspsaga outline'), opt },

  { 'n', '<leader>ff', cmd('Telescope find_files'), opt },
  { 'n', '<leader>fb', cmd('Telescope buffers'), opt },
  { 'n', '<leader>fc', cmd('Telescope command_history'), opt },
  { 'n', '<leader>fC', cmd('Telescope commands'), opt },
  { 'n', '<leader>fo', cmd('Telescope oldfiles'), opt },
  { 'n', '<leader>fs', cmd('Telescope lsp_document_symbols'), opt },
  { 'n', '<leader>fS', cmd('Telescope lsp_workspace_symbols'), opt },
  { 'n', '<leader>fa', cmd('Telescope lsp_code_actions'), opt },
  { 'n', '<leader>fd', cmd('Telescope diagnostics'), opt },
  { 'n', '<leader>fk', cmd('Telescope keymaps'), opt },
  { 'n', '<leader>fw', cmd('Telescope live_grep'), opt },
  { 'n', '<leader>fe', cmd('Telescope emoji'), opt },

  { 'n', '<leader>co', cmd('ColorizerToggle'), opt },
})
