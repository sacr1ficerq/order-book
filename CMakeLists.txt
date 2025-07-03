cmake_minimum_required(VERSION 3.22)

project(order-book VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_EXPORT_COMPILE_COMMANDS TRUE) # for nvim.clangd

# set global flags before FetchContent to ensure googletest is compiled with libc++
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -stdlib=libc++")
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -stdlib=libc++")

add_library(orderbook src/utils.cpp)
target_include_directories(orderbook PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

add_executable(solution app/main.cpp src/solution.cpp)
target_link_libraries(solution PRIVATE orderbook)

add_executable(baseline app/main.cpp src/baseline.cpp)
target_link_libraries(baseline PRIVATE orderbook)

include(FetchContent)
FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG        v1.17.0
)

FetchContent_Declare(
    benchmark 
    GIT_REPOSITORY https://github.com/google/benchmark.git
    GIT_TAG        v1.9.4
)

FetchContent_MakeAvailable(googletest)
FetchContent_MakeAvailable(benchmark)

add_executable(solution_benchmarks benchmarks/benchmark_runner.cpp src/solution.cpp)
target_link_libraries(solution_benchmarks PRIVATE benchmark::benchmark_main orderbook)
target_include_directories(solution_benchmarks PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

add_executable(baseline_benchmarks benchmarks/benchmark_runner.cpp src/baseline.cpp)
target_link_libraries(baseline_benchmarks PRIVATE benchmark::benchmark_main orderbook)
target_include_directories(baseline_benchmarks PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

add_executable(solution_tests tests/utils_test.cpp src/solution.cpp)
target_link_libraries(solution_tests PRIVATE GTest::gtest_main orderbook)
target_include_directories(solution_tests PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
