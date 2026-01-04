.PHONY: all

all: lint test

test:
	nvim --headless -u scripts/minimal_init.lua -c "PlenaryBustedDirectory tests/ { minimal_init = './scripts/minimal_init.lua' }"

fmt:
	stylua lua/ --config-path=.stylua.toml

lint:
	luacheck lua/ --globals vim

deps:
	@mkdir -p deps
	mkdir -p ~/.local/share/nvim/site/pack/vendor/start
	git clone --depth 1 https://github.com/echasnovski/mini.nvim deps/mini.nvim || true
	git clone --depth 1 https://github.com/nvim-lua/plenary.nvim ~/.local/share/nvim/site/pack/vendor/start/plenary.nvim || true
	git clone --depth 1 https://github.com/nvim-treesitter/nvim-treesitter.git ~/.local/share/nvim/site/pack/vendor/start/nvim-treesitter.git || true

documentation:
	nvim --headless --noplugin -u ./scripts/minimal_init_doc.lua -c "lua require('mini.doc').generate()" -c "qa!"

documentation-ci: deps documentation
