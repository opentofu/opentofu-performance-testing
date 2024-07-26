# Number of tofu files 

This test scenario is designed to show the impact of lots of small tofu files on the parser and related systems.  It can be configured (with comments in run.sh) to generate outputs, locals, providers, etc...

## Used to validate:

### config parser.Sources https://github.com/opentofu/opentofu/pull/1811
AMD Custom APU 0932 (steamdeck) / 16GB / M.2 SSD

The call to parser.Sources copies a large map, which strains the GC and happens each time a new diagnostic is created.  When lots of diagnostics are emitted (warning or error), significant slowdowns occur.  For the following results, we configure ./run.sh to generate duplicate "null" providers.  This generates an equivalent number of diagnostics to files.  In reality this is a bit extreme, but for large scenarios the number of warning diagnostics can quickly add up.

Before:
Running small scenario
real    0m0.042s
user    0m0.050s
sys     0m0.015s

Running medium scenario
real    0m0.459s
user    0m0.719s
sys     0m0.081s

Running large scenario
real    0m41.506s
user    1m2.055s
sys     0m0.925s


After:
Running small scenario
real    0m0.044s
user    0m0.034s
sys     0m0.027s

Running medium scenario
real    0m0.162s
user    0m0.173s
sys     0m0.069s

Running large scenario
real    0m1.535s
user    0m2.048s
sys     0m0.393s

This confirms that we are taking the O(D * F) where D is the number of diagnostics and F is the number of files down to O(D) with the changes in the PR.
