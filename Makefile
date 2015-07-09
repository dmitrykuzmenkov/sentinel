INSTALL_TO=/opt/sentinel
BUILD_DIR=build
build:
	mkdir $(BUILD_DIR)
	mkdir $(BUILD_DIR)/tasks
	mkdir $(BUILD_DIR)/proc
	mkdir $(BUILD_DIR)/bin

	cp -r src build
	cp sentinel $(BUILD_DIR)
	echo "#!/bin/bash" > $(BUILD_DIR)/bin/sentinel
	echo "cd "$(INSTALL_TO)" && ./sentinel --daemonize" $$\@ >> $(BUILD_DIR)/bin/sentinel
	chmod +x $(BUILD_DIR)/bin/sentinel

clean:
	rm -fr build

install:
	@echo "Installing Sentinel into "$(INSTALL_TO)
	mkdir -p $(INSTALL_TO)
	cp -r build/* $(INSTALL_TO)
	ln -fs $(INSTALL_TO)/bin/sentinel /usr/bin/sentinel
	ldconfig

