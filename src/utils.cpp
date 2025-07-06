#include <iostream>
#include <print>
#include <cstdint>
#include <vector>
#include <cstdlib>
#include <fstream>
#include <sstream>
#include <stdexcept>
#include <cassert>
#include <algorithm>
#include <array>

#include "orderbook/utils.hpp"

#include "orderbookio/updates.pb.h" // Assumes your proto file is updates.proto

#include <google/protobuf/io/zero_copy_stream_impl.h>

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

static constexpr bool DEBUG = 0;

Updates load(const std::string& filename) {
    std::ifstream input(filename, std::ios::in | std::ios::binary);
    if (!input) {
        std::cerr << "Error: Could not open file\n";
        std::exit(EXIT_FAILURE);
    }

    google::protobuf::io::IstreamInputStream file_stream(&input);
    
    orderbookio::Updates proto_updates;
    if (!proto_updates.ParseFromZeroCopyStream(&file_stream)) {
        std::cerr << "Error: Could not parse updates\n";
        std::exit(EXIT_FAILURE);
    }

    Updates result;
    result.reserve(proto_updates.data_size());

    for (const auto& proto_row_with_shares : proto_updates.data()) {
        const auto& proto_row = proto_row_with_shares.row();
        
        UpdateRow user_row;
        user_row.reserve(proto_row.data_size());
        if (DEBUG) std::cout << proto_row.data_size() << std::endl;
        
        for (const auto& proto_update : proto_row.data()) {
            user_row.emplace_back(Update{
                .price = proto_update.price(), 
                .quantity = proto_update.quantity()
            });
            if (DEBUG) std::cout << user_row[user_row.size()-1].price << ' ' << user_row[user_row.size()-1].quantity << std::endl;
        }
        
        result.emplace_back(UpdateRowWithShares{
            .row = std::move(user_row),
            .shares = proto_row_with_shares.shares()
        });

        if (DEBUG) std::cout << proto_row_with_shares.shares() << std::endl;
    }

    return result;
}

} // namespace orderbook
