local map = require('keymap')
local cmd = map.cmd

map.n({
  [';g'] = cmd('Gitsigns diffthis'),
  ['<leader><leader>p'] = cmd('Gitsigns preview_hunk'),
  [';n'] = cmd('Gitsigns next_hunk<CR>'),
  [';p'] = cmd('Gitsigns prev_hunk<CR>'),
  ['<leader>b'] = cmd('Gitsigns toggle_current_line_blame'),

  ['<leader>f'] = cmd('GuardFmt'),

  [';t'] = cmd('UndotreeToggle'),

  ['<leader>t'] = function()
    if not _G.MiniFiles then
      require('mini.files').setup()
    end
    _G.MiniFiles.open()
  end,
  ['<leader>co'] = function()
    if not _G.MiniHipatterns then
      require('modules.tools').hipatterns()
    end
    _G.MiniHipatterns.toggle()
  end,

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
  ['<Leader>ic'] = cmd('Lspsaga incoming_calls'),
  ['<Leader>oc'] = cmd('Lspsaga outgoing_calls'),
  ['gh'] = cmd('Lspsaga finder'),
  ['gd'] = cmd('Lspsaga goto_definition'),
  ['gt'] = cmd('Lspsaga goto_type_definition'),
  ['ga'] = cmd('Lspsaga code_action'),
  ['gp'] = cmd('Lspsaga peek_definition'),
  ['gr'] = cmd('Lspsaga rename'),
  ['<leader>rn'] = cmd('Lspsaga rename ++project'),
  ['<leader>o'] = cmd('Lspsaga outline'),

  [';f'] = cmd('Telescope find_files'),
  [';b'] = cmd('Telescope buffers'),
  [';c'] = cmd('Telescope command_history'),
  [';C'] = cmd('Telescope commands'),
  [';o'] = cmd('Telescope oldfiles'),
  [';s'] = cmd('Telescope lsp_document_symbols'),
  [';S'] = cmd('Telescope lsp_workspace_symbols'),
  [';d'] = cmd('Telescope diagnostics bufnr=0'),
  [';D'] = cmd('Telescope diagnostics'),
  [';;'] = cmd('Telescope help_tags'),
  [';k'] = cmd('Telescope keymaps'),
  [';w'] = cmd('Telescope live_grep'),
  [';r'] = cmd('lua require("telescope.builtin").lsp_references()'),
  [';W'] = function()
    -- word under cursor
    local word = vim.fn.expand('<cword>')
    local builtin = require('telescope.builtin')
    builtin.grep_string({ search = word })
  end,
})
