local M = {
  base0 = '#1B2229',
  base1 = '#1c1f24',
  base2 = '#202328',
  base3 = '#23272e',
  base4 = '#3f444a',
  base5 = '#5B6268',
  base6 = '#777d86',
  base7 = '#9ca0a4',
  base8 = '#b1b1b1',
  bg = '#1e222a',
  bg1 = '#504945',
  bg_popup = '#3E4556',
  bg_highlight = '#2E323C',
  bg_visual = '#3e4452',
  fg = '#bbc2cf',
  fg_alt = '#839496',
  red = '#ea6962',
  redwine = '#CF6A8F',

  orange = '#e78a4e',
  yellow = '#d8a657',
  green = '#a9b665',
  -- 芽绿
  dark_green = '#96c24e',
  aqua = '#89b482',
  xxoo = '#85BFC7',
  blue = '#7daea3',
  purple = '#d3869b',
  purple_2 = '#A995D1',
  hairy_green = '#74AD8B',
  brown = '#c77111',
  black = '#000000',
  pink = '#DF75A5',
  -- 大理石灰
  marble_gray = '#c2bd9f',
  -- 月影白
  moon_shadow_white = '#c0c4c3',
  -- 穹灰
  dome_gray = '#c4d7d6',
  grey = '#535459',
  white_1 = '#afb2bb',
  none = 'NONE',
}

function M.terminal_color()
  vim.g.terminal_color_0 = M.bg
  vim.g.terminal_color_1 = M.red
  vim.g.terminal_color_2 = M.green
  vim.g.terminal_color_3 = M.yellow
  vim.g.terminal_color_4 = M.blue
  vim.g.terminal_color_5 = M.purple
  vim.g.terminal_color_6 = M.cyan
  vim.g.terminal_color_7 = M.bg1
  vim.g.terminal_color_8 = M.brown
  vim.g.terminal_color_9 = M.red
  vim.g.terminal_color_10 = M.green
  vim.g.terminal_color_11 = M.yellow
  vim.g.terminal_color_12 = M.blue
  vim.g.terminal_color_13 = M.purple
  vim.g.terminal_color_14 = M.cyan
  vim.g.terminal_color_15 = M.fg
end

