#include <benchmark/benchmark.h>

#include "orderbook/utils.hpp"

static void BM_SampleTest(benchmark::State& state) {
    orderbook::UpdateRow row1 = {{100, 5}, {110, 10}, {111, 1}};
    orderbook::UpdateRow row2 = {{100, 1}};
    orderbook::UpdateRow row3 = {{110, 0}, {120, 3}};

    std::vector<orderbook::UpdateRowWithShares> updates = {
        {row1, 15},
        {row2, 12},
        {row3, 4}
    };

    for (auto _ : state) {
        uint64_t result = orderbook::Solve(updates);

        benchmark::DoNotOptimize(result);
    }
}
BENCHMARK(BM_SampleTest);
