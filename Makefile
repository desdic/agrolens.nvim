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
	git clone --depth 1 https://github.com/echasnovski/mini.nvim deps/mini.nvim

localsetup:
	ln -s ~/.local/share/nvim/lazy/nvim-treesitter ~/.local/share/nvim/site/pack/vendor/start/nvim-treesitter.git

documentation:
	nvim --headless --noplugin -u ./scripts/minimal_init_doc.lua -c "lua require('mini.doc').generate()" -c "qa!"

documentation-ci: deps documentation
