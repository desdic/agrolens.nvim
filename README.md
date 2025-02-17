![Test](https://github.com/desdic/agrolens.nvim/actions/workflows/ci.yml/badge.svg)

![Agrolens](media/agrolens.png "Agrolens")

# What is Agrolens

Its an extention to telescope that runs pre-defined (or custom) tree-sitter queries on a buffer (or all buffers) and gives a quick view via telescope.

[![Agrolens.nvim demo](http://img.youtube.com/vi/qPXj1Egi64Y/0.jpg)](http://www.youtube.com/watch?v=qPXj1Egi64Y "Agrolens.nvim demo")


## Requirements

[Neovim 0.10+](https://github.com/neovim/neovim)

[Nvim tree-sitter](https://github.com/nvim-treesitter/nvim-treesitter)

Language specific tree-sitter support is also needed (Depends on your needs)

Support for telescope requires:

[Telescope](https://github.com/nvim-telescope/telescope.nvim)

[Plenary](https://github.com/nvim-lua/plenary.nvim)

Support for fzf requires:

[Fzf-lua](https://github.com/ibhagwan/fzf-lua)

Support for snacks picker requires:

[Snacks](https://github.com/folke/snacks.nvim)


# Default options

Options are the same for fzf, snacks and telescope they are just added in different places

```lua
{
    -- Enable/Disable debug messages (is put in ~/.cache/nvim/agrolens.log)
    debug = false,

    -- Some tree-sitter plugins uses hidden buffers
    -- and we can enable those to if we want
    include_hidden_buffers = false,

    -- Make sure the query only runs on
    -- same filetype as the current one
    same_type = true,

    -- Match a given string or object
    -- Example `:Telescope agrolens query=callings buffers=all same_type=false match=name,object`
    -- this will query all callings but only those who match the word on the cursor
    match = nil,

    -- Disable displaying indententations in telescope
    disable_indentation = false,

    -- Alias can be used to join several queries into a single name
    -- Example: `aliases = { yamllist = "docker-compose,github-workflow-steps"}`
    aliases = {},

    -- Several internal functions can also be overwritten
    --
    -- Default entry maker (telescope only)
    -- entry_maker = agrolens.entry_maker
    --
    -- Default way of finding current directory
    -- cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.uv.cwd()
    --
    -- Default previewer (telescope only)
    -- previewer = conf.grep_previewer(opts)
    --
    -- Default sorting (telescope only)
    -- sorter = conf.generic_sorter(opts)

    -- Default enable devicons
    disable_devicons = false,

    -- display length
    display_width = 150,

    -- force long path name even when only a single buffer
    force_long_filepath = false,
}
```

# Setup

<details><summary>Fzf</summary>

```lua
{
    "desdic/agrolens.nvim",
    opts = {
        force_long_filepath = true,
        debug = false,
        same_type = false,
        include_hidden_buffers = false,
        disable_indentation = true,
        aliases = {
            yamllist = "docker-compose,github-workflow-steps",
            work = "cheflxchost,github-workflow-steps,pytest,ipam",
            all = "cheflxchost,pytest,ipam,functions,labels",
        },
    },
    keys = {
        {
            "zu",
            function()
                require("agrolens.fzf").run({
                    query = "functions,labels",
                    buffers = "all",
                    same_type = false,
                })
            end,
            desc = "find functions and labels",
        },
    },
}
```

</details>

<details><summary>Telescope</summary>

```lua
"desdic/agrolens.nvim"
```

Enable the extension in telescope

```lua
require "telescope".load_extension("agrolens")
```

## Default configuration

```lua
require("telescope").extensions = {
    agrolens = {
       debug = false,
       same_type = true,
       include_hidden_buffers = false,
       disable_indentation = false,
       aliases = {}
    }
}
```
</details>

<details><summary>Snacks</summary>

```lua
{
    "desdic/agrolens.nvim",
    opts = {
        force_long_filepath = true,
        debug = false,
        same_type = false,
        include_hidden_buffers = false,
        disable_indentation = true,
        aliases = {
            yamllist = "docker-compose,github-workflow-steps",
            work = "cheflxchost,github-workflow-steps,pytest,ipam",
            all = "cheflxchost,pytest,ipam,functions,labels",
        },
    },
    keys = {
        {
            "zu",
            function()
                require("agrolens.snacks").run({
                    query = "functions,labels",
                    buffers = "all",
                    same_type = false,
                })
            end,
            desc = "find functions and labels",
        },
    },
}
```

</details>

# Usage via Telescope

```
:Telescope agrolens <parameters>
```

## Parameters

| Parameter | Value(s) | Description |
| :-- | :--| :---------- |
| aliases | empty | Create aliases for longer lists of queries. |
| query | functions,callings,comments,labels | A comma seperated list with queries you want to run. |
| buffers | all | Run queries on all buffers. | 
| disable_indentation | true/false(default) | Strips spaces from line when showing in telescope. |
| include_hidden_buffers | true/false(default) | when all buffers are selected only the visible are shown unless `includehiddenbuffers` is true. |
| match | name and string | Matches a variable (minus the agrolens namespace) from the query with a string. If no string is provided its the word where the cursor is. |
| same_type | true(default)/false | default we only match on same filetype across buffers but you can run queries on all if you like. |
| jump | next/prev | Jump to the next or previous match of `agrolens.scope` based in query input. Only works on current buffer. |


Examples

Use queries from `agrolens.functions` and `agrolens.labels`
```
:Telescope agrolens query=functions,labels
```

Use query functions but run it on all buffers regards filetype
```
:Telescope agrolens query=functions buffers=all
```

Use query functions but run it on all buffers regards filetype and include hidden buffers. Some files are pre-loaded
due to to provide LSP/tree-sitter and you can search in those too
```
:Telescope agrolens query=functions buffers=all include_hidden_buffers=true
```

Use query functions on all buffers but only if the `agrolens.name` matches the word on the cursor
```
:Telescope agrolens query=functions buffers=all match=name
```

Or callings (functions/methods called) to find a function being called named `myfunctions` or a method of object `M`
```
:Telescope agrolens query=callings buffers=all match=name=myfunction,object=M
```

Same query as above but `agrolens.name` must by either main or myfunc
```
:Telescope agrolens query=functions buffers=all match=name=main,name=myfunc
```

Jump to next match in query `work`

```
:Telescope agrolens query=work jump=next
```

## Aliases

Using aliases its possible to create a new query name where its a list of other queries like

```
...
    aliases = {
        yamllist = "docker-compose,github-workflow-steps",
        work = "cheflxchost,github-workflow-steps,pytest",
    },
},
```

Using the query `yamllist` makes a combination of docker-compose, github-workflow-steps queries.

## Json/Yaml/etc

Some file formats just doesn't fit into the category labels so custom ones have been made for different formats for json/yaml. See  [SUPPORTED](SUPPORTED.md)

## Custom queries

You can place your custom queries in `~/.config/nvim/queries` you can load them just as with the build-in queries. So adding `myspecial` as `~/.config/nvim/queries/c/agrolens.myspecial.scm` enables you to run

```
:Telescope agrolens query=myspecial
```

## Generating queries

Agrolens can generate queries (or tries as good as it can) by invoking the generate function on the cursor position with

```lua
require("agrolens").generate({}))
```

Default options are:

| Options | Type | Description |
| :-- | :-- | :---------- |
| register | char | Register to copy to. Default ""|
| in_buffer | boolean | Create a buffer with query, default true|
| in_register | boolean | Copy query to register (clipboard), default true|
| full_document | boolean | Create query for full document/tree|
| all_captures | boolean | Create a capture group for every possible combination, default false|
| include_root_node | boolean | include root node, default false |

# Similar plugins

[ziontee113/neo-minimap](https://github.com/ziontee113/neo-minimap)

# Help wanted

I don't use all supported languages and files supported by tree-sitter but if you do and want to contribute please make a MR

See the [CONTRIBUTING](CONTRIBUTING.md) for details.
