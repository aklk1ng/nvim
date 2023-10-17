local keymap = require('keymap')
local opt = keymap.default_opt
local cmd = keymap.cmd
local map = keymap.map

map({
  { 'n', '<leader><leader>i', cmd('Lazy'), opt },
  { 'n', ';d', cmd('Gitsigns diffthis'), opt },
  { 'n', '<leader><leader>p', cmd('Gitsigns preview_hunk'), opt },
  { 'n', ';n', cmd('Gitsigns next_hunk'), opt },
  { 'n', ';p', cmd('Gitsigns prev_hunk'), opt },
  { 'n', ';b', cmd('Gitsigns toggle_current_line_blame'), opt },

  { 'n', ';h', cmd('TSHighlightCapturesUnderCursor'), opt },
  { 'n', '<leader>f', cmd('GuardFmt'), opt },

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
  { 'n', '<leader>ca', cmd('Lspsaga code_action'), opt },
  { 'n', 'gp', cmd('Lspsaga peek_definition'), opt },
  { 'n', '<leader>rn', cmd('Lspsaga rename'), opt },
  { 'n', 'gr', cmd('Lspsaga rename ++project'), opt },
  { 'n', '<leader>o', cmd('Lspsaga outline'), opt },

  { 'n', ';ff', cmd('Telescope find_files'), opt },
  { 'n', ';fb', cmd('Telescope buffers'), opt },
  { 'n', ';fc', cmd('Telescope command_history'), opt },
  { 'n', ';fC', cmd('Telescope commands'), opt },
  { 'n', ';fo', cmd('Telescope oldfiles'), opt },
  { 'n', ';fs', cmd('Telescope lsp_document_symbols'), opt },
  { 'n', ';fS', cmd('Telescope lsp_workspace_symbols'), opt },
  { 'n', ';fa', cmd('Telescope lsp_code_actions'), opt },
  { 'n', ';fd', cmd('Telescope diagnostics'), opt },
  { 'n', ';fk', cmd('Telescope keymaps'), opt },
  { 'n', ';fw', cmd('Telescope live_grep'), opt },

  { 'n', '<leader>co', cmd('ColorizerToggle'), opt },
  {
    'n',
    '<leader>R',
    require('utils.api.quickrun').asyncrun,
    opt,
  },
  {
    'n',
    'zp',
    function()
      require('ufo').peekFoldedLinesUnderCursor()
    end,
    opt,
  },
})
