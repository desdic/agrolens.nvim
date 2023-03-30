; chef lxchosts
(pair key:(string) @normal (#eq? @normal "\"normal\"")
         value:(object (
            pair
                key:(string) @lxc (#eq? @lxc "\"lxc\"")
                value:(object (
                    pair 
                        key:(string) @guests (#eq? @guests "\"guests\"")
                        value:(object(pair key:(string) @agrolens.scope)))))))
