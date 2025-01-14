; extends

; neovim enum
((identifier) @constant
  (#lua-match? @constant "^k[A-Z]"))

; TYPE xxx();
(function_definition
  type: (primitive_type)
  declarator: (function_declarator
    declarator: (identifier) @Definition))

; TYPE xxx();
(function_definition
  type: (type_identifier)
  declarator: (function_declarator
    declarator: (identifier) @Definition))

; TYPE *xxx();
(function_definition
  type: (primitive_type)
  declarator: (pointer_declarator
    declarator: (function_declarator
      declarator: (identifier) @Definition)))

; const TYPE xxx;
(declaration
  (type_qualifier)
  type: (primitive_type)
  declarator: (identifier) @Constant)

; static const TYPE xxx;
(declaration
  (storage_class_specifier)
  (type_qualifier)
  type: (primitive_type)
  declarator: (identifier) @Constant)

; const static TYPE xxx;
(declaration
  (type_qualifier)
  (storage_class_specifier)
  type: (primitive_type)
  declarator: (identifier) @Constant)
