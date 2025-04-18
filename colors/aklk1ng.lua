vim.api.nvim_command('hi clear')
vim.o.background = 'dark'
vim.o.termguicolors = true
vim.g.colors_name = 'aklk1ng'

local p = {
  bg = '#1d1f20',
  shade_1 = '#262626',
  shade_2 = '#313538',
  shade_3 = '#43484d',
  shade_4 = '#6a7073',
  fg = '#919191',
  red = '#a35858',
  pink = '#946c81',
  orange = '#957157',
  yellow = '#918754',
  green = '#6c8846',
  blue = '#527e91',
  cyan = '#6096a1',
  purple = '#7a6b98',
  difftext = '#364427',
  diffadd = '#304854',
  diffdel = '#743f4d',
  none = 'NONE',
}

---@type table<string, vim.api.keyset.highlight>
local syntax = {
  Normal = { fg = p.fg, bg = p.bg },
  NormalNc = { link = 'Normal' },
  SignColumn = { fg = p.fg, bg = p.bg },
  WinSeparator = { fg = p.shade_4 },
  Folded = { fg = p.fg, bg = p.shade_1 },
  EndOfBuffer = { fg = p.bg },
  Search = { fg = p.bg, bg = p.fg },
  CurSearch = { fg = p.bg, bg = p.yellow },
  ColorColumn = { bg = p.shade_1 },
  Conceal = { fg = p.shade_4 },
  CursorColumn = { link = 'CursorLine' },
  CursorLineFold = { fg = p.yellow },
  CursorLine = { bg = p.none },
  LineNr = { fg = p.shade_3 },
  FoldColumn = { link = 'LineNr' },
  CursorLineNr = { fg = p.fg },
  Added = { fg = p.green },
  Changed = { fg = p.blue },
  Removed = { fg = p.red },
  DiffAdd = { bg = p.diffadd },
  DiffChange = {},
  DiffDelete = { bg = p.diffdel },
  DiffText = { bg = p.difftext },
  Directory = { fg = p.blue },
  ErrorMsg = { link = 'Error' },
  Error = { fg = p.red, bold = true },
  ModeMsg = { fg = p.fg },
  MoreMsg = { fg = p.fg },
  QuickFixLine = { bg = p.shade_1, bold = true },
  qfLineNr = { link = 'Number' },
  qfFileName = { fg = p.fg },
  Underlined = { fg = p.orange, underline = true },
  WarningMsg = { fg = p.yellow, bold = true },
  MatchParen = { fg = p.pink, bg = p.shade_3, bold = true },
  Whitespace = { fg = p.shade_3 },
  SpecialKey = { fg = p.fg },
  Pmenu = { bg = p.shade_1 },
  PmenuKind = { fg = p.yellow, bg = p.shade_1 },
  PmenuSel = { bg = p.shade_2 },
  PmenuMatch = { fg = p.green },
  PmenuMatchSel = { fg = p.green },
  PmenuSbar = { bg = p.shade_1 },
  PmenuThumb = { link = 'PmenuSbar' },
  WildMenu = { link = 'PmenuSel' },
  WinBar = { link = 'StatusLine' },
  WinBarNC = { link = 'StatusLineNC' },
  Question = { fg = p.cyan },
  SpellBad = { sp = p.red, undercurl = true },
  SpellCap = { sp = p.yellow, undercurl = true },
  SpellLocal = { sp = p.cyan, undercurl = true },
  SpellRare = { sp = p.blue, undercurl = true },
  TabLine = { fg = p.shade_4 },
  NonText = { fg = p.shade_4 },
  StatusLine = { bg = p.shade_1 },
  StatusLineNC = { link = 'StatusLine' },
  NormalFloat = { bg = p.shade_1 },
  FloatBorder = { fg = p.fg },
  Visual = { bg = p.shade_2 },
  Boolean = { fg = p.pink },
  Number = { fg = p.pink },
  Todo = { fg = p.pink, bold = true },
  Float = { link = 'Number' },
  Constant = { fg = p.pink },
  PreProc = { fg = p.fg },
  PreCondit = { fg = p.shade_4 },
  Define = { fg = p.purple },
  Conditional = { fg = p.purple },
  Repeat = { fg = p.purple },
  Keyword = { fg = p.purple },
  Exception = { fg = p.purple },
  Statement = { fg = p.purple },
  StorageClass = { fg = p.purple },
  Tag = { fg = p.blue },
  Label = { fg = p.purple },
  Structure = { fg = p.purple },
  Operator = { fg = p.fg },
  Title = { fg = p.pink, bold = true },
  Special = { fg = p.yellow },
  Function = { fg = p.blue },
  String = { fg = p.green },
  Character = { link = 'String' },
  Type = { fg = p.fg },
  Typedef = { link = 'Type' },
  Identifier = { fg = p.yellow },
  Comment = { fg = p.orange },
  Delimiter = { fg = p.fg },

  rustCommentLineDoc = { link = 'Comment' },
  -- customized
  QfLnum = { link = 'Number' },
  QfCol = { link = 'Number' },
  QfError = { link = 'DiagnosticError' },
  QfWarn = { link = 'DiagnosticWarn' },
  QfInfo = { link = 'DiagnosticInfo' },
  QfHint = { link = 'DiagnosticHint' },

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
  DiagnosticUnderlineError = { sp = p.red, undercurl = true },
  DiagnosticUnderlineWarn = { sp = p.yellow, undercurl = true },
  DiagnosticUnderlineInfo = { sp = p.blue, undercurl = true },
  DiagnosticUnderlineHint = { sp = p.cyan, undercurl = true },
  DiagnosticUnderlineOk = { sp = p.green, undercurl = true },
  LspInlayHint = { fg = p.shade_4 },
  LspSignatureActiveParameter = { bg = p.shade_2 },

  -- treesitter
  ['@function'] = { fg = p.fg },
  ['@function.builtin'] = { fg = p.fg },
  ['@function.macro'] = { link = 'Constant' },
  ['@macro'] = { link = 'Constant' },
  ['@method'] = { link = '@function' },
  ['@property'] = { link = '@variable' },
  ['@keyword.import'] = { link = 'PreProc' },
  ['@type.qualifier'] = { fg = p.green },
  ['@type.builtin'] = { link = 'Type' },
  ['@variable'] = { fg = p.fg },
  ['@variable.builtin'] = { link = '@variable' },
  ['@variable.parameter.builtin'] = { link = 'Special' },
  ['@punctuation.bracket'] = { link = 'Delimiter' },
  ['@punctuation.delimiter'] = { link = 'Delimiter' },
  ['@punctuation.special'] = { link = 'Delimiter' },
  ['@constructor'] = { link = '@function' },
  ['@namespace'] = { fg = p.fg },
  ['@module'] = { fg = p.fg },
  ['@attribute'] = { link = 'Special' },
  ['@markup.raw.block.markdown'] = { link = 'Comment' },
  ['@text.title'] = { fg = p.orange },
  ['@markup.strong.markdown_inline'] = { fg = p.orange },
  ['@markup.list.unchecked.markdown'] = { fg = p.pink },

  -- fzf-lua
  FzfLuaBufNr = { fg = p.fg },
  FzfLuaTabTitle = { fg = p.purple },
  FzfLuaTabMarker = { fg = p.green },
  FzfLuaBufFlagCur = { fg = p.red },
  FzfLuaBufFlagAlt = { fg = p.yellow },
  FzfLuaPathColNr = { fg = p.green },
  FzfLuaPathLineNr = { fg = p.pink },
  FzfLuaHeaderBind = { fg = p.orange },
  FzfLuaHeaderText = { fg = p.red },
  FzfLuaLiveSym = { fg = p.blue },
  FzfLuaLivePrompt = { fg = p.fg },

  -- blink.cmp
  BlinkCmpLabelMatch = { link = 'PmenuMatch' },
  BlinkCmpKindField = { fg = p.fg },
  BlinkCmpKindProperty = { fg = p.fg },
  BlinkCmpKindEvent = { fg = p.pink },
  BlinkCmpKindEnum = { fg = p.pink },
  BlinkCmpKindKeyword = { fg = p.fg },
  BlinkCmpKindConstant = { fg = p.pink },
  BlinkCmpKindConstructor = { fg = p.yellow },
  BlinkCmpKindReference = { fg = p.yellow },
  BlinkCmpKindFunction = { fg = p.blue },
  BlinkCmpKindClass = { fg = p.fg },
  BlinkCmpKindModule = { fg = p.fg },
  BlinkCmpKindVariable = { fg = p.fg },
  BlinkCmpKindFile = { fg = p.yellow },
  BlinkCmpKindUnit = { fg = p.fg },
  BlinkCmpKindMethod = { fg = p.blue },
  BlinkCmpKindValue = { fg = p.fg },
  BlinkCmpKindEnumMember = { fg = p.pink },
  BlinkCmpKindTypeParameter = { fg = p.fg },
}

for group, conf in pairs(syntax) do
  vim.api.nvim_set_hl(0, group, conf)
end
