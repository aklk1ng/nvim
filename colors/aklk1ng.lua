vim.api.nvim_command('hi clear')
vim.o.background = 'dark'
vim.o.termguicolors = true
vim.g.colors_name = 'aklk1ng'

local p = {
  bg = '#151521',
  base1 = '#303336',
  base2 = '#454b50',
  bg_alt = '#232931',
  bg_highlight = '#1a1f27',
  fg = '#808080',
  fg_alt = '#6a6a6a',
  red = '#a35858',
  pink = '#796174',
  orange = '#7d5e4c',
  yellow = '#736a53',
  green = '#607546',
  blue = '#506583',
  purple = '#646882',
  grey = '#707070',
  fancy = '#4f585e',
  galaxy = '#506561',
  none = 'none',
}

local syntax = {
  Normal = { fg = p.fg, bg = p.bg },
  Terminal = { fg = p.fg, bg = p.bg },
  SignColumn = { fg = p.fg, bg = p.bg },
  WinSeparator = { fg = p.base1, bg = p.bg },
  Folded = { fg = p.green, bg = p.bg_highlight },
  EndOfBuffer = { fg = p.bg, bg = p.none },
  Search = { fg = p.bg, bg = p.yellow },
  CurSearch = { link = 'Search' },
  ColorColumn = { bg = p.bg_highlight },
  Conceal = { fg = p.grey, bg = p.none },
  CursorColumn = { link = 'CursorLine' },
  FoldColumn = { fg = p.galaxy },
  CursorLine = { bg = p.bg_highlight },
  LineNr = { fg = p.bg_alt },
  CursorLineNr = { fg = p.fg_alt },
  Added = { fg = p.green },
  Removed = { fg = p.red },
  DiffAdd = { fg = p.green },
  DiffChange = { fg = p.blue },
  DiffDelete = { fg = p.red },
  DiffText = { fg = p.orange },
  Directory = { fg = p.blue, bg = p.none },
  ErrorMsg = { fg = p.red, bg = p.none, bold = true },
  MoreMsg = { fg = p.blue },
  WarningMsg = { fg = p.yellow, bg = p.none, bold = true },
  MatchParen = { fg = p.pink, bg = p.base2, bold = true },
  NonText = { link = 'Comment' },
  Whitespace = { fg = p.base1 },
  SpecialKey = { fg = p.grey },
  Pmenu = { fg = p.fg_alt, bg = p.bg_highlight },
  PmenuKind = { fg = p.yellow, bg = p.bg_highlight },
  PmenuSel = { fg = p.fg_alt, bg = p.bg_alt },
  PmenuSbar = { bg = p.bg_highlight },
  PmenuThumb = { link = 'PmenuSbar' },
  WildMenu = { link = 'Pmenu' },
  WinBar = { link = 'StatusLine' },
  WinBarNC = { link = 'StatusLineNC' },
  StatusLine = { bg = p.bg },
  StatusLineNC = { bg = p.bg },
  NormalFloat = { fg = p.fg_alt },
  FloatBorder = { fg = p.fg_alt },
  Visual = { bg = p.base1 },
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
  Error = { fg = p.red },
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
  Todo = { fg = p.pink },
  Delimiter = { fg = p.fg_alt },
  Noise = { fg = p.fg_alt },

  DiagnosticError = { fg = p.red },
  DiagnosticWarn = { fg = p.yellow },
  DiagnosticInfo = { fg = p.blue },
  DiagnosticHint = { fg = p.green },
  DiagnosticSignError = { link = 'DiagnosticError' },
  DiagnosticSignWarn = { link = 'DiagnosticWarn' },
  DiagnosticSignInfo = { link = 'DiagnosticInfo' },
  DiagnosticSignHint = { link = 'DiagnosticHint' },
  DiagnosticUnderlineError = { undercurl = true },
  DiagnosticUnderlineWarn = { undercurl = true },
  DiagnosticUnderlineInfo = { undercurl = true },
  DiagnosticUnderlineHint = { undercurl = true },

  CursorWord = { bg = p.base1 },
  LspInlayHint = { fg = p.base2 },

  -- noice
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
  ['@markup.raw.block.markdown'] = { fg = p.grey },
  ['@nospell'] = { fg = p.pink },
  ['@macro'] = { fg = p.pink },
  ['@markup'] = { fg = p.grey },
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
  ['@lsp.type.builtinType'] = { link = 'Type' },
  ['@lsp.type.interface'] = { link = 'Type' },
  ['@lsp.type.decorator'] = { link = '@attribute' },
  ['@lsp.type.deriveHelper'] = { link = '@attribute' },
  ['@lsp.type.escapeSequence'] = { link = '@string.escape' },
  ['@lsp.type.formatSpecifier'] = { link = '@punctuation.special' },
  ['@lsp.type.generic'] = { link = '@variable' },
  ['@lsp.type.namespace'] = { link = '@namespace' },
  ['@lsp.type.parameter'] = { link = '@parameter' },
  ['@lsp.type.property'] = { link = '@property' },
  ['@lsp.type.struct'] = { link = 'Type' },
  ['@lsp.type.macro'] = { link = 'Constant' },
  ['@lsp.type.class'] = { link = 'StorageClass' },
  ['@lsp.type.enumMember'] = { link = '@property' },
  ['@lsp.type.typeAlias'] = { link = 'Typedef' },
  ['@lsp.type.unresolvedReference'] = { undercurl = true },
  ['@lsp.typemod.enumMember.defaultLibrary'] = { link = '@constant.builtin' },
  ['@lsp.typemod.struct.defaultLibrary'] = { link = 'Type' },
  ['@lsp.typemod.variable.callable'] = { link = 'Function' },
  ['@lsp.typemod.variable.static'] = { link = 'Constant' },

  -- gitsigns.nvim
  GitSignsAdd = { fg = p.green },
  GitSignsChange = { fg = p.blue },
  GitSignsDelete = { fg = p.red },

  -- Telescope
  TelescopeSelection = { bg = p.bg_highlight },
  TelescopePromptNormal = { fg = p.grey, bg = p.bg_highlight },
  TelescopePromptTitle = { fg = p.bg, bg = p.blue },
  TelescopePromptBorder = { fg = p.bg_highlight, bg = p.bg_highlight },
  TelescopeResultsBorder = { fg = p.bg, bg = p.bg },
  TelescopeResultsTitle = { fg = p.bg, bg = p.pink },
  TelescopePreviewBorder = { fg = p.bg, bg = p.bg },
  TelescopePreviewTitle = { fg = p.bg, bg = p.purple },
  -- nvim-cmp
  CmpItemAbbrMatch = { fg = p.green },
  CmpDoc = { link = 'Pmenu' },
  CmpItemKindKeyword = { link = 'Keyword' },
  CmpItemKindFunction = { link = 'Function' },
  CmpItemKindMethod = { link = 'CmpItemKindFunction' },
  CmpItemKindModule = { link = '@module' },
  CmpItemKindVariable = { link = '@variable' },
  CmpItemKindField = { link = '@field' },

  -- indentmini
  IndentLine = { fg = p.bg_alt },
}

for group, conf in pairs(syntax) do
  vim.api.nvim_set_hl(0, group, conf)
end
