#include <benchmark/benchmark.h>

namespace hello_world {

static void BM_Sanity(benchmark::State& state) {
  for (auto _ : state) {
    benchmark::DoNotOptimize(42);
  }
}
BENCHMARK(BM_Sanity);

}  // namespace hello_world
