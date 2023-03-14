.PHONY: all

all: lint test

test:
	nvim --headless -u scripts/minimal_init.lua -c "PlenaryBustedDirectory tests/ { minimal_init = './scripts/minimal_init.lua' }"

lint:
	luacheck lua/telescope

