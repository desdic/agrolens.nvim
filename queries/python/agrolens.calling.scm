(expression_statement(call function:(identifier) @agrolens.name)) @agrolens.scope

(expression_statement(assignment(call function:(identifier) @agrolens.name))) @agrolens.scope

(expression_statement(
        call 
            function:(attribute object:(identifier) @agrolens.object
            attribute:(identifier) @agrolens.name))) @agrolens.scope

( expression_statement(
        assignment right:(
            call 
                function:(
                    attribute 
                        object:(identifier) @agrolens.object
                        attribute:(identifier) @agrolens.name)))) @agrolens.scope
