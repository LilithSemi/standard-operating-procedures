---
name: checking-the-host
description: Use when about to build, install, download binaries, pick a target triple or container platform, or choose job counts, memory limits, or timeouts on a machine whose architecture, OS, or hardware has not been checked yet in this session.
---

# Checking the host

## Overview

Do not guess what the host is. Hosts can be aarch64, riscv64, or x86_64. They can run Linux, macOS, or a BSD. They can be a small board or a large server. Check first, then pick commands.

## What to check

| Fact | Command |
|---|---|
| Architecture | `uname -m` |
| OS and kernel | `uname -sr` |
| CPU count | `nproc` (Linux), `sysctl -n hw.ncpu` (macOS and BSD) |
| Memory | `free -h` (Linux), `sysctl -n hw.memsize` (macOS) |
| Disk space | `df -h .` |
| Nix present | `command -v nix` |

Run the checks once per session and keep the results.

## Using the results

- Download the binary that matches the architecture. Do not take the x86_64 asset by default.
- Set build parallelism from the CPU count and the memory you read. Do not lower it because the machine "might be slow". Do not raise it past what the machine has.
- A C++ or Rust compile job can use about 2 GB of memory, and a link of a large project such as LLVM can use 8 GB or more. Use the smaller of the CPU count and the available memory in GB divided by 2. Reading `free -h` and then passing `-j$(nproc)` is the same mistake as not reading it.
- If a job needs more memory or disk than the host has, say so before you start it.
- Use the flags of the OS you found. GNU and BSD versions of `sed`, `find`, and `date` take different flags.

## Common mistakes

| Mistake | Fix |
|---|---|
| Assume x86_64 because it is common | Read `uname -m` |
| Pass `-j2` to be safe | Read `nproc` and use it |
| Assume a large server and run many jobs in parallel | Read CPU count and memory first |
| Assume a few commands are causing the system to slow down | Read the load average |
