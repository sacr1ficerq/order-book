--- Building Benchmark ---
[ 73%] Built target benchmark
[ 78%] Built target benchmark_main
[ 89%] Built target orderbook
[100%] Built target solution_benchmarks
--- Building Baseline Benchmark ---
[ 73%] Built target benchmark
[ 78%] Built target benchmark_main
[ 89%] Built target orderbook
[100%] Built target baseline_benchmarks
--- Running Solution Benchmark ---
{
  "context": {
    "date": "2025-07-04T23:16:13+00:00",
    "host_name": "def954293aec",
    "executable": "/workspace/build/solution_benchmarks",
    "num_cpus": 12,
    "mhz_per_cpu": 4280,
    "cpu_scaling_enabled": true,
    "aslr_enabled": true,
    "caches": [
      {
        "type": "Data",
        "level": 1,
        "size": 32768,
        "num_sharing": 2
      },
      {
        "type": "Instruction",
        "level": 1,
        "size": 32768,
        "num_sharing": 2
      },
      {
        "type": "Unified",
        "level": 2,
        "size": 524288,
        "num_sharing": 2
      },
      {
        "type": "Unified",
        "level": 3,
        "size": 16777216,
        "num_sharing": 12
      }
    ],
    "load_avg": [0.699707,0.847168,0.756836],
    "library_version": "v1.9.4",
    "library_build_type": "release",
    "json_schema_version": 1
  },
  "benchmarks": [
Performance counters not supported.
    {
      "name": "BM_SampleTest_mean",
      "family_index": 0,
      "per_family_instance_index": 0,
      "run_name": "BM_SampleTest",
      "run_type": "aggregate",
      "repetitions": 5,
      "threads": 1,
      "aggregate_name": "mean",
      "aggregate_unit": "time",
      "iterations": 5,
      "real_time": 3.5012518229996203e+01,
      "cpu_time": 3.5010380280000035e+01,
      "time_unit": "ms"
    },
    {
      "name": "BM_SampleTest_median",
      "family_index": 0,
      "per_family_instance_index": 0,
      "run_name": "BM_SampleTest",
      "run_type": "aggregate",
      "repetitions": 5,
      "threads": 1,
      "aggregate_name": "median",
      "aggregate_unit": "time",
      "iterations": 5,
      "real_time": 3.5011679849776556e+01,
      "cpu_time": 3.5009012250000104e+01,
      "time_unit": "ms"
    },
    {
      "name": "BM_SampleTest_stddev",
      "family_index": 0,
      "per_family_instance_index": 0,
      "run_name": "BM_SampleTest",
      "run_type": "aggregate",
      "repetitions": 5,
      "threads": 1,
      "aggregate_name": "stddev",
      "aggregate_unit": "time",
      "iterations": 5,
      "real_time": 3.5020816935032048e-02,
      "cpu_time": 3.5186336772108057e-02,
      "time_unit": "ms"
    },
    {
      "name": "BM_SampleTest_cv",
      "family_index": 0,
      "per_family_instance_index": 0,
      "run_name": "BM_SampleTest",
      "run_type": "aggregate",
      "repetitions": 5,
      "threads": 1,
      "aggregate_name": "cv",
      "aggregate_unit": "percentage",
      "iterations": 5,
      "real_time": 1.0002370210843256e-03,
      "cpu_time": 1.0050258377858449e-03,
      "time_unit": "ms"
    }
  ]
}

 Performance counter stats for '/workspace/build/solution_benchmarks --benchmark_time_unit=ms --benchmark_perf_counters=cycles,instructions,cache-references,cache-misses,L1-dcache-load-misses,L1-icache-load-misses,LLC-load-misses,branch-misses,iTLB-load-misses,dTLB-load-misses,page-faults --benchmark_repetitions=5 --benchmark_enable_random_interleaving=true --benchmark_report_aggregates_only=true --benchmark_format=json --benchmark_out=report/solution_benchmark.json':

          35334.86 msec task-clock                       #    1.000 CPUs utilized             
               180      context-switches                 #    5.094 /sec                      
                86      cpu-migrations                   #    2.434 /sec                      
             40065      page-faults                      #    1.134 K/sec                     
      148857941353      cycles                           #    4.213 GHz                         (35.71%)
        5710804213      stalled-cycles-frontend          #    3.84% frontend cycles idle        (35.72%)
      544002440806      instructions                     #    3.65  insn per cycle            
                                                  #    0.01  stalled cycles per insn     (35.72%)
      111497559090      branches                         #    3.155 G/sec                       (35.72%)
         199311570      branch-misses                    #    0.18% of all branches             (35.72%)
      171412848502      L1-dcache-loads                  #    4.851 G/sec                       (35.72%)
         431802562      L1-dcache-load-misses            #    0.25% of all L1-dcache accesses   (35.71%)
   <not supported>      LLC-loads                                                             
   <not supported>      LLC-load-misses                                                       
        5083208743      L1-icache-loads                  #  143.858 M/sec                       (35.71%)
           7227369      L1-icache-load-misses            #    0.14% of all L1-icache accesses   (35.71%)
          11161678      dTLB-loads                       #  315.883 K/sec                       (35.71%)
           5182083      dTLB-load-misses                 # [31m  46.43%[m of all dTLB cache accesses  (35.71%)
            227305      iTLB-loads                       #    6.433 K/sec                       (35.71%)
           1841473      iTLB-load-misses                 # [31m 810.13%[m of all iTLB cache accesses  (35.71%)
         328184068      L1-dcache-prefetches             #    9.288 M/sec                       (35.71%)
   <not supported>      L1-dcache-prefetch-misses                                             

      35.338529295 seconds time elapsed

      34.938257000 seconds user
       0.396968000 seconds sys


