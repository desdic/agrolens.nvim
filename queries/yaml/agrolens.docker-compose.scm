; docker-compose.yml
(document
    (block_node
        (block_mapping
            (block_mapping_pair
                key: (flow_node (plain_scalar (string_scalar) @version (#eq? @version "version")))
                value: (flow_node(_) @agrolens.version)
            )
            (block_mapping_pair
                key: (flow_node(plain_scalar(string_scalar) @services (#eq? @services "services")))
                value: (block_node(block_mapping(block_mapping_pair key:(flow_node) @agrolens.name) @agrolens.scope))
            )
        )
    )
)

; (document
;     (block_node
;         (block_mapping
;             (block_mapping_pair 
;                 key:(flow_node) @name (#eq? @name "name"))
;             (block_mapping_pair
;                 key:(flow_node) @jobs (#eq? @jobs "jobs")
;                 value:(block_node(
;                     block_mapping(
;                         block_mapping_pair 
;                             key:(flow_node) @agrolens.scope
;                             value:(
;                                 block_node(
;                                     block_mapping(
;                                         block_mapping_pair 
;                                             key:(flow_node) @steps(#eq? @steps "steps")
;                                             value:(
;                                                 block_node(block_sequence(block_sequence_item(block_node(block_mapping(block_mapping_pair key:(flow_node) @agrolens.scope))  )))
; )))
;
; )
;
;
; ))
;             )
;         )
;      )
; )
; )
;
;
;  )
