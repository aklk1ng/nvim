---@diagnostic disable-next-line: duplicate-set-field
vim.ui.select = function(items, opts, on_choice)
  local ui_select = require('fzf-lua.providers.ui_select')

  if not ui_select.is_registered() then
    ui_select.register()
  end

  if #items > 0 then
    return vim.ui.select(items, opts, on_choice)
  end
end

local actions = require('fzf-lua.actions')
require('fzf-lua').setup({
  {
    'max-perf',
    'ivy',
  },
  winopts = {
    height = 0.60,
    backdrop = 100,
    title_flags = false,
    preview = {
      horizontal = 'right:50%',
    },
  },
  keymap = {
    builtin = {
      false,
      ['<F1>'] = 'toggle-help',
    },
    fzf = {
      false,
    },
  },
  actions = {
    files = {
      false,
      ['enter'] = actions.file_edit,
      ['ctrl-s'] = actions.file_split,
      ['ctrl-v'] = actions.file_vsplit,
      ['ctrl-t'] = actions.file_tabedit,
      ['ctrl-q'] = actions.file_sel_to_ll,
    },
  },
  git = {
    bcommits = {
      prompt = 'Logs:',
      actions = {
        ['ctrl-]'] = function(...)
          local curwin = vim.api.nvim_get_current_win()
          actions.git_buf_vsplit(...)
          vim.cmd('windo diffthis')
          vim.api.nvim_set_current_win(curwin)
        end,
      },
    },
  },
  lsp = {
    async_or_timeout = true,
    includeDeclaration = false,
    code_actions = {
      winopts = {
        preview = {
          layout = 'horizontal',
          horizontal = 'up:55%',
        },
      },
    },
    finder = {
      providers = {
        { 'references', prefix = require('fzf-lua').utils.ansi_codes.blue('ref ') },
        { 'definitions', prefix = require('fzf-lua').utils.ansi_codes.green('def ') },
        { 'implementations', prefix = require('fzf-lua').utils.ansi_codes.green('impl') },
        { 'typedefs', prefix = require('fzf-lua').utils.ansi_codes.red('tdef') },
      },
    },
    symbols = { symbol_style = 3 },
  },
  diagnostics = {
    diag_source = false,
    diag_code = false,
  },
})

vim.keymap.set('n', '<leader>ff', _G._cmd('FzfLua files'))
vim.keymap.set('n', '<leader>fb', _G._cmd('FzfLua buffers'))
vim.keymap.set('n', '<leader>fo', _G._cmd('FzfLua oldfiles'))
vim.keymap.set('n', '<leader>fh', _G._cmd('FzfLua helptags'))
vim.keymap.set('n', '<leader>fk', _G._cmd('FzfLua keymaps'))
vim.keymap.set('n', '<leader>fm', _G._cmd('FzfLua manpages'))
vim.keymap.set('n', '<leader>fs', _G._cmd('FzfLua lsp_document_symbols'))
vim.keymap.set('n', '<leader>fd', _G._cmd('FzfLua lsp_document_diagnostics'))
vim.keymap.set('n', '<leader>fD', _G._cmd('FzfLua lsp_workspace_diagnostics'))
vim.keymap.set('n', '<leader>fl', _G._cmd('FzfLua live_grep'))
vim.keymap.set('n', '<leader>/', _G._cmd('FzfLua lgrep_curbuf'))
vim.keymap.set('n', '<leader>fg', _G._cmd('FzfLua git_status'))
vim.keymap.set('n', 'gh', _G._cmd('FzfLua lsp_finder'))
vim.keymap.set('n', '<leader>fw', _G._cmd('FzfLua grep_cword'))
