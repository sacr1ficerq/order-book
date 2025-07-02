cmake_minimum_required(VERSION 3.22)

project(order-book VERSION 0.1.0 LANGUAGES CXX)

add_library(orderbook src/utils.cpp)

target_compile_features(orderbook PUBLIC cxx_std_23)

# include -stdlib=libc++ only when using clang
# I want a couple of c++23 features inside main and might add a few in library
if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    target_compile_options(orderbook PUBLIC -stdlib=libc++ -std=c++23)
    target_link_options(orderbook PUBLIC -stdlib=libc++ -std=c++23)
endif()

target_include_directories(orderbook
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
)

add_executable(main app/main.cpp)

target_link_libraries(main PRIVATE orderbook)


# set global flags before FetchContent to ensure googletest is compiled with libc++
if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -stdlib=libc++")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -stdlib=libc++")
endif()

include(FetchContent)
FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG        v1.17.0
)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

FetchContent_MakeAvailable(googletest)

add_executable(order_book_tests tests/utils_test.cpp)

target_link_libraries(order_book_tests PRIVATE
    GTest::gtest_main
    orderbook
)

if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    target_compile_options(order_book_tests PUBLIC -stdlib=libc++ -std=c++23)
    target_link_options(order_book_tests PUBLIC -stdlib=libc++ -std=c++23)
endif()

target_include_directories(order_book_tests PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)
