# Wide graph with submodules

The test in this directory exists to simulate a wide graph scenario with lots of submodules to expand.

## Used to validate:

### ModuleExpansionTransformer performance https://github.com/opentofu/opentofu/pull/1809
Apple M2 Pro / 32GB RAM

With 10x1000 modules, this dropped from 34s to 11s.
The time spent in ModuleExpansionTransformer dropped from ~18s to 190ms.

### tofu show performance https://github.com/opentofu/opentofu/pull/2323

Time spent in `loadFiles` dropped from 2.4s to 60ms.

Overall time before (at https://github.com/opentofu/opentofu/commit/be5b14625d2bcea594c22489e894b3ea4a6c8b6c):

```
real	0m4.765s
user	0m6.196s
sys     0m0.181s
```

After:

```
real	0m2.233s
user	0m3.673s
sys     0m0.170s
```

### tofu show performance https://github.com/opentofu/opentofu/pull/2324

Time spent in `marshalPlannedValues` dropped from 540ms to 120ms.

Overall time before (at https://github.com/opentofu/opentofu/commit/c280c23b4c4776c0985a159cf019a0b05dc8d486):

```
real	0m2.233s
user	0m3.673s
sys     0m0.170s
```

After:

```
real	0m1.856s
user	0m3.345s
sys     0m0.162s
```

### State DeepCopy Reduction https://github.com/opentofu/opentofu/issues/1579
AMD Ryzen 7 2700X / 64GB RAM / M.2 SSD

`time TOFU_CPU_PROFILE=prof.out TF_LOG=error TF_LOG_PROVIDER=error TF_LOG_SDK=error ~/go/bin/tofu apply --auto-approve`

main:
real    9m13.001s
user    25m46.813s
sys     0m44.164s

After https://github.com/opentofu/opentofu/pull/3011:
real    7m14.589s
user    22m4.922s
sys     0m43.872s

After https://github.com/opentofu/opentofu/pull/3110
real    0m32.476s
user    2m12.123s
sys     0m24.759s

Cutting the number of deep copies in half shows a significant benefit.  Removing the DeepCopy altogether dramatically
reduces the GC pressure and cuts the actual overhead of this test down by over an order of magnitude.
