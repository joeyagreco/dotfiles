.PHONY: links 
links:
	$(PYTHON_COMMAND) $(PYTHON_SCRIPTS_PATH)/link_init.py

.PHONY: deps
deps: links setup-cargo setup-macos
	# install python package deps
	pip install --upgrade --quiet pip
	pip install --quiet -r $(DEPS_DIR_PATH)/requirements.txt

	# install brew deps
	brew update -q
	brew bundle -q --file=$(DEPS_DIR_PATH)/Brewfile
	brew cleanup -q

	# install go, cargo, and npm deps
	$(PYTHON_COMMAND) $(PYTHON_SCRIPTS_PATH)/deps_init.py

.PHONY: setup-cargo
setup-cargo:
	if ! command -v cargo >/dev/null 2>&1; then \
		echo "cargo could not be found, installing..."; \
		curl https://sh.rustup.rs -sSf | sh; \
	fi

.PHONY: setup-macos
setup-macos:
	@sudo ~/.macos

