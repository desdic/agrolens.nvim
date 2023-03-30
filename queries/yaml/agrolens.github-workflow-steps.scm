; github/workflow/ci.yml jobs
(document(
    block_node(
        block_mapping(
            block_mapping_pair
                key:(flow_node) @jobs (#eq? @jobs "jobs")
                value:(block_node(
                    block_mapping(
                        block_mapping_pair 
                            key:(flow_node)
                            value:(block_node(
                                block_mapping(
                                    block_mapping_pair
                                        key:(flow_node) @steps (#eq? @steps "steps")
                                        value:(block_node(_( block_sequence_item(
                                                block_node(
                                                    block_mapping(
                                                        block_mapping_pair
                                                            key:(flow_node) @agrolens.scope
                                                            value:(flow_node) @agrolens.name))))))))))))))))
