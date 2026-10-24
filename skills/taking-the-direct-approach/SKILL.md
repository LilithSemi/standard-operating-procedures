---
name: taking-the-direct-approach
description: Use when writing new functions, helpers, wrappers, error types, option structs, or compatibility code, or when a request asks for code that is robust, solid, clean, reusable, or production quality.
---

# Taking the direct approach

## Overview

Use the language standard library and the libraries the project already has. Call them directly. Write new code only for the part they do not do.

## Choose the source

Use the first one that can do the job:

1. The standard library of the language, at the minimum version the project supports.
2. A library that is already a dependency of the project.
3. A new dependency, only if the user agrees to it.
4. New code. Say in one line why 1 to 3 cannot do it.

Find the minimum version first: `requires-python` in `pyproject.toml`, `go` in `go.mod`, `engines` in `package.json`, `minimum_zig_version` in `build.zig.zon`, `rust-version` in `Cargo.toml`.

## Read the API for this version

APIs change between versions, and your memory can be of an older one. Before you call a function, read its source or docs for the version the project uses. Find its signature, its error set or exceptions, and what it does with edge cases such as signs, empty input, and overflow. Then write the tests from what you read.

| Language | Where to read |
|---|---|
| Zig | `zig env` prints `.std_dir`, `grep -n 'pub fn parseInt' <std_dir>/fmt.zig` |
| Go | `go doc slices.Compact` |
| Python | `python3 -m pydoc tomllib.load` |
| Node | `node --version`, then the docs for that major version |
| Rust | `cargo doc --open`, or the source under `~/.cargo/registry/src` |

Zig changes the most. Read the std source for each API you use, also ones you know.

## Shape of the code

- Call the standard library or library function at the place that needs it.
- Let its errors go to the caller as they are. Python raises `OSError` and `tomllib.TOMLDecodeError`. Zig returns the error from `std.fmt.parseInt`. A promise rejects with the `fs` error.
- Add a helper function only when two or more places call it, or when it holds logic that is not one library call.
- Add only the parameters, options, and checks that the request names or that the code needs to be correct.
- Add a version fallback only when the minimum version does not have the feature.

"Robust", "solid", and "production quality" mean correct and tested. They do not ask for more layers.

## Example

Python 3.11, read the `[server]` table of a TOML file:

```python
import tomllib


def load_config(path):
    with open(path, "rb") as f:
        return tomllib.load(f)["server"]
```

Zig 0.16, sort a slice of `u16`:

```zig
std.mem.sort(u16, ports, {}, std.sort.asc(u16));
```

## Signs of extra layers

| You are about to write | Use instead |
|---|---|
| An error type that wraps each stdlib error | The stdlib errors |
| `fileExists`, `readFile`, `sleep`, or `lessThan` around one library call | The library call |
| `try: import tomllib except ImportError: import tomli` on Python 3.11 or later | `import tomllib` |
| Your own dedupe, sort, clone, retry, or parse loop | `slices.Compact`, `std.sort.asc`, `structuredClone`, the HTTP client retry option, `std.fmt.parseInt` |
| An options object nobody asked for | The parameters in the request |
