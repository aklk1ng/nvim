local map = vim.keymap.set

-- Useful undo break-point
map('i', ',', ',<C-g>u')
map('i', '.', '.<C-g>u')
map('i', ';', ';<C-g>u')

map(
  'i',
  '<C-x>t',
  [[<C-R>=repeat(complete(col('.'),map(["%Y-%m-%d %H:%M:%S","%a, %d %b %Y %H:%M:%S %z","%Y %b %d","%a %b %d %T %Z %Y","%Y%m%d"],'strftime(v:val)')+[localtime()]),0)<CR>]],
  { silent = true, noremap = true, desc = 'Provide formatted datetime in completion menu' }
)

-- Black hole registers
map({ 'n', 'x' }, 'x', '"_x')
map({ 'n', 'x' }, 'X', '"_X')
map({ 'n', 'x' }, 'c', '"_c')
map({ 'n', 'x' }, 'C', '"_C')
map({ 'n', 'x' }, 's', '"_s')
map({ 'n', 'x' }, 'S', '"_S')

map('n', '<C-x><C-f>', ":e <C-R>=expand('%:p:~:h')<CR>")
map('n', '<C-x>k', ':bdelete ')

map('n', '<leader>q', _G._cmd('q'))
map('n', '<C-x>c', _G._cmd('confirm qa'))
map('n', '|', _G._cmd('Inspect'))
map('n', 'j', 'gj')
map('n', 'k', 'gk')
map({ 'i', 'n', 'x', 's' }, '<C-s>', _G._cmd('silent! write') .. '<ESC>')
map('n', '<ESC>', _G._cmd('nohlsearch'))

map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')
map('n', '<A-[>', '<C-w><')
map('n', '<A-]>', '<C-w>>')
map('n', '<A-,>', '<C-w>-')
map('n', '<A-.>', '<C-w>+')
map('n', '<A-->', _G._cmd('resize | vertical resize'))
map('n', '<leader>tn', _G._cmd('tabnew'))
map('n', '<leader>ts', _G._cmd('tab split'))
map('n', '<leader>tc', _G._cmd('silent! tabclose'))
map('n', '<leader>d', _G._cmd(vim.bo.buftype == 'terminal' and 'q!' or 'Bdelete'))
map('n', '<C-q>', function()
  vim.diagnostic.setloclist({ title = vim.fn.expand('%') })
end)

map('i', '<C-k>', function()
  local pos = vim.api.nvim_win_get_cursor(0)
  local row = pos[1]
  local col = pos[2]
  local line = vim.api.nvim_get_current_line()
  local total_lines = vim.api.nvim_buf_line_count(0)
  local trimmed_line = line:gsub('%s+$', '')
  local killed_text = ''

  if col == 0 then
    if trimmed_line == '' then
      if row < total_lines then
        killed_text = '\n'
        local next_line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1] or ''
        vim.api.nvim_buf_set_lines(0, row - 1, row + 1, false, { next_line })
      end
    else
      killed_text = line
      vim.api.nvim_set_current_line('')
    end
  else
    if col < #trimmed_line then
      killed_text = line:sub(col + 1)
      vim.api.nvim_set_current_line(line:sub(1, col))
    else
      if row < total_lines then
        killed_text = '\n'
        local next_line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1] or ''
        vim.api.nvim_buf_set_lines(0, row - 1, row + 1, false, { line .. next_line })
      end
    end
  end

  if killed_text ~= '' then
    vim.fn.setreg('"', killed_text, 'v')
  end
end)

-- Move lines
map('x', '<A-j>', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv")
map('x', '<A-k>', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv")

local silent_mods = { mods = { silent = true, emsg_silent = true } }
map('n', '\\', function()
  if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
    vim.cmd.cclose(silent_mods)
  elseif #vim.fn.getqflist() > 0 then
    local win = vim.api.nvim_get_current_win()
    vim.cmd.copen(silent_mods)
    if win ~= vim.api.nvim_get_current_win() then
      vim.cmd.wincmd('p')
    end
  end
end, { desc = 'Toggle the quickfix window' })
map('n', '<C-\\>', function()
  if vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 then
    vim.cmd.lclose(silent_mods)
  elseif #vim.fn.getloclist(0) > 0 then
    local win = vim.api.nvim_get_current_win()
    vim.cmd.lopen(silent_mods)
    if win ~= vim.api.nvim_get_current_win() then
      vim.cmd.wincmd('p')
    end
  end
end, { desc = 'Toggle the location-list window' })

map({ 'n', 'i' }, '<A-/>', function()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  vim.cmd('normal! yyp')
  vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], col })
end, { desc = 'Duplicate one line and keep the cursor column position' })

map('i', '<C-l>', function()
  vim.cmd('normal! zz')
end)

