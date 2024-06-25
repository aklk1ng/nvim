vim.api.nvim_command('hi clear')
vim.o.background = 'dark'
vim.o.termguicolors = true
vim.g.colors_name = 'aklk1ng'

local p = {
  bg = '#1a1b21',
  bg_dim = '#1e2027',
  bg_alt = '#2a2f3b',
  fg_dim = '#454b50',
  fg = '#909190',
  fg_alt = '#707070',
  red = '#a35858',
  pink = '#7f627b',
  orange = '#836552',
  yellow = '#7e704f',
  green = '#607546',
  blue = '#536c8d',
  purple = '#5d628a',
  grey = '#7a7a7a',
  fancy = '#4f585e',
  galaxy = '#5b6d6d',
  none = 'NONE',
}

_G.palette = p

local syntax = {
  Normal = { fg = p.fg, bg = p.bg },
  Terminal = { fg = p.fg, bg = p.bg },
  SignColumn = { fg = p.fg, bg = p.bg },
  WinSeparator = { fg = p.fg_dim },
  Folded = { fg = p.grey, bg = p.bg_dim },
  EndOfBuffer = { fg = p.bg, bg = p.none },
  Search = { fg = p.bg, bg = p.yellow },
  CurSearch = { fg = p.bg, bg = p.fg_alt },
  ColorColumn = { link = 'CursorLine' },
  Conceal = { fg = p.grey, bg = p.none },
  CursorColumn = { link = 'CursorLine' },
  FoldColumn = { fg = p.bg_alt },
  CursorLineFold = { fg = p.yellow },
  CursorLine = { bg = p.bg_dim },
  LineNr = { fg = p.bg_alt },
  CursorLineNr = { fg = p.fg_alt },
  Added = { fg = p.green },
  Removed = { fg = p.red },
  DiffAdd = { fg = p.green },
  DiffChange = { fg = p.blue },
  DiffDelete = { fg = p.red },
  DiffText = { fg = p.orange },
  Directory = { fg = p.blue, bg = p.none },
  ErrorMsg = { link = 'Error' },
  Error = { fg = p.red, bold = true },
  MoreMsg = { fg = p.blue },
  QuickFixLine = { bold = true },
  WarningMsg = { fg = p.yellow, bg = p.none, bold = true },
  MatchParen = { fg = p.pink, bg = p.fg_dim, bold = true },
  NonText = { link = 'Comment' },
  Whitespace = { fg = p.bg_alt },
  SpecialKey = { fg = p.grey },
  Pmenu = { fg = p.fg_alt, bg = p.bg_dim },
  PmenuKind = { fg = p.yellow, bg = p.bg_dim },
  PmenuSel = { fg = p.fg_alt, bg = p.bg_alt },
  PmenuMatch = { fg = p.green },
  PmenuSbar = { bg = p.bg_dim },
  PmenuThumb = { link = 'PmenuSbar' },
  WildMenu = { link = 'Pmenu' },
  WinBar = { link = 'StatusLine' },
  WinBarNC = { link = 'StatusLineNC' },
  TabLine = { fg = p.grey },
  StatusLine = { bg = p.bg },
  StatusLineNC = { bg = p.bg },
  NormalFloat = { fg = p.fg_alt },
  FloatBorder = { fg = p.fg_alt },
  Visual = { bg = p.bg_alt },
  Boolean = { fg = p.orange },
  Number = { fg = p.purple },
  Float = { link = 'Number' },
  Constant = { fg = p.pink },
  PreProc = { fg = p.pink },
  PreCondit = { fg = p.pink },
  Include = { fg = p.pink },
  Define = { fg = p.purple },
  Conditional = { fg = p.pink },
  Repeat = { fg = p.purple },
  Keyword = { fg = p.pink },
  Typedef = { link = 'Type' },
  Exception = { link = 'Conditional' },
  Statement = { fg = p.purple },
  StorageClass = { fg = p.orange },
  Tag = { fg = p.orange },
  Label = { fg = p.purple },
  Structure = { fg = p.orange },
  Operator = { fg = p.fg_alt },
  Title = { fg = p.orange, bold = true },
  Special = { fg = p.yellow },
  Function = { fg = p.blue },
  String = { fg = p.green },
  Character = { link = 'String' },
  Type = { fg = p.galaxy },
  Identifier = { fg = p.yellow },
  Comment = { fg = p.fancy },
  Delimiter = { fg = p.fg_alt },
  Noise = { fg = p.fg_alt },

  DiagnosticError = { fg = p.red },
  DiagnosticWarn = { fg = p.yellow },
  DiagnosticInfo = { fg = p.blue },
  DiagnosticHint = { fg = p.green },
  DiagnosticOk = { fg = p.green },
  DiagnosticSignError = { link = 'DiagnosticError' },
  DiagnosticSignWarn = { link = 'DiagnosticWarn' },
  DiagnosticSignInfo = { link = 'DiagnosticInfo' },
  DiagnosticSignHint = { link = 'DiagnosticHint' },
  DiagnosticUnderlineError = { undercurl = true },
  DiagnosticUnderlineWarn = { undercurl = true },
  DiagnosticUnderlineInfo = { undercurl = true },
  DiagnosticUnderlineHint = { undercurl = true },

  CursorWord = { bg = p.bg_alt },
  LspInlayHint = { fg = p.fg_dim },

  LspSignatureActiveParameter = { bg = p.bg_alt },

  -- nvim-treesitter
  ['@function.builtin'] = { link = 'Function' },
  ['@parameter'] = { link = '@variable' },
  ['@method'] = { link = 'Function' },
  ['@keyword.function'] = { fg = p.purple },
  ['@keyword.operator'] = { fg = p.pink },
  ['@keyword.repeat'] = { link = 'Repeat' },
  ['@keyword.return'] = { link = 'Repeat' },
  ['@property'] = { link = '@field' },
  ['@field'] = { fg = p.yellow },
  ['@variable.member'] = { link = '@field' },
  ['@type.qualifier'] = { fg = p.green },
  ['@type.builtin'] = { link = 'Type' },
  ['@variable'] = { fg = p.grey },
  ['@variable.builtin'] = { link = '@variable' },
  ['@punctuation.bracket'] = { fg = p.fg_alt },
  ['@punctuation.delimiter'] = { fg = p.fg_alt },
  ['@punctuation.special'] = { fg = p.fg_alt },
  ['@constructor'] = { link = 'Function' },
  ['@namespace'] = { fg = p.orange },
  ['@module'] = { fg = p.orange },
  ['@attribute'] = { link = '@field' },
  ['@markup.raw.block.markdown'] = { fg = p.fg_alt },
  ['@nospell'] = { fg = p.pink },
  ['@macro'] = { fg = p.pink },
  ['@markup'] = { fg = p.fg_alt },
  ['@markup.strong.markdown_inline'] = { fg = p.orange },
  ['@markup.list.unchecked.markdown'] = { fg = p.pink },
  ['@markup.heading'] = { link = 'Title' },
  ['@markup.heading.1'] = { fg = p.orange, bold = true },
  ['@markup.heading.2'] = { fg = p.yellow, bold = true },
  ['@markup.heading.3'] = { fg = p.green, bold = true },
  ['@markup.heading.4'] = { fg = p.fancy, bold = true },
  ['@markup.heading.5'] = { fg = p.blue, bold = true },
  ['@markup.heading.6'] = { fg = p.purple, bold = true },

  -- LSP Semantic Token
  ['@lsp.type.variable'] = {},
  ['@lsp.type.operator'] = {},
  ['@lsp.type.parameter'] = {},
  ['@lsp.type.builtinType'] = { link = 'Type' },
  ['@lsp.type.decorator'] = { link = '@attribute' },
  ['@lsp.type.deriveHelper'] = { link = '@attribute' },
  ['@lsp.type.escapeSequence'] = { link = '@string.escape' },
  ['@lsp.type.formatSpecifier'] = { link = '@punctuation.special' },
  ['@lsp.type.generic'] = { link = '@variable' },
  ['@lsp.type.macro'] = { link = 'Constant' },
  ['@lsp.type.class'] = { link = 'StorageClass' },
  ['@lsp.type.enumMember'] = { link = '@property' },
  ['@lsp.type.unresolvedReference'] = { undercurl = true },
  ['@lsp.typemod.enumMember.defaultLibrary'] = { link = '@constant.builtin' },
  ['@lsp.typemod.struct.defaultLibrary'] = { link = 'Type' },
  ['@lsp.typemod.variable.declaration'] = { link = '@variable' },
  ['@lsp.typemod.variable.callable'] = { link = 'Function' },
  ['@lsp.typemod.variable.static'] = { link = 'Constant' },

  -- gitsigns.nvim
  GitSignsAdd = { fg = p.green },
  GitSignsChange = { fg = p.blue },
  GitSignsDelete = { fg = p.red },

  -- Telescope
  TelescopeSelection = { bg = p.bg_dim },
  TelescopePromptNormal = { fg = p.grey, bg = p.bg_dim },
  TelescopePromptTitle = { fg = p.bg, bg = p.blue },
  TelescopePromptBorder = { fg = p.bg_dim, bg = p.bg_dim },
  TelescopeResultsBorder = { fg = p.bg, bg = p.bg },
  TelescopePreviewBorder = { fg = p.bg, bg = p.bg },
  TelescopePreviewTitle = { fg = p.bg, bg = p.purple },

  -- nvim-cmp
  CmpItemAbbrMatch = { link = 'PmenuMatch' },
  CmpDoc = { link = 'Pmenu' },
  CmpItemKindKeyword = { link = 'Keyword' },
  CmpItemKindFunction = { link = 'Function' },
  CmpItemKindMethod = { link = 'CmpItemKindFunction' },
  CmpItemKindModule = { link = '@module' },
  CmpItemKindVariable = { link = '@variable' },
  CmpItemKindField = { link = '@field' },
  CmpItemKindConstant = { link = 'Constant' },
}

for group, conf in pairs(syntax) do
  vim.api.nvim_set_hl(0, group, conf)
end
