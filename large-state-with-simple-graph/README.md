# Large state with simple graph

The test in this directory exists to benchmark state read/write/synchronize access, while minimizing the graph and configuration overhead.

## Used to validate:

### State persist interval https://github.com/opentofu/opentofu/issues/1568 
AMD Ryzen 7 2700X / 64GB RAM / M.2 SSD

Before changes: (20s state sync interval)
```
Apply complete! Resources: 1000 added, 0 changed, 0 destroyed.

real    7m25.386s
user    6m30.864s
sys     0m48.880s
```
After changes: (60s state sync interval)
```
Apply complete! Resources: 1000 added, 0 changed, 0 destroyed.

real    4m45.955s
user    5m8.096s
sys     0m42.058s
```

It's worth noting that more instances (1500) caused an OOM on a machine with ~48GB free and should be investigated. 
