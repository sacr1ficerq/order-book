IMAGE_NAME := myclang

BUILD_DIR := build
TEST_BUILD_DIR := build_tests

WORKING_DIR := /workspace
SRC_MOUNT := --mount type=bind,source=.,target=$(WORKING_DIR)
BUILD_TYPE := Debug

TEST_EXECUTABLE := order_book_tests
MAIN_EXECUTABLE := main
BASELINE_EXECUTABLE := baseline

DOCKER_RUN := docker run --rm -t $(SRC_MOUNT) $(IMAGE_NAME)
DOCKER_INTERACTIVE := docker run --rm -it $(SRC_MOUNT) $(IMAGE_NAME)

.PHONY: all build configure run start clean test

all: build

# sentinel file to check if CMake has been configured
# this rule only runs if the build directory or its Makefile is missing
$(BUILD_DIR)/Makefile: CMakeLists.txt
	@echo "--- Configuring CMake ---"
	@$(DOCKER_RUN) cmake -S . -B $(BUILD_DIR) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE)

$(TEST_BUILD_DIR)/Makefile: CMakeLists.txt
	@echo "--- Configuring CMake for test build ---"
	@$(DOCKER_RUN) cmake -S . -B $(TEST_BUILD_DIR) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE)

build: $(BUILD_DIR)/Makefile
	@echo "--- Building Project ---"
	@$(DOCKER_RUN) cmake --build $(BUILD_DIR) --target $(MAIN_EXECUTABLE)
	@echo "--- Building Tests ---"
	@$(DOCKER_RUN) cmake --build $(BUILD_DIR) --target $(TEST_EXECUTABLE)
	@echo "--- Building Baseline ---"
	@$(DOCKER_RUN) cmake --build $(BUILD_DIR) --target $(BASELINE_EXECUTABLE)

run: build
	@echo "--- Running Executable ---"
	@$(DOCKER_RUN) $(WORKING_DIR)/$(BUILD_DIR)/$(MAIN_EXECUTABLE)

test: build
	@echo "--- Running Tests ---"
	@$(DOCKER_RUN) $(WORKING_DIR)/$(BUILD_DIR)/$(TEST_EXECUTABLE)

basseline: build
	@echo "--- Running Baseline ---"
	@$(DOCKER_RUN) $(WORKING_DIR)/$(BUILD_DIR)/$(BASELINE_EXECUTABLE)

start:
	@$(DOCKER_INTERACTIVE)

clean:
	@echo "--- Cleaning Build Directory ---"
	@if [ -d "$(BUILD_DIR)" ]; then rm -rf $(BUILD_DIR); fi
