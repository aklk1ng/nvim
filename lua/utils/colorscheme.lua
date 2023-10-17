local M = {
  base0 = '#3f444a',
  base1 = '#5B6268',
  base2 = '#777d86',
  bg = '#161a24',
  bg1 = '#504945',
  bg_highlight = '#232731',
  bg_visual = '#343840',
  fg = '#bbc2cf',
  fg_alt = '#A7A7A7',
  red = '#DE7E7E',
  orange = '#CD7B46',
  yellow = '#CAA661',
  green = '#A2BA79',
  dark_green = '#92B35A',
  aqua = '#89b482',
  xxoo = '#79A9BB',
  fancy = '#A79060',
  blue = '#7CA99F',
  pink = '#C18383',
  purple = '#A995D1',
  brown = '#cc7a29',
  marble_gray = '#c2bd9f',
  grey = '#535459',
  grey_1 = '#919191',
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
  vim.g.terminal_color_7 = M.bg1
  vim.g.terminal_color_8 = M.brown
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
  WinSeparator = { fg = M.grey, bg = M.bg },
  Folded = { fg = M.fg, bg = M.base0 },
  CursorLineFold = { fg = M.yellow, bg = M.bg },
  EndOfBuffer = { fg = M.bg, bg = M.bg },
  Search = { fg = M.bg, bg = M.yellow },
  ColorColumn = { bg = M.bg_highlight },
  Conceal = { fg = M.fg_alt, bg = M.none },
  Cursor = { fg = M.none, reverse = true },
  vCursor = { fg = M.none, reverse = true },
  iCursor = { fg = M.none, reverse = true },
  lCursor = { fg = M.none, reverse = true },
  CursorIM = { fg = M.none, reverse = true },
  CursorColumn = { bg = M.bg_highlight },
  FoldColumn = { fg = M.base1, bg = M.bg },
  CursorLine = { bg = M.bg_highlight },
  LineNr = { fg = M.bg_visual },
  CursorLineNr = { fg = M.grey_1, bold = true },
  DiffAdd = { fg = M.green, bg = M.base0 },
  DiffChange = { fg = M.blue, bg = M.base0 },
  DiffDelete = { fg = M.red, bg = M.base0 },
  DiffText = { fg = M.orange, bg = M.bg },
  Directory = { fg = M.blue, bg = M.none },
  ErrorMsg = { fg = M.red, bg = M.none, bold = true },
  WarningMsg = { fg = M.yellow, bg = M.none, bold = true },
  ModeMsg = { fg = M.fg, bg = M.none, bold = true },
  MatchParen = { bg = M.grey },
  NonText = { fg = M.bg1 },
  Whitespace = { fg = M.base0 },
  SpecialKey = { fg = M.bg1 },
  Pmenu = { fg = M.fg, bg = M.bg_highlight },
  PmenuSel = { fg = M.bg, bg = M.blue },
  PmenuSelBold = { fg = M.bg, bg = M.blue },
  PmenuSbar = { bg = M.base0 },
  PmenuThumb = { fg = M.pink, bg = M.light_green },
  WildMenu = { fg = M.bg1, bg = M.green },
  StatusLine = { bg = M.bg },
  StatusLineNC = { bg = M.bg },
  NormalFloat = { fg = M.grey_1, bg = M.bg },
  Tabline = { fg = M.fg, bg = M.bg },
  TabLineSel = { fg = M.fg, bg = M.base0 },
  TabLineFill = { fg = M.fg, bg = M.bg },
  Visual = { bg = M.grey },
  VisualNOS = { fg = M.none, bg = M.bg_visual },
  QuickFixLine = { fg = M.pink, bold = true },
  Debug = { fg = M.orange },
  DebugBreakpoint = { fg = M.bg, bg = M.red },
  Boolean = { fg = M.orange },
  Number = { fg = M.fg_alt },
  Float = { fg = M.brown },
  PreProc = { fg = M.pink },
  PreCondit = { fg = M.pink },
  Include = { fg = M.pink },
  Define = { fg = M.purple },
  Conditional = { fg = M.pink },
  Repeat = { fg = M.purple },

  Keyword = { fg = M.pink },
  Typedef = { fg = M.orange },
  Exception = { fg = M.red },
  Statement = { fg = M.red },
  Error = { fg = M.red },
  StorageClass = { fg = M.orange },
  Tag = { fg = M.orange },
  Label = { fg = M.pink },
  Structure = { fg = M.orange },
  Operator = { fg = M.grey_1 },
  Title = { fg = M.orange, bold = true },
  Special = { fg = M.yellow },
  Function = { fg = M.blue },
  String = { fg = M.dark_green },
  Character = { fg = M.green },
  Type = { fg = M.fancy },
  Identifier = { fg = M.blue },
  Comment = { fg = M.base2 },
  Todo = { fg = M.pink },
  Delimiter = { fg = M.grey_1 },

  ['@function.builtin'] = { link = 'Function' },
  ['@function.macro'] = { fg = M.xxoo },
  ['@parameter'] = { link = '@variable' },
  ['@method'] = { link = 'Function' },
  ['@keyword.function'] = { fg = M.purple },
  ['@keyword.operator'] = { fg = M.orange },
  ['@keyword.return'] = { link = 'Repeat' },
  ['@property'] = { link = '@field' },
  ['@field'] = { fg = M.yellow },
  ['@type.qualifier'] = { fg = M.orange },
  ['@variable'] = { fg = M.fg_alt },
  ['@variable.builtin'] = { fg = M.marble_gray },
  ['@punctuation.bracket'] = { fg = M.grey_1 },
  ['@punctuation.delimiter'] = { fg = M.grey_1 },
  ['@punctuation.special'] = { fg = M.grey_1 },
  ['@text.literal'] = { fg = M.green },
  ['@text.strong'] = { fg = M.red },
  ['@text.todo'] = { bg = M.xxoo },
  ['@constant'] = { fg = M.pink },
  ['@constructor'] = { link = 'Function' },
  ['@namespace'] = { fg = M.xxoo },
  ['@attribute'] = { fg = M.yellow },

  diffAdded = { fg = M.dark_green },
  diffRemoved = { fg = M.red },
  diffChanged = { fg = M.blue },
  diffOldFile = { fg = M.yellow },
  diffNewFile = { fg = M.orange },
  diffFile = { fg = M.aqua },
  diffLine = { fg = M.grey },
  diffIndexLine = { fg = M.pink },

  GitSignsAdd = { fg = M.dark_green },
  GitSignsChange = { fg = M.blue },
  GitSignsDelete = { fg = M.red },
  GitSignsAddNr = { fg = M.dark_green },
  GitSignsChangeNr = { fg = M.blue },
  GitSignsDeleteNr = { fg = M.red },
  GitSignsAddLn = { bg = M.bg_visual },
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
  TelescopeNormal = { bg = M.bg },
  TelescopeSelection = { fg = M.yellow, bg = M.bg_highlight, bold = true },
  TelescopePromptTitle = { fg = M.bg, bg = M.blue },
  TelescopePromptBorder = { fg = M.bg, bg = M.bg },
  TelescopeResultsBorder = { fg = M.bg, bg = M.bg },
  TelescopeResultsTitle = { fg = M.bg, bg = M.pink },
  TelescopePreviewBorder = { fg = M.bg, bg = M.bg },
  TelescopePreviewTitle = { fg = M.bg, bg = M.green },
  -- nvim-cmp
  CmpItemAbbr = { fg = M.fg },
  CmpItemAbbrMatch = { fg = M.dark_green },
  CmpDoc = { link = 'Pmenu' },
  CmpItemKindKeyword = { fg = M.pink },
  CmpItemKindFunction = { fg = M.blue },
  CmpItemKindMethod = { fg = M.aqua },
  CmpItemKindModule = { fg = M.aqua },
  CmpItemKindVariable = { fg = M.marble_gray },
  CmpItemKindField = { fg = M.yellow },

  FloatBorder = { fg = M.grey_1 },
  -- Dashboard
  DashboardShortCut = { fg = M.pink },
  DashboardHeader = { fg = M.orange },
  DashboardCenter = { fg = M.green },
  DashboardIcon = { fg = M.aqua },
  DashboardDesc = { fg = M.blue },
  DashboardKey = { fg = M.xxoo },
  DashboardFooter = { fg = M.yellow },

  IndentLine = { fg = M.base0 },

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
  vim.g.colors_name = 'aklk1ng'
  set_hl(syntax)
  M.terminal_color()
end

M.colorscheme()

return M
