vim.api.nvim_command('hi clear')
vim.o.background = 'dark'
vim.o.termguicolors = true
vim.g.colors_name = 'aklk1ng'

local M = {
  bg = '#151521',
  base1 = '#34383c',
  base2 = '#4f575e',
  base3 = '#73767a',
  bg_highlight = '#1f232d',
  fg = '#9d9da2',
  fg_alt = '#949494',
  red = '#de7e7e',
  pink = '#aa8383',
  orange = '#aa7654',
  yellow = '#919062',
  green = '#879e65',
  cyan = '#759ea4',
  blue = '#6b9289',
  purple = '#8e91af',
  grey = '#8a8a8a',
  fancy = '#9b875d',
  galaxy = '#82796a',
  none = 'NONE',
}

function M.terminal_color()
  vim.g.terminal_color_0 = M.bg
  vim.g.terminal_color_1 = M.red
  vim.g.terminal_color_2 = M.green
  vim.g.terminal_color_3 = M.yellow
  vim.g.terminal_color_4 = M.blue
  vim.g.terminal_color_5 = M.pink
  vim.g.terminal_color_6 = M.cyan
  vim.g.terminal_color_7 = M.fg
  vim.g.terminal_color_8 = M.grey
  vim.g.terminal_color_9 = M.red
  vim.g.terminal_color_10 = M.green
  vim.g.terminal_color_11 = M.yellow
  vim.g.terminal_color_12 = M.blue
  vim.g.terminal_color_13 = M.pink
  vim.g.terminal_color_14 = M.cyan
  vim.g.terminal_color_15 = M.fg
end

