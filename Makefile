IMAGE_NAME := myclang

BUILD_DIR := build
TESTS_DIR := tests
INPUT_FILENAME := input.txt

WORKING_DIR := /workspace
SRC_MOUNT := --mount type=bind,source=.,target=$(WORKING_DIR)
BUILD_TYPE := Release

TEST_EXECUTABLE := solution_tests
SOLUTION_EXECUTABLE := solution
BASELINE_EXECUTABLE := baseline
BENCHMARK_EXECUTABLE := solution_benchmarks
BASELINE_BENCHMARK_EXECUTABLE := baseline_benchmarks

DOCKER_RUN := docker run --rm -t $(SRC_MOUNT) $(IMAGE_NAME)
DOCKER_INTERACTIVE := docker run --rm -it $(SRC_MOUNT) $(IMAGE_NAME)

.PHONY: all build configure run start clean test

all: build

# sentinel file to check if CMake has been configured
# this rule only runs if the build directory or its Makefile is missing
$(BUILD_DIR)/Makefile: CMakeLists.txt
	@echo "--- Configuring CMake ---"
	@$(DOCKER_RUN) cmake -S . -B $(BUILD_DIR) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE)

build: $(BUILD_DIR)/Makefile
	@echo "--- Building Project ---"
	@$(DOCKER_RUN) cmake --build $(BUILD_DIR) --target $(SOLUTION_EXECUTABLE)
	@echo "--- Building Tests ---"
	@$(DOCKER_RUN) cmake --build $(BUILD_DIR) --target $(TEST_EXECUTABLE)
	@echo "--- Building Baseline ---"
	@$(DOCKER_RUN) cmake --build $(BUILD_DIR) --target $(BASELINE_EXECUTABLE)
	@echo "--- Building Benchmark ---"
	@$(DOCKER_RUN) cmake --build $(BUILD_DIR) --target $(BENCHMARK_EXECUTABLE)
	@echo "--- Building Baseline Benchmark ---"
	@$(DOCKER_RUN) cmake --build $(BUILD_DIR) --target $(BASELINE_BENCHMARK_EXECUTABLE)

run: build
	@echo "--- Running Executable ---"
	@$(DOCKER_RUN) $(WORKING_DIR)/$(BUILD_DIR)/$(MAIN_EXECUTABLE) $(WORKING_DIR)/$(TESTS_DIR)/$(INPUT_FILENAME)

test: build
	@echo "--- Running Tests ---"
	@$(DOCKER_RUN) $(WORKING_DIR)/$(BUILD_DIR)/$(TEST_EXECUTABLE)

baseline: build
	@echo "--- Running Baseline ---"
	@$(DOCKER_RUN) $(WORKING_DIR)/$(BUILD_DIR)/$(BASELINE_EXECUTABLE) $(WORKING_DIR)/$(TESTS_DIR)/$(INPUT_FILENAME)

run-baseline:
	@echo "--- Running Baseline ---"
	@$(DOCKER_RUN) $(WORKING_DIR)/$(BUILD_DIR)/$(BASELINE_EXECUTABLE) $(WORKING_DIR)/$(TESTS_DIR)/$(INPUT_FILENAME)

benchmark: build
	@echo "--- Running Benchmark ---"
	@$(DOCKER_RUN) $(WORKING_DIR)/$(BUILD_DIR)/$(BENCHMARK_EXECUTABLE)

baseline-benchmark: build
	@echo "--- Running Benchmark ---"
	@$(DOCKER_RUN) $(WORKING_DIR)/$(BUILD_DIR)/$(BASELINE_BENCHMARK_EXECUTABLE)

generate-test:
	@echo "--- Generating Tests ---"
	@python $(WORKING_DIR)/$(TESTS_DIR)/generate-test.py $(INPUT_FILENAME)


start:
	@$(DOCKER_INTERACTIVE)

clean:
	@echo "--- Cleaning Build Directory ---"
	@if [ -d "$(BUILD_DIR)" ]; then rm -rf $(BUILD_DIR); fi
