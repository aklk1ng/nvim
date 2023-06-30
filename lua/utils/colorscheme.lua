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
  red = '#e96189',
  -- 初荷红
  redwine = '#e16c96',
  orange = '#FF8700',
  yellow = '#d8a657',
  light_orange = '#e78a4e',
  green = '#afa100',
  -- 芽绿
  dark_green = '#96c24e',
  -- 瀑布蓝
  cyan = '#51bbeb',
  xxoo = '#85BFC7',
  q_blue = '#7AAADA',
  blue = '#60A4DC',
  violet = '#917bb5',
  magenta = '#bf68d9',
  hairy_green = '#74AD8B',
  brown = '#c77111',
  black = '#000000',
  pink = '#ef82a0',
  -- 大理石灰
  marble_gray = '#c2bd9f',
  -- 月影白
  moon_shadow_white = '#c0c4c3',
  -- 穹灰
  dome_gray = '#c4d7d6',
  bracket = '#95A6C9',
  grey = '#535459',
  white = '#dedede',
  white_1 = '#afb2bb',
  none = 'NONE',
}

function M.terminal_color()
  vim.g.terminal_color_0 = M.bg
  vim.g.terminal_color_1 = M.red
  vim.g.terminal_color_2 = M.green
  vim.g.terminal_color_3 = M.yellow
  vim.g.terminal_color_4 = M.blue
  vim.g.terminal_color_5 = M.violet
  vim.g.terminal_color_6 = M.cyan
  vim.g.terminal_color_7 = M.bg1
  vim.g.terminal_color_8 = M.brown
  vim.g.terminal_color_9 = M.red
  vim.g.terminal_color_10 = M.green
  vim.g.terminal_color_11 = M.yellow
  vim.g.terminal_color_12 = M.blue
  vim.g.terminal_color_13 = M.violet
  vim.g.terminal_color_14 = M.cyan
  vim.g.terminal_color_15 = M.fg
end

