(function_call name:(identifier) @agrolens.name) @agrolens.scope

(function_call name:(dot_index_expression table:(identifier) @agrolens.object field:(identifier) @agrolens.name)) @agrolens.scope

(function_call
 name:(method_index_expression
  table:(identifier)
  method:(identifier) @agrolens.name)) @agrolens.scope
