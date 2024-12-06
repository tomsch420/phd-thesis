NAME := typst
T_NAME := $(shell command -v lzof 2> /dev/null)
	
# Typst main file of document
SRC = thesis

.DEFAULT: help
help:
	@echo "Welcome to $(NAME)!"
	@echo "Use 'make <target>' where <target> is one of:"
	@echo ""
	@echo "  pdf	open the generated PDF"
	@echo "  build	build docker image based on shell ENV_VAR"
	@echo "  stop	stop docker container"
	@echo "  run	run docker container"
	@echo ""
	@echo "Go forth and make something great!"

pdf:	
	evince $(SRC).pdf

.PHONY: test
compile: 
	typst compile $(SRC).typ
	
.PHONY: check
watch: 
	typst watch $(SRC).typ
