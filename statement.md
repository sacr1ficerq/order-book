# Order Book

You are given N order updates with number of shares, apply them to the order book and calculate cost to buy given number of shares after each update.

As output can be huge find XOR of all computed costs.

## Solution Format

Implement the following function:

```cpp
uint64_t Solve(const Updates&) {
    // Your code here
}
```

Definition of structs for input data.

```cpp
#include <cstdint>
#include <vector>

struct Update {
    uint32_t price, quantity;
};

using UpdateRow = std::vector<Update>;

struct UpdateRowWithShares {
    UpdateRow row;
    uint32_t shares;
};

using Updates = std::vector<UpdateRowWithShares>;
```

One can expect structs to be defined in the solution, so don't write definition yourself!

## Input Specification
Every row of input data consists of two values: orderbook update and S, number of shares you need to buy.

Update consists of K pairs of integers: price (<=10^5) and quantity(<=10^9) of updated levels separated by whitespace, levels are sorted by price in ascending order.

The first update is full snapshot, further updates are incremental. Number of levels after each update never exceeds 400.

 S doesn't exceed total number of shares available. N <= 50_000

## Output Specification
Output XOR of all computed costs.

## Sample Input
```
[
    row = [[100, 5], [110, 10], [111, 1]], shares = 15,
    row = [[100, 1]], shares = 12,
    row = [[110,0], [120, 3]], shares = 4
]
```

## Sample Output
668

Orderbook after each update:

```
[[100, 5], [110, 10], [111, 1]], cost of 15 shares = 1600

[[100, 1], [110, 10], [111, 1]], cost of 12 shares = 1311

[[100, 1], [111, 1], [120, 3]], cost of 4 shares = 451
```

## Baseline

Here is the baseline solution, sent by dummy user. Try to beat it!

```cpp
#include <cstdint>
#include <algorithm>
#include <array>

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
            cur_result += sharesRem * p->price;
        }        

        result ^= cur_result;

        std::swap(ptrs1, ptrs2);
    }

    return result;
}
```
