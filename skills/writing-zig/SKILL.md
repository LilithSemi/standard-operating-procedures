---
name: writing-zig
description: Use when writing or changing Zig code or a build.zig, when a Zig compile error says a std member or field does not exist, or when a project sets minimum_zig_version to 0.16 or later.
---

# Writing Zig

## Overview

The Zig standard library changes a lot between releases, and your memory is of older ones. The compiler and std source on the host are the reference. Your memory is not.

## Before you write code

1. Read the version. `zig version`, and `minimum_zig_version` in `build.zig.zon`.
2. Find the std source. `zig env` prints `.std_dir`.
3. For each std API you use, read its declaration in `<std_dir>`. Do this also for APIs you know.
4. For a new `build.zig` or `main`, run `zig init` in your temporary directory and copy its patterns.

## Zig 0.17 changes

| Old | 0.17 |
|---|---|
| `pub fn main() !void` | `pub fn main(init: std.process.Init) !void` |
| `std.process.argsAlloc` | `init.minimal.args.toSlice(init.arena.allocator())` |
| `std.process.getEnvVarOwned` | `init.environ_map.get("NAME")` |
| `std.heap.GeneralPurposeAllocator` | `init.gpa`, or `std.heap.DebugAllocator` |
| `std.fs.cwd()`, `std.fs.File` | `std.Io.Dir.cwd()`, `std.Io.File`, with an `io` argument |
| `std.io.getStdOut().writer()` | `std.Io.File.Writer.init(.stdout(), io, &buffer)`, then `.interface` |
| `std.process.Child.run` | `std.process.run(gpa, io, .{ .argv = ... })` |
| `std.time.Instant`, `std.time.timestamp` | `std.Io.Timestamp.now(io, .awake)` or `.real` |
| `std.Thread.sleep` | `std.Io.sleep(io, .fromMilliseconds(250), .awake)` |
| `std.net` | `std.Io.net` |
| Threads for concurrent tasks | `std.Io.Group`, `group.async(io, func, args)`, `group.await(io)` |
| `b.args` in `build.zig` | `run_cmd.addPassthruArgs()` |

Most functions that touch files, processes, the network, or time take `io: std.Io`. Pass `init.io` down from `main`.

## Example

This compiles and runs on Zig 0.17.0:

```zig
const std = @import("std");
const Io = std.Io;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    var buffer: [4096]u8 = undefined;
    var stdout_writer: Io.File.Writer = .init(.stdout(), io, &buffer);
    const stdout = &stdout_writer.interface;

    const data = try Io.Dir.cwd().readFileAlloc(io, args[1], init.gpa, .unlimited);
    defer init.gpa.free(data);

    try stdout.print("{d} bytes\n", .{data.len});
    try stdout.flush();
}
```

## Before you finish

Run `zig build`, `zig build test`, or `zig test <file>`. When the compiler says a member does not exist, search `<std_dir>` for the new name. Do not guess a second time.
