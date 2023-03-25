(assignment_expression right:(function_call_expression function:(name) @agrolens.name)) @agrolens.scope

(assignment_expression right:(
    member_call_expression 
        object:(variable_name(name) @agrolens.object)
        name:(name) @agrolens.name
)) @agrolens.scope

(expression_statement(function_call_expression function:(name) @agrolens.name)) @agrolens.scope

(expression_statement(member_call_expression 
    object:(variable_name(name) @agrolens.object)
    name:(name) @agrolens.name
))  @agrolens.scope