local syntax = {
  Normal = { fg = M.fg, bg = M.bg },
  Terminal = { fg = M.fg, bg = M.bg },
  SignColumn = { fg = M.fg, bg = M.bg },
  WinSeparator = { fg = M.black, bg = M.bg },
  Folded = { fg = M.fg, bg = M.base4 },
  CursorLineFold = { fg = M.yellow, bg = M.bg },
  EndOfBuffer = { fg = M.bg, bg = M.none },
  IncSearch = { fg = M.bg1, bg = M.orange },
  Search = { fg = M.bg, bg = M.orange },
  ColorColumn = { bg = M.bg_highlight },
  Conceal = { fg = M.grey, bg = M.none },
  Cursor = { fg = M.none, reverse = true },
  vCursor = { fg = M.none, reverse = true },
  iCursor = { fg = M.none, reverse = true },
  lCursor = { fg = M.none, reverse = true },
  CursorIM = { fg = M.none, reverse = true },
  CursorColumn = { bg = M.bg_popup },
  FoldColumn = { fg = M.base5, bg = M.bg },
  CursorLine = { bg = M.bg_highlight },
  LineNr = { fg = M.base5 },
  qfLineNr = { fg = M.cyan },
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
  PmenuThumb = { fg = M.violet, bg = M.light_green },
  WildMenu = { fg = M.bg1, bg = M.green },
  StatusLine = { fg = M.base8, bg = M.base2 },
  StatusLineNC = { fg = M.grey, bg = M.base2 },
  Question = { fg = M.yellow },
  NormalFloat = { fg = M.base8, bg = M.bg_highlight },
  Tabline = { fg = M.base6, bg = M.base2 },
  TabLineSel = { fg = M.fg, bg = M.blue },
  Visual = { fg = M.none, bg = M.grey },
  VisualNOS = { fg = M.none, bg = M.bg_visual },
  QuickFixLine = { fg = M.violet, bold = true },
  Debug = { fg = M.orange },
  DebugBreakpoint = { fg = M.bg, bg = M.red },
  Boolean = { fg = M.orange, italic = true },
  Number = { fg = M.brown },
  Float = { fg = M.brown },
  PreProc = { fg = M.violet, italic = true },
  PreCondit = { fg = M.violet },
  Include = { fg = M.violet, italic = true },
  Define = { fg = M.violet, italic = true },
  Conditional = { fg = M.magenta },
  Repeat = { fg = M.magenta },
  Keyword = { fg = M.green },
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
  Type = { fg = M.hairy_green },
  Identifier = { fg = M.blue },
  Comment = { fg = M.base6, italic = true },
  SpecialComment = { fg = M.white_1 },
  Todo = { fg = M.violet },
  Delimiter = { fg = M.grey },
  Ignore = { fg = M.grey },
  Underlined = { underline = true },

  ['@function.builtin'] = { fg = M.blue, italic = true },
  ['@function.macro'] = { fg = M.xxoo, italic = true },
  ['@parameter'] = { fg = M.marble_gray, italic = true },
  ['@method'] = { fg = M.blue, bold = true, italic = true },
  ['@keyword.function'] = { fg = M.red },
  ['@property'] = { fg = M.yellow },
  ['@field'] = { fg = M.yellow },
  ['@type'] = { fg = M.hairy_green },
  ['@type.qualifier'] = { fg = M.redwine },
  ['@variable'] = { fg = M.marble_gray },
  ['@variable.builtin'] = { fg = M.q_blue, italic = true },
  ['@punctuation.bracket'] = { fg = M.bracket },
  ['@punctuation.delimiter'] = { fg = M.bracket },
  ['@punctuation.special'] = { fg = M.bracket },
  ['@text.literal'] = { fg = M.hairy_green },
  ['@text.strong'] = { fg = M.red },
  ['@constant'] = { fg = M.pink },
  ['@constructor'] = { fg = M.light_orange },
  ['@namespace'] = { fg = M.violet },
  ['@attribute'] = { fg = M.yellow },

  diffAdded = { fg = M.dark_green },
  diffRemoved = { fg = M.red },
  diffChanged = { fg = M.blue },
  diffOldFile = { fg = M.yellow },
  diffNewFile = { fg = M.orange },
  diffFile = { fg = M.cyan },
  diffLine = { fg = M.grey },
  diffIndexLine = { fg = M.violet },

  gitcommitFile = { fg = M.dark_green },
  GitSignsAdd = { fg = M.dark_green },
  GitSignsChange = { fg = M.blue },
  GitSignsDelete = { fg = M.red },
  GitSignsAddNr = { fg = M.dark_green },
  GitSignsChangeNr = { fg = M.blue },
  GitSignsDeleteNr = { fg = M.red },
  GitSignsAddLn = { bg = M.bg_popup },
  GitSignsChangeLn = { bg = M.bg_highlight },
  GitSignsDeleteLn = { bg = M.bg1 },
  SignifySignAdd = { fg = M.dark_green },
  SignifySignChange = { fg = M.blue },
  SignifySignDelete = { fg = M.red },
  -- nvim v0.6.0+
  DiagnosticSignError = { fg = M.red },
  DiagnosticSignWarn = { fg = M.yellow },
  DiagnosticSignInfo = { fg = M.blue },
  DiagnosticSignHint = { fg = M.cyan },
  DiagnosticError = { fg = M.red },
  DiagnosticWarn = { fg = M.yellow },
  DiagnosticInfo = { fg = M.blue },
  DiagnosticHint = { fg = M.cyan },
  LspReferenceRead = { bg = M.bg_highlight, bold = true },
  LspReferenceText = { bg = M.bg_highlight, bold = true },
  LspReferenceWrite = { bg = M.bg_highlight, bold = true },
  DiagnosticVirtualTextError = { fg = M.red },
  DiagnosticVirtualTextWarn = { fg = M.yellow },
  DiagnosticVirtualTextInfo = { fg = M.blue },
  DiagnosticVirtualTextHint = { fg = M.cyan },
  DiagnosticUnderlineError = { underline = true, sp = M.red },
  DiagnosticUnderlineWarn = { underline = true, sp = M.yellow },
  DiagnosticUnderlineInfo = { underline = true, sp = M.blue },
  DiagnosticUnderlineHint = { underline = true, sp = M.cyan },

  -- Telescope
  TelescopeNormal = { bg = M.base0 },
  TelescopeSelection = { fg = M.yellow, bg = M.bg_highlight, bold = true },
  TelescopePromptTitle = { fg = M.base0, bg = M.blue },
  TelescopePromptBorder = { fg = M.base0, bg = M.base0 },
  TelescopePromptNormal = { fg = M.white1, bg = M.white1 },
  TelescopeResultsBorder = { fg = M.base0, bg = M.base0 },
  TelescopeResultsTitle = { fg = M.base0, bg = M.redwine },
  TelescopePreviewBorder = { fg = M.base0, bg = M.base0 },
  TelescopePreviewTitle = { fg = M.base0, bg = M.hairy_green },
  -- nvim-cmp
  CmpItemAbbr = { fg = M.fg },
  CmpItemAbbrMatch = { fg = '#A6E22E' },
  CmpItemMenu = { fg = M.violet },
  CmpDoc = { link = 'Pmenu' },
  CmpItemKindKeyword = { fg = M.red },
  CmpItemKindFunction = { fg = M.blue },
  CmpItemKindMethod = { fg = M.cyan },
  CmpItemKindModule = { fg = M.cyan },
  CmpItemKindVariable = { fg = M.marble_gray },
  CmpItemKindField = { fg = M.yellow },

  FloatBorder = { fg = '#4CC1CB' },
  -- Dashboard
  DashboardShortCut = { fg = M.magenta },
  DashboardHeader = { fg = M.orange },
  DashboardCenter = { fg = M.hairy_green },
  DashboardIcon = { fg = M.cyan },
  DashboardDesc = { fg = M.blue },
  DashboardKey = { fg = M.orange },
  DashboardFooter = { fg = M.yellow, bold = true },

  -- Falsh
  FlashCurrent = { fg = M.redwine },
  FlashMatch = { fg = M.marble_gray },
  FlashLabel = { fg = M.hairy_green },

  HighlightURL = { italic = true, bg = '#3f444a' },
  IndentLine = { fg = M.base4 },
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
