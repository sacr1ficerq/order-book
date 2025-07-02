#include <iostream>
#include <print>
#include <cstdint>
#include <vector>

#include <gtest/gtest.h>

#include "orderbook/utils.hpp"

TEST(PublicTest, result) {
    orderbook::UpdateRow row1 = {{100, 5}, {110, 10}, {111, 1}};
    orderbook::UpdateRow row2 = {{100, 1}};
    orderbook::UpdateRow row3 = {{110, 0}, {120, 3}};

    std::vector<orderbook::UpdateRowWithShares> updates = {
        {row1, 15},
        {row2, 12},
        {row3, 4}
    };

    uint64_t result = orderbook::Solve(updates);

    EXPECT_EQ(result, 668);
}
