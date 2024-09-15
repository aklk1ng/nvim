local keymap = vim.keymap

_G.map = function(mode, lhs, rhs, opts)
  keymap.set(mode, lhs, rhs, opts)
end

_G.cmd = function(str)
  return '<Cmd>' .. str .. '<CR>'
end

_G.P = function(v)
  print(vim.inspect(v))
  return v
end