local syntax = {
  Normal = { fg = M.fg, bg = M.bg },
  Terminal = { fg = M.fg, bg = M.bg },
  SignColumn = { fg = M.fg, bg = M.bg },
  WinSeparator = { fg = M.black, bg = M.bg },
  Folded = { fg = M.fg, bg = M.base4 },
  EndOfBuffer = { fg = M.bg, bg = M.none },
  IncSearch = { fg = M.bg1, bg = M.orange },
  Search = { fg = M.bg, bg = M.orange },
  ColorColumn = { bg = M.bg_highlight },
  Conceal = { fg = M.fg_alt, bg = M.none },
  Cursor = { fg = M.none, reverse = true },
  vCursor = { fg = M.none, reverse = true },
  iCursor = { fg = M.none, reverse = true },
  lCursor = { fg = M.none, reverse = true },
  CursorIM = { fg = M.none, reverse = true },
  CursorColumn = { bg = M.bg_popup },
  FoldColumn = { fg = M.base5, bg = M.bg },
  CursorLine = { bg = M.bg_highlight },
  LineNr = { fg = M.base5 },
  CursorLineNr = { fg = M.redwine, bold = true },
  DiffAdd = { fg = M.dark_green, bg = M.base4 },
  DiffChange = { fg = M.blue, bg = M.base4 },
  DiffDelete = { fg = M.red, bg = M.base4 },
  DiffText = { fg = M.orange, bg = M.bg },
  Directory = { fg = M.blue, bg = M.none },
  ErrorMsg = { fg = M.red, bg = M.none, bold = true },
  WarningMsg = { fg = M.yellow, bg = M.none, bold = true },
  ModeMsg = { fg = M.fg, bg = M.none, bold = true },
  MatchParen = { bg = '#61646D' },
  NonText = { fg = M.bg1 },
  Whitespace = { fg = M.base4 },
  SpecialKey = { fg = M.bg1 },
  Pmenu = { fg = M.fg, bg = '#2E323E' },
  PmenuSel = { fg = M.base0, bg = M.blue },
  PmenuSelBold = { fg = M.base0, bg = M.blue },
  PmenuSbar = { bg = M.base4 },
  PmenuThumb = { fg = M.purple, bg = M.light_green },
  WildMenu = { fg = M.bg1, bg = M.green },
  StatusLine = { fg = M.base8, bg = M.base2 },
  StatusLineNC = { fg = M.grey, bg = M.base2 },
  Question = { fg = M.yellow },
  NormalFloat = { fg = M.base8, bg = M.bg_highlight },
  Tabline = { fg = M.fg, bg = M.bg },
  TabLineSel = { fg = M.fg, bg = M.base4 },
  TabLineFill = { fg = M.fg, bg = M.bg },
  Visual = { bg = M.grey },
  VisualNOS = { fg = M.none, bg = M.bg_visual },
  QuickFixLine = { fg = M.purple, bold = true },
  Debug = { fg = M.orange },
  DebugBreakpoint = { fg = M.bg, bg = M.red },
  Boolean = { fg = M.orange, italic = true },
  Number = { fg = M.brown },
  Float = { fg = M.brown },
  PreProc = { fg = M.purple, italic = true },
  PreCondit = { fg = M.purple },
  Include = { fg = M.purple, italic = true },
  Define = { fg = M.purple, italic = true },
  Conditional = { fg = M.purple },
  Repeat = { fg = M.purple_2 },

  Keyword = { fg = M.purple },
  Typedef = { fg = M.red },
  Exception = { fg = M.red },
  Statement = { fg = M.red },
  Error = { fg = M.red },
  StorageClass = { fg = M.orange },
  Tag = { fg = M.orange },
  Label = { fg = M.pink },
  Structure = { fg = M.orange },
  Operator = { fg = M.pink },
  Title = { fg = M.orange, bold = true },
  Special = { fg = M.yellow },
  SpecialChar = { fg = M.yellow },
  Function = { fg = M.blue },
  String = { fg = M.dark_green },
  Character = { fg = M.green },
  Type = { fg = M.green },
  Identifier = { fg = M.blue },
  Comment = { fg = M.base6, italic = true },
  SpecialComment = { fg = M.white_1 },
  Todo = { fg = M.purple },
  Delimiter = { fg = M.grey },
  Ignore = { fg = M.grey },
  Underlined = { underline = true },

  ['@function.builtin'] = { fg = M.blue, italic = true },
  ['@function.macro'] = { fg = M.xxoo, italic = true },
  ['@parameter'] = { fg = M.marble_gray, italic = true },
  ['@method'] = { fg = M.blue, bold = true, italic = true },
  ['@keyword.function'] = { fg = M.red },
  ['@keyword.operator'] = { fg = M.orange },
  ['@keyword.return'] = { fg = M.purple_2 },
  ['@property'] = { fg = M.yellow },
  ['@field'] = { fg = M.yellow },
  ['@type'] = { fg = M.green },
  ['@type.qualifier'] = { fg = M.orange },
  ['@variable'] = { fg = M.marble_gray },
  ['@variable.builtin'] = { fg = M.marble_gray, italic = true },
  ['@punctuation.bracket'] = { bg = M.none },
  ['@punctuation.delimiter'] = { bg = M.none },
  ['@punctuation.special'] = { fg = M.none },
  ['@text.literal'] = { fg = M.green },
  ['@text.strong'] = { fg = M.red },
  ['@constant'] = { fg = M.pink },
  ['@constructor'] = { fg = M.orange },
  ['@namespace'] = { fg = M.orange },
  ['@attribute'] = { fg = M.yellow },

  diffAdded = { fg = M.dark_green },
  diffRemoved = { fg = M.red },
  diffChanged = { fg = M.blue },
  diffOldFile = { fg = M.yellow },
  diffNewFile = { fg = M.orange },
  diffFile = { fg = M.aqua },
  diffLine = { fg = M.grey },
  diffIndexLine = { fg = M.purple },

  GitSignsAdd = { fg = M.dark_green },
  GitSignsChange = { fg = M.blue },
  GitSignsDelete = { fg = M.red },
  GitSignsAddNr = { fg = M.dark_green },
  GitSignsChangeNr = { fg = M.blue },
  GitSignsDeleteNr = { fg = M.red },
  GitSignsAddLn = { bg = M.bg_popup },
  GitSignsChangeLn = { bg = M.bg_highlight },
  GitSignsDeleteLn = { bg = M.bg1 },
  GitSignsCurrentLineBlame = { link = 'Comment' },
  -- nvim v0.6.0+
  DiagnosticSignError = { fg = M.red },
  DiagnosticSignWarn = { fg = M.yellow },
  DiagnosticSignInfo = { fg = M.blue },
  DiagnosticSignHint = { fg = M.aqua },
  DiagnosticError = { fg = M.red },
  DiagnosticWarn = { fg = M.yellow },
  DiagnosticInfo = { fg = M.blue },
  DiagnosticHint = { fg = M.aqua },
  LspReferenceRead = { bg = M.bg_highlight, bold = true },
  LspReferenceText = { bg = M.bg_highlight, bold = true },
  LspReferenceWrite = { bg = M.bg_highlight, bold = true },
  DiagnosticVirtualTextError = { fg = M.red },
  DiagnosticVirtualTextWarn = { fg = M.yellow },
  DiagnosticVirtualTextInfo = { fg = M.blue },
  DiagnosticVirtualTextHint = { fg = M.aqua },
  DiagnosticUnderlineError = { underline = true, sp = M.red },
  DiagnosticUnderlineWarn = { underline = true, sp = M.yellow },
  DiagnosticUnderlineInfo = { underline = true, sp = M.blue },
  DiagnosticUnderlineHint = { underline = true, sp = M.aqua },

  -- Telescope
  TelescopeNormal = { bg = M.base0 },
  TelescopeSelection = { fg = M.yellow, bg = M.bg_highlight, bold = true },
  TelescopePromptTitle = { fg = M.base0, bg = M.blue },
  TelescopePromptBorder = { fg = M.base0, bg = M.base0 },
  TelescopeResultsBorder = { fg = M.base0, bg = M.base0 },
  TelescopeResultsTitle = { fg = M.base0, bg = M.pink },
  TelescopePreviewBorder = { fg = M.base0, bg = M.base0 },
  TelescopePreviewTitle = { fg = M.base0, bg = M.green },
  -- nvim-cmp
  CmpItemAbbr = { fg = M.fg },
  CmpItemAbbrMatch = { fg = '#A6E22E' },
  CmpItemMenu = { fg = M.purple },
  CmpDoc = { link = 'Pmenu' },
  CmpItemKindKeyword = { fg = M.red },
  CmpItemKindFunction = { fg = M.blue },
  CmpItemKindMethod = { fg = M.aqua },
  CmpItemKindModule = { fg = M.aqua },
  CmpItemKindVariable = { fg = M.marble_gray },
  CmpItemKindField = { fg = M.yellow },

  FloatBorder = { fg = M.none },
  -- Dashboard
  DashboardShortCut = { fg = M.purple },
  DashboardHeader = { fg = M.orange },
  DashboardCenter = { fg = M.green },
  DashboardIcon = { fg = M.aqua },
  DashboardDesc = { fg = M.blue },
  DashboardKey = { fg = M.orange },
  DashboardFooter = { fg = M.yellow, bold = true },

  HopNextKey = { fg = M.orange },
  HopNextKey1 = { fg = M.green },

  LspInlayHint = { link = 'Comment' },
}

local set_hl = function(tbl)
  for group, conf in pairs(tbl) do
    vim.api.nvim_set_hl(0, group, conf)
  end
end

function M.colorscheme()
  vim.api.nvim_command('hi clear')

  vim.o.background = 'dark'
  vim.o.termguicolors = true
  vim.g.colors_name = 'aklk1ngass'
  set_hl(syntax)
  M.terminal_color()
end

M.colorscheme()

return M
