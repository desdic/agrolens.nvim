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
       sametype = true,
       includehiddenbuffers=false,
    }
}
```

# Usage

```
:Telescope agrolens <parameters>
```

## Parameters

| Parameter | Value(s) | Description |
| --- | ---| ----------- |
| query | functions,labels | A comma seperated list with queries you want to run |
| buffers | all | Run queries on all buffers | 
| includehiddenbuffers | true/false(default) | when all buffers are selected only the visible are shown unless `includehiddenbuffers` is true |
| sametype | true(default)/false | default we only match on same filetype across buffers but you can run queries on all if you like |
| match | name and string | Matches a variable (minus the agrolens namespace) from the query with a string. If no string is provided its the word where the cursor is |

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
:Telescope agrolens query=functions buffers=all includehiddenbuffers=true
```

Use query functions on all buffers but only if the `agrolens.name` matches the word on the cursor
```
:Telescope agrolens query=functions buffers=all match=name
```

Same query as above but `agrolens.name` must by either main or myfunc
```
:Telescope agrolens query=functions buffers=all match=name=main,name=myfunc
```

## Custom queries

You can place your custom queries in `~/.config/nvim/queries` you can load them just as with the build-in queries. So adding `myspecial.scm` as `~/.config/nvim/queries/c/myspecial.scm` enables you to run

```
:Telescope agrolens query=myspecial
```

# Similar plugins

[ziontee113/neo-minimap](https://github.com/ziontee113/neo-minimap)

# Help wanted

I don't use all supported languages and files supported by tree-sitter but if you do and want to contribute please make a MR

See the [CONTRIBUTING](CONTRIBUTING.md) for details.
