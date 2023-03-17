; function
(function_declaration(identifier) @agrolens.name) @agrolens.scope

; function assignment
(assignment_statement
        (variable_list name:(identifier) @agrolens.name)
        (expression_list value:(function_definition))
    ) @agrolens.scope

; method
(function_declaration name:(dot_index_expression field:(identifier) @agrolens.name)) @agrolens.scope

; method assignment
(assignment_statement
    (variable_list name:(dot_index_expression field:(identifier) @agrolens.name))
    (expression_list value:(function_definition))
) @agrolens.scope