local syntax = {
  Normal = { fg = M.fg, bg = M.bg },
  Terminal = { fg = M.fg, bg = M.bg },
  SignColumn = { fg = M.fg, bg = M.bg },
  WinSeparator = { fg = M.base1, bg = M.bg },
  Folded = { fg = M.green, bg = M.bg_highlight },
  EndOfBuffer = { fg = M.bg, bg = M.none },
  Search = { fg = M.bg, bg = M.yellow },
  CurSearch = { link = 'Search' },
  ColorColumn = { bg = M.bg_highlight },
  Conceal = { fg = M.fg_alt, bg = M.none },
  CursorColumn = { link = 'CursorLine' },
  FoldColumn = { fg = M.base3 },
  CursorLine = { bg = M.bg_highlight },
  LineNr = { fg = M.base1 },
  CursorLineNr = { fg = M.grey },
  DiffAdd = { fg = M.green, bg = M.base1 },
  DiffChange = { fg = M.blue, bg = M.base1 },
  DiffDelete = { fg = M.red, bg = M.base1 },
  DiffText = { fg = M.orange, bg = M.base1 },
  Directory = { fg = M.blue, bg = M.none },
  ErrorMsg = { fg = M.red, bg = M.none, bold = true },
  WarningMsg = { fg = M.yellow, bg = M.none, bold = true },
  MatchParen = { fg = M.pink, bg = M.base2, bold = true },
  NonText = { link = 'Comment' },
  Whitespace = { fg = M.base1 },
  SpecialKey = { fg = M.grey },
  Pmenu = { fg = M.fg_alt, bg = M.bg_highlight },
  PmenuKind = { fg = M.blue, bg = M.bg_highlight },
  PmenuSel = { fg = M.bg, bg = M.blue },
  PmenuSbar = { bg = M.bg_highlight },
  PmenuThumb = { link = 'PmenuSbar' },
  WildMenu = { link = 'Pmenu' },
  StatusLine = { bg = M.bg },
  StatusLineNC = { bg = M.bg },
  NormalFloat = { fg = M.grey },
  FloatBorder = { fg = M.grey },
  Visual = { bg = M.base1 },
  Boolean = { fg = M.orange },
  Number = { fg = M.purple },
  Float = { link = 'Number' },
  Constant = { fg = M.pink },
  PreProc = { fg = M.pink },
  PreCondit = { fg = M.pink },
  Include = { fg = M.pink },
  Define = { fg = M.purple },
  Conditional = { fg = M.pink },
  Repeat = { fg = M.purple },
  Keyword = { fg = M.pink },
  Typedef = { link = 'Type' },
  Exception = { link = 'Conditional' },
  Statement = { fg = M.purple },
  Error = { fg = M.red },
  StorageClass = { fg = M.orange },
  Tag = { fg = M.orange },
  Label = { fg = M.purple },
  Structure = { fg = M.orange },
  Operator = { fg = M.grey },
  Title = { fg = M.orange, bold = true },
  Special = { fg = M.fancy },
  Function = { fg = M.blue },
  String = { fg = M.green },
  Character = { link = 'String' },
  Type = { fg = M.fancy },
  Identifier = { fg = M.blue },
  Comment = { fg = M.base3 },
  Todo = { fg = M.pink },

  ['@function.builtin'] = { link = 'Function' },
  ['@parameter'] = { link = '@variable' },
  ['@method'] = { link = 'Function' },
  ['@keyword.function'] = { fg = M.purple },
  ['@keyword.operator'] = { fg = M.pink },
  ['@keyword.return'] = { link = 'Repeat' },
  ['@property'] = { link = '@field' },
  ['@field'] = { fg = M.yellow },
  ['@type.qualifier'] = { fg = M.green },
  ['@variable'] = { fg = M.fg_alt },
  ['@variable.builtin'] = { link = '@variable' },
  ['@punctuation.bracket'] = { fg = M.grey },
  ['@punctuation.delimiter'] = { fg = M.grey },
  ['@punctuation.special'] = { fg = M.grey },
  ['@text.literal'] = { fg = M.green },
  ['@text.strong'] = { fg = M.pink },
  ['@constructor'] = { link = 'Function' },
  ['@namespace'] = { fg = M.green },
  ['@attribute'] = { link = '@field' },
  ['@comment.documentation'] = { fg = M.galaxy },
  ['@text.title'] = { link = 'Title' },
  ['@text.title.1'] = { fg = M.orange, bold = true },
  ['@text.title.2'] = { fg = M.yellow, bold = true },
  ['@text.title.3'] = { fg = M.green, bold = true },
  ['@text.title.4'] = { fg = M.galaxy, bold = true },
  ['@text.title.5'] = { fg = M.blue, bold = true },
  ['@text.title.6'] = { fg = M.purple, bold = true },

  GitSignsAdd = { fg = M.green },
  GitSignsChange = { fg = M.blue },
  GitSignsDelete = { fg = M.red },

  DiagnosticError = { fg = M.red },
  DiagnosticWarn = { fg = M.yellow },
  DiagnosticInfo = { fg = M.blue },
  DiagnosticHint = { fg = M.green },
  DiagnosticSignError = { link = 'DiagnosticError' },
  DiagnosticSignWarn = { link = 'DiagnosticWarn' },
  DiagnosticSignInfo = { link = 'DiagnosticInfo' },
  DiagnosticSignHint = { link = 'DiagnosticHint' },
  DiagnosticUnderlineError = { undercurl = true },
  DiagnosticUnderlineWarn = { undercurl = true },
  DiagnosticUnderlineInfo = { undercurl = true },
  DiagnosticUnderlineHint = { undercurl = true },

  -- Telescope
  TelescopeSelection = { fg = M.yellow, bg = M.bg_highlight, bold = true },
  TelescopePromptTitle = { fg = M.bg, bg = M.blue },
  TelescopePromptBorder = { fg = M.bg, bg = M.bg },
  TelescopeResultsBorder = { fg = M.bg, bg = M.bg },
  TelescopeResultsTitle = { fg = M.bg, bg = M.pink },
  TelescopePreviewBorder = { fg = M.bg, bg = M.bg },
  TelescopePreviewTitle = { fg = M.bg, bg = M.purple },
  -- nvim-cmp
  CmpItemAbbr = { fg = M.fg },
  CmpItemAbbrMatch = { fg = M.green },
  CmpDoc = { link = 'Pmenu' },
  CmpItemKindKeyword = { link = 'Keyword' },
  CmpItemKindFunction = { link = 'Function' },
  CmpItemKindMethod = { link = 'Function' },
  CmpItemKindModule = { fg = M.cyan },
  CmpItemKindVariable = { link = '@variable' },
  CmpItemKindField = { link = '@field' },

  CursorWord = { bg = M.base1 },
  LspInlayHint = { link = 'Comment' },
  IndentLine = { fg = M.base1 },
}

local set_hl = function(tbl)
  for group, conf in pairs(tbl) do
    vim.api.nvim_set_hl(0, group, conf)
  end
end

set_hl(syntax)
M.terminal_color()
