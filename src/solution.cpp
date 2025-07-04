#include <cstdint>
#include <algorithm>
#include <array>

#include "orderbook/utils.hpp"

namespace orderbook {

uint64_t Solve(const Updates& updates) {
    uint64_t result = 0;
    
    alignas(64) std::array<Update, 400 + 1> book1{};
    alignas(64) std::array<Update, 400 + 1> book2{};
    
    Update* current_book = book1.data();
    Update* next_book = book2.data();
    Update* current_end = current_book;
    
    for (const auto& [update, shares] : updates) {
        uint64_t cur_result = 0;

        const Update* cur_ptr = current_book;
        const Update* update_ptr = update.data();
        const Update* update_end = update.data() + update.size();
        Update* next_ptr = next_book;
        uint32_t shares_rem = shares;

        while (cur_ptr != current_end && update_ptr != update_end) {
            if (cur_ptr->price < update_ptr->price) {
                *next_ptr = *cur_ptr++;

                const uint32_t take = std::min(shares_rem, next_ptr->quantity);
                cur_result += static_cast<uint64_t>(take) * next_ptr->price;
                shares_rem -= take;

                ++next_ptr;
            } else {
                *next_ptr = *update_ptr;

                const uint32_t take = std::min(shares_rem, next_ptr->quantity);
                cur_result += static_cast<uint64_t>(take) * next_ptr->price;
                shares_rem -= take;

                next_ptr += bool(update_ptr->quantity);
                cur_ptr += bool(update_ptr->price == cur_ptr->price);
                ++update_ptr;
            }
        }
        
        while (cur_ptr != current_end) {
            *next_ptr = *cur_ptr++;

            const uint32_t take = std::min(shares_rem, next_ptr->quantity);
            cur_result += static_cast<uint64_t>(take) * next_ptr->price;
            shares_rem -= take;

            ++next_ptr;
        }

        while (update_ptr != update_end) {
            *next_ptr = *update_ptr;

            const uint32_t take = std::min(shares_rem, next_ptr->quantity);
            cur_result += static_cast<uint64_t>(take) * next_ptr->price;
            shares_rem -= take;

            next_ptr += bool(update_ptr->quantity);
            ++update_ptr;
        }
        
        result ^= cur_result;
        
        std::swap(current_book, next_book);
        current_end = next_ptr;
    }
    
    return result;
}

} // namespace orderbook
