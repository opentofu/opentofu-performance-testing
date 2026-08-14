# Cross-module depends_on chain

Simulates the performance issue where `tofu plan` becomes extremely slow when
modules use cross-module `depends_on` in a chain pattern.

The script generates a chain of modules where each step depends on the previous
via `depends_on`, and `for_each` creates 10 instances per module. Each module is
a nested hierarchy of submodules, each containing a resource and data source.

## Parameters

| Variable | Default | Description |
|----------|---------|-------------|
| `CHAIN_LENGTH` | 10 | Number of modules in the `depends_on` chain |
| `DEPTH` | 4 | Nesting depth of submodules within each chain step |

## Usage

```bash
# Run with defaults (10 steps, depth 4)
bash run.sh

# Run with custom parameters
CHAIN_LENGTH=50 DEPTH=3 bash run.sh
```

## Used to validate:

### Cross-module depends_on quadratic blowup https://github.com/opentofu/opentofu/issues/2987

Before (v1.13.0-dev, commit 3561785):

| Chain | Depth 1 | Depth 2 | Depth 3 | Depth 4 |
|-------|---------|---------|---------|---------|
| 1     | 0.08s   | 0.18s   | 0.19s   | 0.21s   |
| 2     | 0.08s   | 0.18s   | 0.24s   | 0.20s   |
| 5     | 0.08s   | 0.21s   | 0.23s   | 0.46s   |
| 10    | 0.08s   | 0.27s   | 1.80s   | 35.25s  |
| 50    | 0.09s   | 42.86s  | >10m    | >10m    |

Expected (local fix):

| Chain | Depth 1 | Depth 2 | Depth 3 | Depth 4 |
|-------|---------|---------|---------|---------|
| 1     | 0.08s   | 0.22s   | 0.25s   | 0.22s   |
| 2     | 0.08s   | 0.19s   | 0.22s   | 0.24s   |
| 5     | 0.08s   | 0.22s   | 0.23s   | 0.28s   |
| 10    | 0.08s   | 0.25s   | 0.26s   | 0.32s   |
| 50    | 0.09s   | 0.69s   | 1.24s   | 2.09s   |
