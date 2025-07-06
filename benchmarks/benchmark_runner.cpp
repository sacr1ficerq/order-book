#include <benchmark/benchmark.h>

#include "orderbook/utils.hpp"

static void BM_SampleTest(benchmark::State& state) {
    std::string filename("/workspace/tests/inp");
    orderbook::Updates updates = orderbook::load(filename);

    for (auto _ : state) {
        uint64_t result = orderbook::Solve(updates);
        benchmark::DoNotOptimize(result);
    }
}

BENCHMARK(BM_SampleTest);
