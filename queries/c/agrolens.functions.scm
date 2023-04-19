(function_definition declarator:
    (function_declarator declarator:(identifier) @agrolens.name)) @agrolens.scope

(function_definition declarator:
    (pointer_declarator declarator:(function_declarator declarator:(identifier) @agrolens.name))) @agrolens.scope

(function_definition
 type:(primitive_type)
 declarator:(pointer_declarator
  declarator:(pointer_declarator
   declarator:(function_declarator
    declarator:(identifier) @agrolens.name)))) @agrolens.scope
