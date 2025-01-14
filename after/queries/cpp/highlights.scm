; extends

; TYPE xxx();
(function_definition
  type: (primitive_type)
  declarator: (function_declarator
    declarator: (identifier) @Definition))

; SCOPE::xxx() {}
(function_definition
  declarator: (function_declarator
    declarator: (qualified_identifier
      scope: (namespace_identifier)
      name: (identifier) @Definition)))

; SCOPE::~xxx() {}
(function_definition
  declarator: (function_declarator
    declarator: (qualified_identifier
      scope: (namespace_identifier)
      name: (destructor_name
        (identifier) @Definition))))
