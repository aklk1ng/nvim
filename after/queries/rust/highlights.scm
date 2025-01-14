; extends

; struct xxx {}
(struct_item
  name: (type_identifier) @Definition)

; enum xxx {}
(enum_item
  name: (type_identifier) @Definition)

; trait xxx {}
(trait_item
  name: (type_identifier) @Definition
  body: (declaration_list
    (function_signature_item
      name: (identifier) @Definition)))

; fn xxx() {}
(function_item
  name: (identifier) @Definition)

; macro_rules! xxx {}
(macro_definition
  name: (identifier) @Definition)
