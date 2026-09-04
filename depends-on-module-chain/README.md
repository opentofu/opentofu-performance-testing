# Cross-module depends_on chain

Simulates the performance issue where `tofu plan` becomes extremely slow when
modules use cross-module `depends_on` in a chain pattern.

The script generates a chain of modules where each step depends on the previous
via `depends_on`, and `for_each` creates 10 instances per module. Each module is
a nested hierarchy of submodules, each containing a resource and data sources.

Note: `tofu plan` will report data source errors because no `terraform.data/`
files are generated. This is intentional — the benchmark measures graph
traversal time, and omitting the data files avoids disk I/O noise in the
timings.

## Parameters

| Variable | Default | Description |
|----------|---------|-------------|
| `TOFU` | `tofu` | Path to the OpenTofu binary |
| `CHAIN_LENGTH` | 10 | Number of modules in the `depends_on` chain |
| `DEPTH` | 4 | Nesting depth of submodules within each chain step |

## Usage

```bash
# Run with defaults (10 steps, depth 4)
bash run.sh

# Run with custom parameters
CHAIN_LENGTH=50 DEPTH=3 bash run.sh

# Run with a custom binary
TOFU=/tmp/tofu-custom bash run.sh

```

## Used to validate:

### Cross-module depends_on quadratic blowup https://github.com/opentofu/opentofu/issues/2987

Before (v1.13.0-dev, commit 3561785):

| Chain | Depth 1 | Depth 2 | Depth 3 | Depth 4 |
|-------|---------|---------|---------|---------|
| 1     | 0.10s   | 0.26s   | 0.22s   | 0.29s   |
| 2     | 0.08s   | 0.22s   | 0.30s   | 0.26s   |
| 5     | 0.08s   | 0.37s   | 2.28s   | 27.21s  |
| 10    | 0.08s   | 4.06s   | 4m4s    | >30m    |

After (upstream [#4465](https://github.com/opentofu/opentofu/pull/4465), commit fd6e26aa):

| Chain | Depth 1 | Depth 2 | Depth 3 | Depth 4 |
|-------|---------|---------|---------|---------|
| 1     | 0.20s   | 0.21s   | 0.23s   | 0.24s   |
| 2     | 0.20s   | 0.22s   | 0.29s   | 0.26s   |
| 5     | 0.21s   | 0.26s   | 0.35s   | 0.48s   |
| 10    | 0.26s   | 0.50s   | 0.79s   | 1.55s   |
| 50    | 2.68s   | 20.34s  | 1m7s    | 2m37s   |

After (local fix):

| Chain | Depth 1 | Depth 2 | Depth 3 | Depth 4 |
|-------|---------|---------|---------|---------|
| 1     | 0.19s   | 0.20s   | 0.23s   | 0.24s   |
| 2     | 0.19s   | 0.22s   | 0.25s   | 0.24s   |
| 5     | 0.19s   | 0.23s   | 0.27s   | 0.31s   |
| 10    | 0.22s   | 0.28s   | 0.34s   | 0.47s   |
| 50    | 0.48s   | 1.35s   | 2.20s   | 4.08s   |
