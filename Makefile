.PHONY: all all-neovim lint lint-neovim test test-neovim

all: lint test

all-neovim: lint-neovim test-neovim

lint:
	@# @vint autoload plugin
	@vimlparser plugin/*.vim autoload/*/*.vim > /dev/null

lint-neovim:
	@# @vint --enable-neovim autoload plugin
	@vimlparser -neovim plugin/*.vim autoload/*/*.vim > /dev/null

test:
	@THEMIS_VIM=vim THEMIS_ARGS= themis

test-neovim:
	@THEMIS_VIM=nvim THEMIS_ARGS='-e -s --headless' themis
