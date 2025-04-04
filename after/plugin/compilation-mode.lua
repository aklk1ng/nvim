---Store all compile commands.
---@type string[]
local compile_history = {}

local function compile_cb(command)
  table.insert(compile_history, command)
  _G.Terms.run({ cmd = command, id = 'Compilation' })
end

vim.api.nvim_create_user_command('Compile', function(args)
  local compile_command = ''
  if args.args == '' then
    if compile_history[#compile_history] then
      compile_command = compile_history[#compile_history]
    end
  else
    compile_command = args.args
  end
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
  compile_cb(compile_history[#compile_history])
end, {
  bang = true,
})

vim.keymap.set('n', '<leader>cc', ':Compile ')
vim.keymap.set('n', '<leader>cr', _G._cmd('ReCompile'))