--- Running Baseline Benchmark ---
{
  "context": {
    "date": "2025-07-04T23:16:48+00:00",
    "host_name": "dcf1763e4b12",
    "executable": "/workspace/build/baseline_benchmarks",
    "num_cpus": 12,
    "mhz_per_cpu": 4280,
    "cpu_scaling_enabled": true,
    "aslr_enabled": true,
    "caches": [
      {
        "type": "Data",
        "level": 1,
        "size": 32768,
        "num_sharing": 2
      },
      {
        "type": "Instruction",
        "level": 1,
        "size": 32768,
        "num_sharing": 2
      },
      {
        "type": "Unified",
        "level": 2,
        "size": 524288,
        "num_sharing": 2
      },
      {
        "type": "Unified",
        "level": 3,
        "size": 16777216,
        "num_sharing": 12
      }
    ],
    "load_avg": [0.896484,0.881836,0.772461],
    "library_version": "v1.9.4",
    "library_build_type": "release",
    "json_schema_version": 1
  },
  "benchmarks": [
Performance counters not supported.
    {
      "name": "BM_SampleTest_mean",
      "family_index": 0,
      "per_family_instance_index": 0,
      "run_name": "BM_SampleTest",
      "run_type": "aggregate",
      "repetitions": 5,
      "threads": 1,
      "aggregate_name": "mean",
      "aggregate_unit": "time",
      "iterations": 5,
      "real_time": 3.9471268733258420e+01,
      "cpu_time": 3.9468536911111073e+01,
      "time_unit": "ms"
    },
    {
      "name": "BM_SampleTest_median",
      "family_index": 0,
      "per_family_instance_index": 0,
      "run_name": "BM_SampleTest",
      "run_type": "aggregate",
      "repetitions": 5,
      "threads": 1,
      "aggregate_name": "median",
      "aggregate_unit": "time",
      "iterations": 5,
      "real_time": 3.9375217555465902e+01,
      "cpu_time": 3.9372852222222257e+01,
      "time_unit": "ms"
    },
    {
      "name": "BM_SampleTest_stddev",
      "family_index": 0,
      "per_family_instance_index": 0,
      "run_name": "BM_SampleTest",
      "run_type": "aggregate",
      "repetitions": 5,
      "threads": 1,
      "aggregate_name": "stddev",
      "aggregate_unit": "time",
      "iterations": 5,
      "real_time": 2.2972522254388736e-01,
      "cpu_time": 2.2989771007353746e-01,
      "time_unit": "ms"
    },
    {
      "name": "BM_SampleTest_cv",
      "family_index": 0,
      "per_family_instance_index": 0,
      "run_name": "BM_SampleTest",
      "run_type": "aggregate",
      "repetitions": 5,
      "threads": 1,
      "aggregate_name": "cv",
      "aggregate_unit": "percentage",
      "iterations": 5,
      "real_time": 5.8200617795272774e-03,
      "cpu_time": 5.8248348701473475e-03,
      "time_unit": "ms"
    }
  ]
}

 Performance counter stats for '/workspace/build/baseline_benchmarks --benchmark_time_unit=ms --benchmark_perf_counters=cycles,instructions,cache-references,cache-misses,L1-dcache-load-misses,L1-icache-load-misses,LLC-load-misses,branch-misses,iTLB-load-misses,dTLB-load-misses,page-faults --benchmark_repetitions=5 --benchmark_enable_random_interleaving=true --benchmark_report_aggregates_only=true --benchmark_format=json --benchmark_out=report/baseline_benchmark.json':

          34479.25 msec task-clock                       #    1.000 CPUs utilized             
               168      context-switches                 #    4.872 /sec                      
                76      cpu-migrations                   #    2.204 /sec                      
             40064      page-faults                      #    1.162 K/sec                     
      145134772033      cycles                           #    4.209 GHz                         (35.72%)
        4011355266      stalled-cycles-frontend          #    2.76% frontend cycles idle        (35.72%)
      533052292419      instructions                     #    3.67  insn per cycle            
                                                  #    0.01  stalled cycles per insn     (35.72%)
      110985503120      branches                         #    3.219 G/sec                       (35.72%)
         205206659      branch-misses                    #    0.18% of all branches             (35.71%)
      170140166975      L1-dcache-loads                  #    4.935 G/sec                       (35.71%)
         378803070      L1-dcache-load-misses            #    0.22% of all L1-dcache accesses   (35.71%)
   <not supported>      LLC-loads                                                             
   <not supported>      LLC-load-misses                                                       
        5094426399      L1-icache-loads                  #  147.753 M/sec                       (35.71%)
           6933453      L1-icache-load-misses            #    0.14% of all L1-icache accesses   (35.71%)
          10096749      dTLB-loads                       #  292.835 K/sec                       (35.71%)
           4795723      dTLB-load-misses                 # [31m  47.50%[m of all dTLB cache accesses  (35.71%)
             89484      iTLB-loads                       #    2.595 K/sec                       (35.71%)
           1824423      iTLB-load-misses                 # [31m2038.83%[m of all iTLB cache accesses  (35.71%)
         300882319      L1-dcache-prefetches             #    8.726 M/sec                       (35.72%)
   <not supported>      L1-dcache-prefetch-misses                                             

      34.483291235 seconds time elapsed

      34.045198000 seconds user
       0.434964000 seconds sys


