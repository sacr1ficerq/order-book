IMAGE_NAME := myclang

BUILD_DIR := build
TESTS_DIR := tests/data/
REPORT_DIR := report
INPUT_FILENAME := input.txt

WORKING_DIR := /workspace
SRC_MOUNT := --mount type=bind,source=.,target=$(WORKING_DIR)
BUILD_TYPE := Release

TEST_EXECUTABLE := solution_tests
SOLUTION_EXECUTABLE := solution
BASELINE_EXECUTABLE := baseline
BENCHMARK_EXECUTABLE := solution_benchmarks
BASELINE_BENCHMARK_EXECUTABLE := baseline_benchmarks

LIB_FILES = src/utils.cpp include/orderbook/utils.hpp
SOLUTION_FILES = src/solution.cpp $(LIB_FILES)
BASELINE_FILES = src/baseline.cpp $(LIB_FILES)
BENCHMARK_FILES = benchmarks/benchmark_runner.cpp $(LIB_FILES)
TESTS_FILES = tests/utils_test.cpp $(LIB_FILES) $(SOLUTION_FILES)

DOCKER_RUN := docker run --cap-add SYS_ADMIN --rm -t $(SRC_MOUNT) $(IMAGE_NAME) 
DOCKER_INTERACTIVE := docker run --cap-add SYS_ADMIN --rm -it $(SRC_MOUNT) $(IMAGE_NAME)

BENCHMARK_FLAGS :=  --benchmark_time_unit=ms \
				  --benchmark_perf_counters=cycles,instructions,cache-references,cache-misses,L1-dcache-load-misses,L1-icache-load-misses,LLC-load-misses,branch-misses,iTLB-load-misses,dTLB-load-misses,page-faults \
				  --benchmark_repetitions=1 \
				  --benchmark_enable_random_interleaving=true \

.PHONY: all build solution baseline benchmark start clean test profile

all: build

# sentinel file to check if CMake has been configured
# this rule only runs if the build directory or its Makefile is missing
$(BUILD_DIR)/Makefile: CMakeLists.txt
	@echo "--- Configuring CMake ---"
	@$(DOCKER_RUN) cmake -S . -B $(BUILD_DIR) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE)

$(BUILD_DIR)/$(SOLUTION_EXECUTABLE): $(BUILD_DIR)/Makefile $(SOLUTION_FILES)
	@echo "--- Building Solution ---"
	@$(DOCKER_RUN) cmake --build $(BUILD_DIR) --target $(SOLUTION_EXECUTABLE)

$(BUILD_DIR)/$(TEST_EXECUTABLE): $(BUILD_DIR)/Makefile $(TESTS_FILES)
	@echo "--- Building Tests ---"
	@$(DOCKER_RUN) cmake --build $(BUILD_DIR) --target $(TEST_EXECUTABLE) 

$(BUILD_DIR)/$(BASELINE_EXECUTABLE): $(BUILD_DIR)/Makefile $(BASELINE_FILES)
	@echo "--- Building Baseline ---"
	@$(DOCKER_RUN) cmake --build $(BUILD_DIR) --target $(BASELINE_EXECUTABLE)

$(BUILD_DIR)/$(BENCHMARK_EXECUTABLE): $(BUILD_DIR)/Makefile $(BENCHMARK_FILES) $(SOLUTION_FILES)
	@echo "--- Building Benchmark ---"
	@$(DOCKER_RUN) cmake --build $(BUILD_DIR) --target $(BENCHMARK_EXECUTABLE)

$(BUILD_DIR)/$(BASELINE_BENCHMARK_EXECUTABLE): $(BUILD_DIR)/Makefile $(BASELINE_FILES) $(BENCHMARK_FILES)
	@echo "--- Building Baseline Benchmark ---"
	@$(DOCKER_RUN) cmake --build $(BUILD_DIR) --target $(BASELINE_BENCHMARK_EXECUTABLE)

build: $(BUILD_DIR)/$(SOLUTION_EXECUTABLE) \
	   $(BUILD_DIR)/$(TEST_EXECUTABLE) \
	   $(BUILD_DIR)/$(BASELINE_EXECUTABLE) \
	   $(BUILD_DIR)/$(BENCHMARK_EXECUTABLE) \
	   $(BUILD_DIR)/$(BASELINE_BENCHMARK_EXECUTABLE)

profile:
	@echo "--- Configuring CMake ---"
	@$(DOCKER_RUN) cmake -S . -B $(BUILD_DIR) -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_CXX_FLAGS="-g -O2"
	@echo "--- Building Solution ---"
	@$(DOCKER_RUN) cmake --build $(BUILD_DIR) --target $(SOLUTION_EXECUTABLE)
	@echo "--- Building Baseline ---"
	@$(DOCKER_RUN) cmake --build $(BUILD_DIR) --target $(BASELINE_EXECUTABLE)
	@echo "--- Running Baseline Performance Tests ---"
	@$(DOCKER_RUN) perf stat -d -d -d $(WORKING_DIR)/$(BUILD_DIR)/$(BASELINE_EXECUTABLE) $(WORKING_DIR)/$(TESTS_DIR)/$(INPUT_FILENAME)
	@echo "--- Running Solution Performance Tests ---"
	@$(DOCKER_RUN) perf stat -d -d -d $(WORKING_DIR)/$(BUILD_DIR)/$(SOLUTION_EXECUTABLE) $(WORKING_DIR)/$(TESTS_DIR)/$(INPUT_FILENAME)

solution: $(BUILD_DIR)/$(SOLUTION_EXECUTABLE)
	@echo "--- Running Solution ---"
	@$(DOCKER_RUN) $(WORKING_DIR)/$(BUILD_DIR)/$(SOLUTION_EXECUTABLE) $(WORKING_DIR)/$(TESTS_DIR)/$(INPUT_FILENAME)

test: $(BUILD_DIR)/$(TEST_EXECUTABLE)
	@echo "--- Running Tests ---"
	@$(DOCKER_RUN) $(WORKING_DIR)/$(BUILD_DIR)/$(TEST_EXECUTABLE)

baseline: $(BUILD_DIR)/$(BASELINE_EXECUTABLE)
	@echo "--- Running Baseline ---"
	@$(DOCKER_RUN) $(WORKING_DIR)/$(BUILD_DIR)/$(BASELINE_EXECUTABLE) $(WORKING_DIR)/$(TESTS_DIR)/$(INPUT_FILENAME)

benchmark: $(BUILD_DIR)/$(BASELINE_BENCHMARK_EXECUTABLE) $(BUILD_DIR)/$(BENCHMARK_EXECUTABLE)
	@echo "--- Running Baseline Benchmark ---"
	@$(DOCKER_RUN) perf stat -d -d -d $(WORKING_DIR)/$(BUILD_DIR)/$(BASELINE_BENCHMARK_EXECUTABLE) $(BENCHMARK_FLAGS)
	@echo "--- Running Solution Benchmark ---"
	@$(DOCKER_RUN) perf stat -d -d -d $(WORKING_DIR)/$(BUILD_DIR)/$(BENCHMARK_EXECUTABLE) $(BENCHMARK_FLAGS)

start:
	@$(DOCKER_INTERACTIVE)

clean:
	@echo "--- Cleaning Build Directory ---"
	@if [ -d "$(BUILD_DIR)" ]; then rm -rf $(BUILD_DIR); fi
