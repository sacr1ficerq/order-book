#include <cstdint>
#include <algorithm>
#include <array>

#include "orderbook/utils.hpp"

namespace orderbook {

template<typename It1_, typename It2_>
inline Update* mergeSnapDepth(const It1_& lhsBeg, const It1_& lhsEnd, const It2_& rhsBeg, const It2_& rhsEnd, Update* _Dest)
{
    auto _UFirst1 = lhsBeg;
    const auto _ULast1 = lhsEnd;
    auto _UFirst2 = rhsBeg;
    const auto _ULast2 = rhsEnd;
    Update* _UDest = _Dest;

    for (; _UFirst1 != _ULast1 && _UFirst2 != _ULast2;) {
        if (_UFirst2->price < _UFirst1->price) {
            *_UDest = *_UFirst2;
            ++_UDest;
            ++_UFirst2;
        }
        else {
            const bool bFirst = _UFirst1->quantity;
            _UDest->price = _UFirst1->price;
            _UDest->quantity =_UFirst1->quantity;
            _UDest += bFirst;

            _UFirst2 += !(_UFirst1->price < _UFirst2->price);
            ++_UFirst1;
        }
    }


    for (; _UFirst1 != _ULast1; ++_UFirst1) {
        const bool bFirst = _UFirst1->quantity;
        _UDest->price = _UFirst1->price;
        _UDest->quantity = _UFirst1->quantity;
        _UDest += bFirst;
    }

    _Dest = std::copy(_UFirst2, _ULast2, _UDest);

    return _Dest;
}

uint64_t Solve(const Updates& updates) {
    uint64_t result = 0;

    std::array<Update, 400 + 1> book1{};
    std::array<Update, 400 + 1> book2{};

    std::pair<Update*, Update*> ptrs1 = { book1.data(), book1.data() };
    std::pair<Update*, Update*> ptrs2 = { book2.data(), book2.data() };

    for (const auto& [update, shares] : updates) {
        uint64_t cur_result = 0;
        ptrs2.second = mergeSnapDepth(update.begin(), update.end(), ptrs1.first, ptrs1.second, ptrs2.first);

        uint32_t sharesRem = shares;
        Update* p = ptrs2.first;
        for (; p != ptrs2.second; ++p) {
            if (sharesRem < p->quantity) {
                break;
            }
            cur_result += p->quantity * p->price;
            sharesRem -= p->quantity;
        }
        if (p != ptrs2.second) {
            // I added static_cast because without it overflow possible (and it happens in my tests)
            cur_result += static_cast<uint64_t>(sharesRem) * p->price;
        }        

        result ^= cur_result;

        std::swap(ptrs1, ptrs2);
    }

    return result;
}

} // namespace orderbook
