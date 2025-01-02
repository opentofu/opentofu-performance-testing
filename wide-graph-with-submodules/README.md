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
