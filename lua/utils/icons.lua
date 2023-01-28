local M = {}

local kind_icons = {
  Text = '',
  Method = '',
  Function = '',
  Constructor = '',
  Field = '',
  Variable = '',
  Class = 'ﴯ',
  Interface = '',
  Module = '',
  Property = 'ﰠ',
  Unit = '',
  Value = '',
  Enum = '',
  Keyword = '',
  Snippet = '',
  Color = '',
  File = '',
  Reference = '',
  Folder = '',
  EnumMember = '',
  Constant = '',
  Struct = '',
  Event = '',
  Operator = '',
  TypeParameter = '',
  Error = ' ',
  Warn = ' ',
  Info = ' ',
  Hint = '',
  Fix = ' ',
  Todo = '',
  Hack = '',
  Perf = '',
  Note = '',
  Test = '⏲',
  Added = ' ',
  Changed = ' ',
  Deleted = ' ',
  Lock = '',
  DapBreakpoint = '',
  DapBreakpointCondition = '',
  DapBreakpointRejected = '',
  DapLogPoint = '.>',
  DapStopped = '󰁕',
}

function M.get(kind, space)
  return space and kind_icons[kind] .. ' ' or kind_icons[kind]
end

return M
