#pragma once

#include <cstdint>
#include <vector>

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

} // namespace orderbook
