local get_node_text = vim.treesitter.get_node_text

local M = {}
local tbl = {
  ['conditional_expression'] = {
    'consequence',
    ' : ',
    'alternative',
  },
  ['assignment_expression'] = {
    'left',
    ' = ',
    'right',
  },
}

local function find_node(node)
  if not node then
    return
  end

  for k, _ in pairs(tbl) do
    if node:type() == k then
      return node
    end
  end
  node = node:parent()
  return find_node(node)
end

local function execute(l, concat, r, node, bufnr)
  local res = ''
  local left = node:field(l)
  local right = node:field(r)

  for i = 1, #right do
    res = res .. get_node_text(right[i], bufnr)
  end
  res = res .. concat
  for i = 1, #left do
    res = res .. get_node_text(left[i], bufnr)
  end

  local t = {}
  local lines = string.gmatch(res, '[^\r\n]+')
  for line in lines do
    table.insert(t, line)
  end

  -- replace the ternary with the swapped text
  local sr, sc = left[1]:start()
  local er, ec = right[#right]:end_()
  vim.api.nvim_buf_set_text(bufnr, sr, sc, er, ec, t)
end

function M.swap()
  local bufnr = vim.api.nvim_get_current_buf()
  if not vim.treesitter.language.get_lang(vim.bo[bufnr].filetype) then
    vim.notify('No treesitter parser for current language')
    return
  end

  local node = vim.treesitter.get_node({ bufnr })
  node = find_node(node)

  if not node then
    vim.notify('No expression found')
    return
  end

  local type = node:type()
  execute(tbl[type][1], tbl[type][2], tbl[type][3], node, bufnr)
end

return M
