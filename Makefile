.PHONY: test lint

all: lint test

lint:
	@vint autoload plugin
	@vimlparser plugin/*.vim  autoload/*.vim > /dev/null

test:
	@themis
