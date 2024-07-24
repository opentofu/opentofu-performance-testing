# OpenTofu Performance Tests

This repository is a collection of scenarios that are used to validate changes against OpenTofu which have a performance impact.  Each folder in this repository represents a specific scenario and is tied to at least one issue / pull request.

## Adding a test scenario

Each scenario consists of:
* A README.md, based off of ./template/README.md
* Any .tf or .tofu files required
* A run.sh script that will execute tofu in the required sequence.  This may also perform setup, such as generating large data inputs.
  - Do *NOT* include and check in large data files into this repository.  Generate them in this script instead.

## Future Design

At the moment, using this repo is a fairly manual process.  It is not designed for automation or acceptance.

If this is a useful tool for the OpenTofu project, it will likley be formalized futher and treated more like a series of benchmarks.

For now however, it fills it's current purpose.
