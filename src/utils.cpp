#include <cstdint>
#include <algorithm>
#include <array>

#include "orderbook/utils.hpp"

namespace orderbook {

inline Update* merge(const Update* cur_ptr, const Update* current_end, const Update* update_ptr, const Update* update_end, Update* next_ptr) {
    while (cur_ptr != current_end && update_ptr != update_end) {
        if (update_ptr->price < cur_ptr->price) {
            if (update_ptr->quantity > 0) {
                *next_ptr++ = *update_ptr;
            }
            ++update_ptr;
        } else if (cur_ptr->price < update_ptr->price) {
            *next_ptr++ = *cur_ptr;
            ++cur_ptr;
        } else {
            if (update_ptr->quantity > 0) {
                *next_ptr++ = *update_ptr;
            }
            ++cur_ptr;
            ++update_ptr;
        }
    }
    
    while (cur_ptr != current_end) {
        *next_ptr++ = *cur_ptr++;
    }
    
    while (update_ptr != update_end) {
        if (update_ptr->quantity > 0) {
            *next_ptr++ = *update_ptr;
        }
        ++update_ptr;
    }
    return next_ptr;
}

uint64_t Solve(const Updates& updates) {
    uint64_t result = 0;
    
    alignas(64) std::array<Update, 400 + 1> book1{};
    alignas(64) std::array<Update, 400 + 1> book2{};
    
    Update* current_book = book1.data();
    Update* next_book = book2.data();
    Update* current_end = current_book;
    
    for (const auto& [update, shares] : updates) {
        auto next_ptr = merge(current_book, current_end, update.data(), update.data() + update.size(), next_book);

        uint64_t cur_result = 0;
        uint32_t sharesRem = shares;
        const Update* p = next_book;
        
        while (sharesRem > 0 && p != next_ptr) {
            uint32_t take = std::min(sharesRem, p->quantity);
            cur_result += static_cast<uint64_t>(take) * p->price;
            sharesRem -= take;
            ++p;
        }
        
        result ^= cur_result;
        
        std::swap(current_book, next_book);
        current_end = next_ptr;
    }
    
    return result;
}

} // namespace orderbook
