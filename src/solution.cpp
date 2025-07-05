#include <cstdint>
#include <algorithm>
#include <array>

#include "orderbook/utils.hpp"

namespace orderbook {

#pragma GCC optimize ("O3", "vectorize", "unroll-loops", "inline-functions", "omit-frame-pointer", "arch=native")

inline Update* merge(const Update* update_ptr, const Update* update_end,
        const Update* cur_ptr, const Update* current_end, Update* next_ptr)
{
    while (update_ptr != update_end && cur_ptr != current_end) {
        if (cur_ptr->price < update_ptr->price) *next_ptr++ = *cur_ptr++;
        else {
            *next_ptr = *update_ptr;
            next_ptr += bool(update_ptr->quantity);
            cur_ptr += bool(update_ptr->price == cur_ptr->price);
            ++update_ptr;
        }
    }

    while (update_ptr != update_end) {
        *next_ptr = *update_ptr;
        next_ptr += bool(update_ptr->quantity);
        ++update_ptr;
    }

    next_ptr = std::copy_if(cur_ptr, current_end, next_ptr, [](const Update x) { return x.quantity != 0; });
    next_ptr = std::copy(cur_ptr, current_end, next_ptr);

    return next_ptr;
}

uint64_t Solve(const Updates& updates) {
    uint64_t result = 0;

    std::array<Update, 400 + 1> book1{};
    std::array<Update, 400 + 1> book2{};

    std::pair<Update*, Update*> ptrs1 = { book1.data(), book1.data() };
    std::pair<Update*, Update*> ptrs2 = { book2.data(), book2.data() };

    for (const auto& [update, shares] : updates) {
        uint64_t cur_result = 0;
        const Update* update_ptr = update.data();
        const Update* update_end = update.data() + update.size();
        ptrs2.second = merge(update_ptr, update_end, ptrs1.first, ptrs1.second, ptrs2.first);

        uint32_t shares_rem = shares;
        for (auto p = ptrs2.first; shares_rem != 0; ++p) {
            const uint32_t take = std::min(shares_rem, p->quantity);
            cur_result += static_cast<uint64_t>(take) * p->price;
            shares_rem -= take;
        }

        result ^= cur_result;

        std::swap(ptrs1, ptrs2);
    }

    return result;
}

} // namespace orderbook
