# Makefile to install the update-hosts script

INSTALL_DIR := /usr/local/bin
SCRIPT_NAME := hostupd
SCRIPT_FILE := hostupd.sh

.PHONY: install uninstall

install:
	@echo "Installing $(SCRIPT_NAME) to $(INSTALL_DIR)..."
	install -m 0755 $(SCRIPT_FILE) $(INSTALL_DIR)/$(SCRIPT_NAME)
	@echo "Done."

uninstall:
	@echo "Removing $(SCRIPT_NAME) from $(INSTALL_DIR)..."
	rm -f $(INSTALL_DIR)/$(SCRIPT_NAME)
	@echo "Done."
