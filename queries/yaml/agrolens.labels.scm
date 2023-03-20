; docker-compose.yml
(document
    (block_node
        (block_mapping
            (block_mapping_pair
                key: (flow_node (plain_scalar (string_scalar) @version (#eq? @version "version")))
                value: (flow_node(double_quote_scalar) @agrolens.version)
            )
            (block_mapping_pair
                key: (flow_node(plain_scalar(string_scalar) @services (#eq? @services "services")))
                value: (block_node(block_mapping(block_mapping_pair key:(flow_node) @agrolens.name) @agrolens.scope))
            )
        )
    )
)
