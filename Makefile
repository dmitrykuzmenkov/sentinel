INSTALL_TO=/opt/sentinel
BUILD_DIR=build

all: check

check:
	which nano || which vim || which vi # check any editor

build:
	mkdir $(BUILD_DIR)
	mkdir $(BUILD_DIR)/tasks
	mkdir $(BUILD_DIR)/proc
	mkdir $(BUILD_DIR)/bin

	cp -r src build
	cp task.example $(BUILD_DIR)
	cp sentinel $(BUILD_DIR)
	cp LICENSE $(BUILD_DIR)
	cp README.md $(BUILD_DIR)
	echo "#!/bin/bash" > $(BUILD_DIR)/bin/sentinel
	echo "cd "$(INSTALL_TO)" && ./sentinel $$"'@' >> $(BUILD_DIR)/bin/sentinel
	chmod +x $(BUILD_DIR)/bin/sentinel

clean:
	rm -fr build

install:
	@echo "Installing Sentinel into "$(INSTALL_TO)
	mkdir -p $(INSTALL_TO)
	cp -r build/* $(INSTALL_TO)
	ln -fs $(INSTALL_TO)/bin/sentinel /usr/bin/sentinel
	ldconfig

