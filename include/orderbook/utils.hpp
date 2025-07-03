#pragma once

#include <cstdint>
#include <vector>
#include <string>

namespace orderbook {

struct Update {
    uint32_t price, quantity;
};

using UpdateRow = std::vector<Update>;

struct UpdateRowWithShares {
    UpdateRow row;
    uint32_t shares;
};

using Updates = std::vector<UpdateRowWithShares>;

uint64_t Solve(const Updates& updates);

Updates parse_updates(const std::string& filename);
} // namespace orderbook
