---
name: watching-build-and-test-time
description: Use when starting a build, test suite, simulation, synthesis, or place and route run, when a command hits a timeout, when a long run has gone quiet, or when a build or test has been running for a long time and you are about to keep waiting.
---

# Watching build and test time

## Overview

Know how long a run should take before you start it. When a run goes past that time, stop waiting and find the cause. A slow run that still prints output is also a stall.

## Expected times

These times are for adequate hardware. Use checking-the-host to find out what the host has.

| Run | Expected time |
|---|---|
| Unit test suite | Less than 1 hour |
| Unit tests that run simulations (Verilator, cocotb, QEMU) | Less than 4 hours |
| Other test suites | A couple of hours |
| Linux kernel build | Less than 30 minutes |
| RTL build (synthesis, place and route, bitstream) | A couple of hours |

On a small host, such as a single board computer or a VM with few cores, scale the times up and tell the user the time you expect.

## Before you start

1. Read the host CPU count and memory.
2. Write down the expected time for the run.
3. If the run can be longer than the harness timeout, run it in the background with a log. Do not retry in the foreground with fewer jobs. Fewer jobs make it slower.

## When a run goes past its expected time

Do not keep waiting, and do not raise the timeout and run it again. Find out why:

| Check | Command |
|---|---|
| Real parallelism | `ps -eo pid,stat,pcpu,etime,args --forest`, `uptime` (load near the CPU count) |
| Memory and swap | `free -h`, `vmstat 5 3` (the `si` and `so` columns are not zero) |
| Disk and I/O wait | `df -h .`, `vmstat 5 3` (the `wa` column) |
| CPU throttle | `cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq` |
| A stuck process | `cat /proc/<pid>/wchan`, `strace -p <pid>`, `gdb -p <pid> -batch -ex 'thread apply all bt'` |
| Serial work | `make` without `-j`, a test runner with one worker, a lock that all jobs wait on |
| Slow test or step | Per test times from the runner, such as `pytest --durations`, `ctest --timeout`, cocotb result times |

Report the cause and the fix to the user. If the user asked you to let the run finish, do not stop it. Report the cause and the time you expect it to finish, so the user can decide.

## Red flags

- A unit test suite past 1 hour
- A kernel build past 30 minutes on a host with 8 or more cores
- "The log is still moving, so it is fine"
- Retrying with `-j1` or `-j2` after a timeout
- Raising a timeout without knowing why the run is slow