-- Better indenting
map('x', '<', '<gv')
map('x', '>', '>gv')

map('n', 'gX', function()
  vim.ui.open(('https://google.com/search?q=%s'):format(vim.fn.expand('<cword>')))
end)
map('x', 'gX', function()
  local lines = vim.fn.getregion(vim.fn.getpos('.'), vim.fn.getpos('v'), { type = vim.fn.mode() })
  vim.ui.open(('https://google.com/search?q=%s'):format(vim.trim(table.concat(lines, ' '))))
  vim.api.nvim_input('<ESC>')
end)
map('n', 'gs', function()
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.fn.prompt_setprompt(bufnr, '')
  local width = math.floor(vim.o.columns * 0.5)
  local winid = vim.api.nvim_open_win(bufnr, true, {
    relative = 'editor',
    row = 5,
    col = math.floor(vim.o.columns / 2) - math.floor(width / 2),
    height = 4,
    width = width,
    border = 'single',
    title = 'Google Search',
    title_pos = 'center',
  })
  vim.cmd.startinsert()
  vim.bo[bufnr].buftype = 'prompt'
  vim.bo[bufnr].filetype = 'Scratch'
  vim.wo[winid].number = false
  vim.wo[winid].stc = ''
  vim.wo[winid].relativenumber = false
  vim.wo[winid].wrap = true
  vim.wo[winid].winhl = 'Normal:Normal'
  vim.fn.prompt_setcallback(bufnr, function(text)
    vim.ui.open(('https://google.com/search?q=%s'):format(vim.trim(text)))
    vim.api.nvim_win_close(winid, true)
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end)
  vim.keymap.set({ 'n', 'i' }, '<C-c>', function()
    vim.api.nvim_win_close(winid, true)
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end, { buffer = bufnr })
end)

map('n', 'yY', 'ggVGy', { desc = 'Copy entire file' })

map('s', '<BS>', '<C-O>s', { desc = 'Inside a snippet, use backspace to remove the placeholder' })

map('c', '<C-b>', '<Left>')
map('c', '<C-f>', '<Right>')
map('c', '<C-a>', '<Home>')
map('c', '<A-b>', '<C-Left>')
map('c', '<A-f>', '<C-Right>')
map('c', '<C-e>', '<End>')
map('c', '%c', "expand('%:p:~:h')", { desc = 'Cwd' })
map('c', '%p', "expand('%:p:~')", { desc = 'Full path' })
-- Terminal mappings
map('t', '<A-Esc>', '<C-\\><C-n>')
map('t', '<A-h>', '<C-\\><C-n><C-w>h')
map('t', '<A-j>', '<C-\\><C-n><C-w>j')
map('t', '<A-k>', '<C-\\><C-n><C-w>k')
map('t', '<A-l>', '<C-\\><C-n><C-w>l')

--===================================================================
------------------------------ Plugins ------------------------------
--===================================================================

map('n', '<leader>g', _G._cmd('Gitsigns diffthis vertical=true'))
map('n', ']c', function()
  if vim.wo.diff then
    vim.cmd.normal({ ']c', bang = true })
  else
    require('gitsigns').nav_hunk('next', { target = 'all' })
  end
end, { silent = true })
map('n', '[c', function()
  if vim.wo.diff then
    vim.cmd.normal({ '[c', bang = true })
  else
    require('gitsigns').nav_hunk('prev', { target = 'all' })
  end
end, { silent = true })
map('n', '<leader>b', _G._cmd('Gitsigns toggle_current_line_blame'))

map('n', '<leader>e', _G._cmd('Oil'))
map('n', '<C-x>d', ':e ~/')

map('n', '<leader>o', _G._cmd('ColorizerToggle'))

map('n', '<leader>ff', _G._cmd('FzfLua files'))
map('n', '<leader>fb', _G._cmd('FzfLua buffers'))
map('n', '<leader>fo', _G._cmd('FzfLua oldfiles'))
map('n', '<leader>fh', _G._cmd('FzfLua helptags'))
map('n', '<leader>fk', _G._cmd('FzfLua keymaps'))
map('n', '<leader>fm', _G._cmd('FzfLua manpages'))
map('n', '<leader>fd', _G._cmd('FzfLua lsp_document_diagnostics'))
map('n', '<leader>fD', _G._cmd('FzfLua lsp_workspace_diagnostics'))
map('n', '<leader>/', _G._cmd('FzfLua lgrep_curbuf'))
map('n', '<leader>fg', _G._cmd('FzfLua git_status'))
map('n', '<leader>fr', _G._cmd('FzfLua lsp_references'))
map('n', 'gh', _G._cmd('FzfLua lsp_finder'))
map('n', 'gp', _G._cmd('FzfLua lsp_definitions'))
map('n', '<leader>fw', _G._cmd('FzfLua grep_cword'))
