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

### State DeepCopy Reduction https://github.com/opentofu/opentofu/issues/1580
AMD Ryzen 7 2700X / 64GB RAM / M.2 SSD

`time TOFU_CPU_PROFILE=prof.out TF_LOG=error TF_LOG_PROVIDER=error TF_LOG_SDK=error ~/go/bin/tofu apply --auto-approve`

Before Changes: (standard sync interval)
real    6m29.905s
user    7m54.563s
sys     1m12.524s

Memory Used: 10Gb

After https://github.com/opentofu/opentofu/pull/3011:
real    6m23.108s
user    8m7.307s
sys     0m58.747s

Memory Used: 9.2Gb

After https://github.com/opentofu/opentofu/pull/3110

real    0m26.447s!
user    1m55.671s
sys     0m34.533s

Memory Used: 4.6Gb!

I suspect that although the amount of deepcopies happening on main vs 3011 is cut by half, the GC overhead is the primariy bottleneck.
That is why the real improvement is only seen in the more aggressive optimization, which removes the need to DeepCopy entirely
