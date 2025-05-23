# Large graph with simple dependencies

The test in this directory exists to simulate a large graph scenario with lots of simple dependencies to resolve.

## Used to validate:

### Graph debug logging performance https://github.com/opentofu/opentofu/pull/1810
AMD Ryzen 7 2700X / 64GB RAM / M.2 SSD

With the default of 1000x2 nodes, this went from 51s to 36s, a dramatic performance improvement for simply skipping some disabled logging functions.

### Resource evaluation locking https://github.com/opentofu/opentofu/pull/2835
AMD Ryzen 7 2700X / 64GB RAM / M.2 SSD

With the default of 1000x2 nodes, this went from 30s to 9s
