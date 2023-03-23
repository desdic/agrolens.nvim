
(expression_statement
    (binary_expression left:(
        binary_expression right:(
            call_expression
                function:(
                    field_expression
                        argument:(identifier) @agrolens.object
                        field:(field_identifier) @agrolens.name
                )
            )
        )
    )
) @agrolens.scope

(expression_statement(
    call_expression function:(
        field_expression
            argument:(identifier) @agrolens.object
            field:(field_identifier) @agrolens.name
))) @agrolens.scope

(expression_statement(call_expression
        function:(identifier) @agrolens.name)) @agrolens.scope

(declaration declarator:(init_declarator value:(call_expression function:(identifier) @agrolens.name))) @agrolens.scope
