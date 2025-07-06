cmake_minimum_required(VERSION 3.22)

project(order-book VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_EXPORT_COMPILE_COMMANDS TRUE) # for nvim.clangd

# set global flags before FetchContent to ensure googletest is compiled with libc++
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -stdlib=libc++")
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -stdlib=libc++")

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

FetchContent_Declare(
    protobuf 
    GIT_REPOSITORY https://github.com/protocolbuffers/protobuf 
    GIT_TAG        v30.2
)

FetchContent_MakeAvailable(googletest)
FetchContent_MakeAvailable(benchmark)
FetchContent_MakeAvailable(protobuf)

find_package(Protobuf REQUIRED)

set(PROTO_FILES ${CMAKE_CURRENT_SOURCE_DIR}/proto/updates.proto)

# This command generates .pb.cc and .pb.h files from your .proto files.
# The generated files are placed in CMAKE_CURRENT_BINARY_DIR.
# PROTO_SRCS will contain the path to the generated .pb.cc file.
# PROTO_HDRS will contain the path to the generated .pb.h file.
protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS ${PROTO_FILES})

add_library(orderbook src/utils.cpp ${PROTO_SRCS})

target_include_directories(orderbook PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include ${CMAKE_CURRENT_BINARY_DIR})

target_link_libraries(orderbook PUBLIC protobuf::libprotobuf)

add_executable(solution app/main.cpp src/solution.cpp)
target_link_libraries(solution PRIVATE orderbook)

add_executable(baseline app/main.cpp src/baseline.cpp)
target_link_libraries(baseline PRIVATE orderbook)

add_executable(solution_benchmarks benchmarks/benchmark_runner.cpp src/solution.cpp)
target_link_libraries(solution_benchmarks PRIVATE benchmark::benchmark_main orderbook)
target_include_directories(solution_benchmarks PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

add_executable(baseline_benchmarks benchmarks/benchmark_runner.cpp src/baseline.cpp)
target_link_libraries(baseline_benchmarks PRIVATE benchmark::benchmark_main orderbook)
target_include_directories(baseline_benchmarks PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

add_executable(solution_tests tests/utils_test.cpp src/solution.cpp)
target_link_libraries(solution_tests PRIVATE GTest::gtest_main orderbook)
target_include_directories(solution_tests PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
