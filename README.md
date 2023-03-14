# Agrolens

![Test](https://github.com/desdic/agrolens.nvim/actions/workflows/ci.yml/badge.svg)

# What is Agrolens

Its an extention to telescope that runs pre-defined (or custom) treesitter queries on a buffer (or all buffers) and gives a quick view via telescope

## Requirements

[Neovim 0.8+](https://github.com/neovim/neovim)

[Telescope](https://github.com/nvim-telescope/telescope.nvim)

[Plenary](https://github.com/nvim-lua/plenary.nvim)

[Nvim treesitter](https://github.com/nvim-treesitter/nvim-treesitter)

And the language you with to use is also required to be installed via Nvim treesitter

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
       debug = false
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
| commands | functions,methods | A comma seperated list with queries you want to run |
| buffers | all | Run queries on all buffers | 
| includehiddenbuffers | true/false(default) | when all buffers are selected only the visible are shown unless `includehiddenbuffers` is true |

```
:Telescope agrolens commands=functions,methods
```

```
:Telescope agrolens commands=functions buffers=all
```

```
:Telescope agrolens commands=functions buffers=all includehiddenbuffers=true
```

# Help wanted

I don't use all supported languages and files supported by treesitter but if you do and want to contribute please make a MR

See the [CONTRIBUTING](CONTRIBUTING.md) for details.
