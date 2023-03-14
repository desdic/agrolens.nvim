; function
(function_declaration(identifier) @rname) @rcapture

; function assignment
(assignment_statement
        (variable_list name:(identifier) @rname)
        (expression_list value:(function_definition))
    ) @rcapture
