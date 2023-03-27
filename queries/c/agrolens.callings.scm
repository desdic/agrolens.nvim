(expression_statement (call_expression function: (identifier) @agrolens.name)) @agrolens.scope
(binary_expression left:(call_expression function:(identifier) @agrolens.name)) @agrolens.scope
(expression_statement(assignment_expression right:(call_expression function:(identifier) @agrolens.name))) @agrolens.scope
(declaration declarator:(init_declarator value:(call_expression function:(identifier)@agrolens.name))) @agrolens.scope
(return_statement(call_expression function:(identifier) @agrolens.name)) @agrolens.scope
(declaration declarator:(init_declarator value:(call_expression function:(parenthesized_expression) @agrolens.name))) @agrolens.scope
