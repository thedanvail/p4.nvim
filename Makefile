fmt:
	stylua lua/ --config-path=.stylua.toml

lint:
	luacheck lua/ --globals vim

test:
	nvim --headless --noplugin -u scripts/tests/minimal.vim \
        -c "PlenaryBustedDirectory lua/p4/test/ {minimal_init = 'scripts/tests/minimal.vim'}"

pr-ready: fmt lint test
