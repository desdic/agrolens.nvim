![Test](https://github.com/desdic/agrolens.nvim/actions/workflows/ci.yml/badge.svg)

![Agrolens](media/agrolens.png "Agrolens")

# What is Agrolens

Its an extention to telescope that runs pre-defined (or custom) tree-sitter queries on a buffer (or all buffers) and gives a quick view via telescope.

[![Agrolens.nvim demo](http://img.youtube.com/vi/qPXj1Egi64Y/0.jpg)](http://www.youtube.com/watch?v=qPXj1Egi64Y "Agrolens.nvim demo")


## Requirements

[Neovim 0.8+](https://github.com/neovim/neovim)

[Telescope](https://github.com/nvim-telescope/telescope.nvim)

[Plenary](https://github.com/nvim-lua/plenary.nvim)

[Nvim tree-sitter](https://github.com/nvim-treesitter/nvim-treesitter)

And the language you with to use is also required to be installed via Nvim tree-sitter

# Installation

Install 

Use your favorite plugin manager

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

# Usage

```
:Telescope agrolens <parameters>
```

## Parameters

| Parameter | Value(s) | Description |
| :-- | :--| :---------- |
| aliases | empty | Create aliases for longer lists of queries |
| query | functions,callings,comments,labels | A comma seperated list with queries you want to run |
| buffers | all | Run queries on all buffers | 
| disable_indentation | true/false(default) | Strips spaces from line when showing in telescope |
| include_hidden_buffers | true/false(default) | when all buffers are selected only the visible are shown unless `includehiddenbuffers` is true |
| match | name and string | Matches a variable (minus the agrolens namespace) from the query with a string. If no string is provided its the word where the cursor is |
| same_type | true(default)/false | default we only match on same filetype across buffers but you can run queries on all if you like |


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

## Json/Yaml/etc

Some file formats just doesn't fit into the category labels so custom ones have been made for different formats for json/yaml. See  [SUPPORTED](SUPPORTED.md)

## Custom queries

You can place your custom queries in `~/.config/nvim/queries` you can load them just as with the build-in queries. So adding `myspecial.scm` as `~/.config/nvim/queries/c/myspecial.scm` enables you to run

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
