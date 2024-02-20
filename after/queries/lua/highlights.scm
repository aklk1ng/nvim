; extends

(table_constructor
[
  "{"
  "}"
] @punctuation.bracket)

((identifier) @namespace.builtin
  (#eq? @namespace.builtin "vim"))
