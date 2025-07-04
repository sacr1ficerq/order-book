IMAGE_NAME := myclang

BUILD_DIR := build
TESTS_DIR := tests
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

DOCKER_RUN := docker run --cap-add SYS_ADMIN --rm -t $(SRC_MOUNT) $(IMAGE_NAME) 
DOCKER_INTERACTIVE := docker run --cap-add SYS_ADMIN --rm -it $(SRC_MOUNT) $(IMAGE_NAME)

.PHONY: all build configure build-solution build-tests build-benchmarks build-baseline run-solution run-baseline benchmark start clean test profile

all: build

# sentinel file to check if CMake has been configured
# this rule only runs if the build directory or its Makefile is missing
$(BUILD_DIR)/Makefile: CMakeLists.txt
	@echo "--- Configuring CMake ---"
	@$(DOCKER_RUN) cmake -S . -B $(BUILD_DIR) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE)

build-solution: $(BUILD_DIR)/Makefile
	@echo "--- Building Solution ---"
	@$(DOCKER_RUN) cmake --build $(BUILD_DIR) --target $(SOLUTION_EXECUTABLE)

build-tests: $(BUILD_DIR)/Makefile
	@echo "--- Building Tests ---"
	@$(DOCKER_RUN) cmake --build $(BUILD_DIR) --target $(TEST_EXECUTABLE)

build-baseline: $(BUILD_DIR)/Makefile
	@echo "--- Building Baseline ---"
	@$(DOCKER_RUN) cmake --build $(BUILD_DIR) --target $(BASELINE_EXECUTABLE)

build-benchmarks: $(BUILD_DIR)/Makefile
	@echo "--- Building Benchmark ---"
	@$(DOCKER_RUN) cmake --build $(BUILD_DIR) --target $(BENCHMARK_EXECUTABLE)
	@echo "--- Building Baseline Benchmark ---"
	@$(DOCKER_RUN) cmake --build $(BUILD_DIR) --target $(BASELINE_BENCHMARK_EXECUTABLE)


build: build-solution build-tests build-baseline build-benchmarks

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

run-solution: build-solution
	@echo "--- Running Solution ---"
	@$(DOCKER_RUN) $(WORKING_DIR)/$(BUILD_DIR)/$(SOLUTION_EXECUTABLE) $(WORKING_DIR)/$(TESTS_DIR)/$(INPUT_FILENAME)

test: build-tests
	@echo "--- Running Tests ---"
	@$(DOCKER_RUN) $(WORKING_DIR)/$(BUILD_DIR)/$(TEST_EXECUTABLE)

run-baseline: build-baseline
	@echo "--- Running Baseline ---"
	@$(DOCKER_RUN) $(WORKING_DIR)/$(BUILD_DIR)/$(BASELINE_EXECUTABLE) $(WORKING_DIR)/$(TESTS_DIR)/$(INPUT_FILENAME)

benchmark: build-benchmarks
	@echo "--- Running Solution Benchmark ---"
	@$(DOCKER_RUN) perf stat -d -d -d $(WORKING_DIR)/$(BUILD_DIR)/$(BENCHMARK_EXECUTABLE) \
	  --benchmark_time_unit=ms \
	  --benchmark_perf_counters=cycles,instructions,cache-references,cache-misses,L1-dcache-load-misses,L1-icache-load-misses,LLC-load-misses,branch-misses,iTLB-load-misses,dTLB-load-misses,page-faults \
	  --benchmark_repetitions=5 \
	  --benchmark_enable_random_interleaving=true \
	  --benchmark_report_aggregates_only=true \
	  --benchmark_format=json \
	  --benchmark_out="$(REPORT_DIR)/solution_benchmark.json"
	@echo "--- Running Baseline Benchmark ---"
	@$(DOCKER_RUN) perf stat -d -d -d $(WORKING_DIR)/$(BUILD_DIR)/$(BASELINE_BENCHMARK_EXECUTABLE) \
	  --benchmark_time_unit=ms \
	  --benchmark_perf_counters=cycles,instructions,cache-references,cache-misses,L1-dcache-load-misses,L1-icache-load-misses,LLC-load-misses,branch-misses,iTLB-load-misses,dTLB-load-misses,page-faults \
	  --benchmark_repetitions=5 \
	  --benchmark_enable_random_interleaving=true \
	  --benchmark_report_aggregates_only=true \
	  --benchmark_format=json \
	  --benchmark_out="$(REPORT_DIR)/baseline_benchmark.json"

generate-test:
	@echo "--- Generating Tests ---"
	@python $(WORKING_DIR)/$(TESTS_DIR)/generate-test.py $(INPUT_FILENAME)

start:
	@$(DOCKER_INTERACTIVE)

clean:
	@echo "--- Cleaning Build Directory ---"
	@if [ -d "$(BUILD_DIR)" ]; then rm -rf $(BUILD_DIR); fi
