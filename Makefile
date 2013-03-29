.DEFAULT_GOAL := all
.PHONY: install

all: install build

build:
	@jekyll --no-auto --no-server

clean:
	@rm -rf _site

install:
	@gem install jekyll rdiscount
	@pip install pygments

run:
	@jekyll
