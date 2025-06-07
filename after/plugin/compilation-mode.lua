---@type string|nil
local last_command = nil

local function compile_cb(command)
  command = vim.fn.expandcmd(command)
  last_command = command
  _G.Terms.run({ cmd = command, id = 'Compilation' })
end

vim.api.nvim_create_user_command('Compile', function(args)
  local compile_command = nil
  compile_command = args.args == '' and last_command or args.args
  compile_cb(compile_command)
end, {
  nargs = '*',
  bang = true,
  --@see https://github.com/ej-shafran/compile-mode.nvim/blob/5a991e2e5ac7bce5825366734920e88793cf0577/plugin/command.lua#L5
  complete = function(_, cmdline)
    local cmd = cmdline:gsub('Compile%s+', '')
    local results = vim.fn.getcompletion(('!%s'):format(cmd), 'cmdline')
    return results
  end,
})

vim.api.nvim_create_user_command('ReCompile', function()
  if not last_command then
    return
  end

  compile_cb(last_command)
end, {
  bang = true,
})

vim.keymap.set('n', '<leader>cc', ':Compile ')
vim.keymap.set('n', '<leader>cr', _G._cmd('ReCompile'))
