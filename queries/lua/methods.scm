; method
(function_declaration name:(dot_index_expression field:(identifier) @rname)) @rcapture

; method assignment
(assignment_statement
    (variable_list name:(dot_index_expression field:(identifier) @rname))
    (expression_list value:(function_definition))
) @rcapture
