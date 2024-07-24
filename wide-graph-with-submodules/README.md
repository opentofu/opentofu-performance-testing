# Wide graph with submodules

The test in this directory exists to simulate a wide graph scenario with lots of submodules to expand.

## Used to validate:

### ModuleExpansionTransformer performance https://github.com/opentofu/opentofu/pull/1809
Apple M2 Pro / 32GB RAM

With 10x1000 modules, this dropped from 34s to 11s.
The time spent in ModuleExpansionTransformer dropped from ~18s to 190ms.
