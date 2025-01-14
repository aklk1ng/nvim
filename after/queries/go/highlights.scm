; extends

; const xxx
(const_declaration
  (const_spec
    name: (identifier) @Constant))

; func xxx() {}
(function_declaration
  name: (identifier) @Definition)

; func (xx oo) xxx() {}
(method_declaration
  name: (field_identifier) @Definition)

; type xxx struct {}
(type_declaration
  (type_spec
    name: (type_identifier) @Definition
    type: (struct_type)))
