(call_expression function:(field_expression value:(identifier) @agrolens.object field:(field_identifier) @agrolens.name)) @agrolens.scope
(call_expression function:(identifier) @agrolens.name) @agrolens.scope

(let_declaration value:(
    call_expression function:(
        scoped_identifier path:(identifier) @agrolens.object
        name:(identifier) @agrolens.name))) @agrolens.scope

(call_expression function:(field_expression field:(field_identifier) @agrolens.name)) @agrolens.scope

(call_expression function:(field_expression value:(call_expression) field:(field_identifier) @agrolens.name)) @agrolens.scope
