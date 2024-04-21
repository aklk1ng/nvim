local M = {}

local query_tbl = {
  ['function'] = {
    ['go'] = [[
    (function_declaration
        name: (identifier) @function_name)
    (method_declaration
        name: (field_identifier) @function_name)
    ]],
    ['lua'] = [[
    (function_declaration
        name: (identifier) @function_name)
    ]],
    ['rust'] = [[
    (function_item
        name: (identifier) @function_name)
    ]],
    ['python'] = [[
    (function_definition
        name: (identifier) @function_name)
    ]],
    ['c'] = [[
    (function_definition
        declarator: (function_declarator
            declarator: (identifier) @function_name)
        )
    ]],
    ['cpp'] = [[
    (function_definition
        declarator: (function_declarator
            declarator: (identifier) @function_name)
        )
    ]],
  },
  ['class'] = {
    ['cpp'] = [[
    (class_specifier
        name: (type_identifier) @class_name)
    ]],
    ['python'] = [[
    (class_definition
        name: (identifier) @class_name)
    ]],
  },
}

local function jump(obj, direct)
  local ts = vim.treesitter
  local ft = vim.bo.filetype
  local lang = vim.treesitter.language.get_lang(ft)
  if not lang then
    vim.notify('No treesitter parser for current language')
    return
  end

  local query = query_tbl[obj][ft]
  if not query then
    vim.notify('No valid query for current language')
  end

  local parser = ts.get_parser(0, lang)
  local tree = parser:parse()[1]
  local root = tree:root()

  local query_obj = vim.treesitter.query.parse(lang, query)

  local matches = {}
  ---@diagnostic disable-next-line: unused-local
  for pattern, match, metadata in query_obj:iter_matches(root, 0) do
    for id, node in pairs(match) do
      local name = query_obj.captures[id]
      if name == obj .. '_name' then
        table.insert(matches, node)
      end
    end
  end

  if #matches > 0 then
    local nearest_node = nil
    local nearest_dist = nil
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))

    for _, node in ipairs(matches) do
      local sr, sc, _, _ = node:range()
      local dist = math.abs(sr - row)

      if dist ~= 1 and direct == 'prev' and (sr < row or (sr == row and sc < col)) then
        if nearest_dist == nil or dist < nearest_dist then
          nearest_dist = dist
          nearest_node = node
        end
      elseif dist ~= 1 and direct == 'next' and (sr > row or (sr == row and sc > col)) then
        if nearest_dist == nil or dist < nearest_dist then
          nearest_dist = dist
          nearest_node = node
        end
      end
    end

    if nearest_node then
      local sr, sc, _, _ = nearest_node:range()
      vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
    end
  end
end

function M.jump_prev_func()
  jump('function', 'prev')
end

function M.jump_next_func()
  jump('function', 'next')
end

function M.jump_prev_class()
  jump('class', 'prev')
end

function M.jump_next_class()
  jump('class', 'next')
end

return M
