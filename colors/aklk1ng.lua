vim.api.nvim_command('hi clear')
vim.o.background = 'dark'
vim.o.termguicolors = true
vim.g.colors_name = 'aklk1ng'

local p = {
  bg = '#202325',
  shade_1 = '#24282b',
  shade_2 = '#323639',
  shade_3 = '#43484d',
  shade_4 = '#606c72',
  fg = '#8b8b8b',
  red = '#a35858',
  pink = '#946c81',
  orange = '#957157',
  yellow = '#93894e',
  green = '#6c8846',
  blue = '#537e96',
  cyan = '#6096a1',
  purple = '#746496',
  none = 'NONE',
}

local syntax = {
  Normal = { fg = p.fg, bg = p.bg },
  NormalNc = { link = 'Normal' },
  Cursor = { bg = p.shade_3 },
  lCursor = { link = 'Cursor' },
  SignColumn = { fg = p.fg, bg = p.bg },
  WinSeparator = { fg = p.shade_4 },
  Folded = { fg = p.fg, bg = p.shade_1 },
  EndOfBuffer = { fg = p.bg, bg = p.none },
  Search = { fg = p.bg, bg = p.yellow },
  CurSearch = { fg = p.bg, bg = p.orange },
  ColorColumn = { link = 'CursorLine' },
  Conceal = { fg = p.fg, bg = p.none },
  CursorColumn = { link = 'CursorLine' },
  FoldColumn = { fg = p.shade_2 },
  CursorLineFold = { fg = p.yellow },
  CursorLine = { bg = p.shade_1 },
  LineNr = { fg = p.shade_2 },
  CursorLineNr = { fg = p.fg },
  Added = { fg = p.green },
  Changed = { fg = p.blue },
  Removed = { fg = p.red },
  DiffAdd = { fg = p.green },
  DiffChange = { fg = p.blue },
  DiffDelete = { fg = p.red },
  DiffText = { fg = p.orange },
  Directory = { fg = p.blue, bg = p.none },
  ErrorMsg = { link = 'Error' },
  Error = { fg = p.red, bold = true },
  ModeMsg = { fg = p.fg },
  MoreMsg = { fg = p.fg },
  QuickFixLine = { bold = true },
  qfLineNr = { fg = p.fg },
  WarningMsg = { fg = p.yellow, bg = p.none, bold = true },
  MatchParen = { fg = p.pink, bg = p.shade_3, bold = true },
  Whitespace = { fg = p.shade_3 },
  SpecialKey = { fg = p.fg },
  Pmenu = { bg = p.shade_1 },
  PmenuKind = { fg = p.yellow, bg = p.shade_1 },
  PmenuSel = { bg = p.shade_2 },
  PmenuMatch = { fg = p.green },
  PmenuSbar = { bg = p.shade_1 },
  PmenuThumb = { link = 'PmenuSbar' },
  WildMenu = { link = 'Pmenu' },
  WinBar = { link = 'StatusLine' },
  WinBarNC = { link = 'StatusLineNC' },
  TabLine = { fg = p.shade_4 },
  StatusLine = { bg = p.bg },
  StatusLineNC = { bg = p.bg },
  NormalFloat = { fg = p.fg },
  FloatBorder = { fg = p.fg },
  Visual = { bg = p.shade_2 },
  Boolean = { fg = p.orange },
  Number = { fg = p.pink },
  Todo = { fg = p.pink, bold = true },
  Float = { link = 'Number' },
  FloatTitle = { link = 'Title' },
  FloatFooter = { link = 'FloatTitle' },
  Constant = { fg = p.pink },
  PreProc = { fg = p.fg },
  PreCondit = { fg = p.pink },
  Define = { fg = p.purple },
  Conditional = { fg = p.purple },
  Repeat = { fg = p.purple },
  Keyword = { fg = p.purple },
  Exception = { link = 'Conditional' },
  Statement = { fg = p.purple },
  StorageClass = { fg = p.orange },
  Tag = { fg = p.orange },
  Label = { fg = p.purple },
  Structure = { fg = p.orange },
  Operator = { fg = p.fg },
  Title = { fg = p.orange, bold = true },
  Special = { fg = p.yellow },
  Function = { fg = p.blue },
  String = { fg = p.green },
  Character = { link = 'String' },
  Type = { fg = p.yellow },
  Typedef = { link = 'Type' },
  Identifier = { fg = p.yellow },
  Comment = { fg = p.shade_4 },
  Delimiter = { fg = p.fg },

  DiagnosticError = { fg = p.red },
  DiagnosticWarn = { fg = p.yellow },
  DiagnosticInfo = { fg = p.blue },
  DiagnosticHint = { fg = p.cyan },
  DiagnosticOk = { fg = p.green },
  DiagnosticSignError = { link = 'DiagnosticError' },
  DiagnosticSignWarn = { link = 'DiagnosticWarn' },
  DiagnosticSignInfo = { link = 'DiagnosticInfo' },
  DiagnosticSignHint = { link = 'DiagnosticHint' },
  DiagnosticSignOk = { link = 'DiagnosticOk' },
  DiagnosticUnderlineError = { undercurl = true },
  DiagnosticUnderlineWarn = { undercurl = true },
  DiagnosticUnderlineInfo = { undercurl = true },
  DiagnosticUnderlineHint = { undercurl = true },
  DiagnosticUnderlineOk = { undercurl = true },
  LspInlayHint = { fg = p.shade_4 },
  LspSignatureActiveParameter = { bg = p.shade_2 },

  NotifyDebug = { fg = p.purple },
  NotifyError = { fg = p.red },
  NotifyInfo = { fg = p.blue },
  NotifyTrace = { fg = p.cyan },
  NotifyWarn = { fg = p.yellow },
  NotifyOff = { fg = p.fg },

  -- nvim-treesitter
  ['@function'] = { fg = p.fg },
  ['@function.builtin'] = { link = '@function' },
  ['@method'] = { link = '@function' },
  ['@property'] = { link = '@variable' },
  ['@type.qualifier'] = { fg = p.green },
  ['@type.builtin'] = { link = 'Type' },
  ['@variable'] = { fg = p.fg },
  ['@variable.builtin'] = { link = '@variable' },
  ['@variable.parameter.builtin'] = { link = 'Special' },
  ['@punctuation.bracket'] = { link = 'Delimiter' },
  ['@punctuation.delimiter'] = { link = 'Delimiter' },
  ['@punctuation.special'] = { link = 'Delimiter' },
  ['@constructor'] = { link = 'Function' },
  ['@namespace'] = { fg = p.fg },
  ['@module'] = { fg = p.fg },
  ['@attribute'] = { link = 'Special' },
  ['@markup.raw.block.markdown'] = { link = 'Comment' },
  ['@text.title'] = { fg = p.orange },
  ['@markup.strong.markdown_inline'] = { fg = p.orange },
  ['@markup.list.unchecked.markdown'] = { fg = p.pink },

  -- LSP Semantic Token
  ['@lsp.type.variable'] = { link = '@variable' },
  ['@lsp.type.operator'] = { link = 'Operator' },
  ['@lsp.type.parameter'] = { link = '@variable' },
  ['@lsp.type.builtinType'] = { link = 'Type' },
  ['@lsp.type.property'] = { link = '@variable' },
  ['@lsp.type.decorator'] = { link = '@attribute' },
  ['@lsp.type.escapeSequence'] = { link = '@string.escape' },
  ['@lsp.type.formatSpecifier'] = { link = '@punctuation.special' },
  ['@lsp.type.generic'] = { link = '@variable' },
  ['@lsp.type.unresolvedReference'] = { undercurl = true },
  ['@lsp.type.selfTypeKeyword'] = { link = '@variable' },
  ['@lsp.typemod.enumMember.defaultLibrary'] = { link = 'Special' },
  ['@lsp.typemod.struct.defaultLibrary'] = { link = 'Type' },
  ['@lsp.typemod.variable.declaration'] = { link = '@variable' },
  ['@lsp.typemod.variable.callable'] = { link = 'Function' },
  ['@lsp.typemod.variable.static'] = { link = 'Constant' },

  -- nvim-cmp
  CmpItemAbbrMatch = { link = 'PmenuMatch' },
  CmpItemAbbrDeprecated = { strikethrough = true },

  -- treesitter-context
  TreesitterContext = { bg = p.shade_1 },

  -- fzf-lua
  FzfLuaBufNr = { fg = p.fg },
  FzfLuaBufName = { fg = p.blue },
  FzfLuaTabTitle = { fg = p.purple },
  FzfLuaTabMarker = { fg = p.green },
  FzfLuaBufFlagCur = { fg = p.red },
  FzfLuaBufFlagAlt = { fg = p.yellow },
  FzfLuaPathColNr = { fg = p.green },
  FzfLuaPathLineNr = { fg = p.pink },
  FzfLuaHeaderBind = { fg = p.orange },
  FzfLuaHeaderText = { fg = p.red },
}

for group, conf in pairs(syntax) do
  vim.api.nvim_set_hl(0, group, conf)
end
