#include <iostream>
#include <print>
#include <cstdint>
#include <vector>
#include <cstdlib>
#include <fstream>
#include <sstream>
#include <cassert>

#include "orderbook/utils.hpp"

int main(int argc, char** argv) {
    if (argc != 2) {
        std::cerr << "Usage: " << argv[0] << " FILENAME\n";
        std::exit(EXIT_FAILURE);
    }

    orderbook::Updates updates = orderbook::load(argv[1]);
    std::println("--- Ended reading file ---");

    std::println("Result: {}", orderbook::Solve(updates));

    return 0;
}
