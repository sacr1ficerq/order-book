#include <iostream>
#include <print>
#include <cstdint>
#include <vector>
#include <cstdlib>
#include <fstream>
#include <sstream>
#include <cassert>
#include <algorithm>
#include <array>

#include "orderbook/utils.hpp"

namespace orderbook {
Updates parse_updates(const std::string& filename) {
    std::ifstream input(filename);
    if (!input) {
        std::cerr << "Error: Could not open file\n";
        std::exit(EXIT_FAILURE);
    }

    int num_rows;
    input >> num_rows;
    assert(num_rows <= 50'000);

    Updates updates;
    updates.reserve(num_rows);

    for (int i = 0; i < num_rows; ++i) {
        int num_pairs;
        input >> num_pairs;

        UpdateRow update_row;
        update_row.reserve(num_pairs);

        for (int j = 0; j < num_pairs; ++j) {
            uint32_t price, quantity;
            input >> price >> quantity;
            assert(price > 0 && price <= 100'000);
            assert(quantity <= 1'000'000'000);
            update_row.emplace_back(price, quantity);
        }

        uint32_t shares;
        input >> shares;
        updates.emplace_back(std::move(update_row), shares);

        if (!input) {
            std::cerr << "Error: Parse failed on iteration " << i << std::endl;
            std::exit(EXIT_FAILURE);
        }
    }
    return updates;
}
} // namespace orderbook
