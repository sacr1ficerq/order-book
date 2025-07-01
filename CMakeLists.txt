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
