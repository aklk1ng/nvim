; extends

(table_constructor
  [
    "{"
    "}"
  ] @punctuation.bracket)

; function xxx() end
(function_declaration
  name: (identifier) @Definition)

; function M.xxx() end
(function_declaration
  name: (method_index_expression
    method: (identifier) @Definition))

; _G.xxx
(assignment_statement
  (variable_list
    name: (dot_index_expression
      field: (identifier) @Definition))
  (expression_list
    value: (function_definition)))

; a = function() end
(assignment_statement
  (variable_list
    name: (identifier) @Definition)
  (expression_list
    value: (function_definition)))

; M.xxx
(function_declaration
  name: (dot_index_expression
    field: (identifier) @Definition))
