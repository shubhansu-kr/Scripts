VERSION = 1.0.0
INSTALL_DIR = $(HOME)/.local/bin
SCRIPT_NAME = git-boost

install:
	@bash install.sh

uninstall:
	rm -f $(INSTALL_DIR)/$(SCRIPT_NAME)

update:
	@echo "Updating $(SCRIPT_NAME) to v$(VERSION)..."
	cp git-boost.sh $(INSTALL_DIR)/$(SCRIPT_NAME)
	chmod +x $(INSTALL_DIR)/$(SCRIPT_NAME)
	@echo "Update complete."

echo:
	@echo "Run 'make install' to install $(SCRIPT_NAME)"

# Help documentation
help:
	@echo "Usage:"
	@echo "  make install    Install the script"
	@echo "  make uninstall  Uninstall the script"
	@echo "  make version    Show the version"
	@echo "  make help       Show this help message"