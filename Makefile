.PHONY: all

all: lint test

test:
	nvim --headless -u scripts/minimal_init.lua -c "PlenaryBustedDirectory tests/ { minimal_init = './scripts/minimal_init.lua' }"

fmt:
	stylua lua/ --config-path=.stylua.toml

lint:
	luacheck lua/telescope

deps:
	@mkdir -p deps
	git clone --depth 1 https://github.com/echasnovski/mini.nvim deps/mini.nvim

documentation:
	nvim --headless --noplugin -u ./scripts/minimal_init_doc.lua -c "lua require('mini.doc').generate()" -c "qa!"

documentation-ci: deps documentation
