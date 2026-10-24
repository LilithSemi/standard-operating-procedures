---
name: writing-code-comments
description: Use when adding or changing comments or doc comments in source code, when changing behavior, names, values, defaults, or errors that comments or docs describe, or when writing commit messages and docs that describe code.
---

# Writing code comments

## Overview

A comment tells the reader what a complex piece of code does or why it is there. Most code needs no comment. Write in plain English that follows ASD-STE100.

## When to write a comment

- A function or block does something that is not clear from its names and code.
- The code works around a bug, a spec rule, or a hardware limit. Name the issue, RFC, or datasheet.
- `TODO:` for work that is not done yet.
- `FIXME:` for code that is known to be wrong.

Do not comment code whose names already say what it does.

## How to write it

- Say what the code does. Do not say what it is not, or what it does not do.
- Use short sentences, active voice, and present tense.
- Use one word for one meaning. Use the words the code uses.
- Keep it to 1 to 3 lines. Up to about 10 lines is fine when it holds a code example.
- No colorful or promotional words. No "measured", "robust", "elegant", "blazing", "carefully".
- No all caps for emphasis.
- No task, plan, or spec names from your own work. Only external references, such as a GitHub issue or an RFC.

## Keep comments current

A comment states only facts that the code next to it owns. A value, a default, or a behavior that another file owns goes in the comment by name, not by copy.

```python
# Bad: Entries expire after 300 seconds, so prefetch once a minute.
# Good: Prefetch more often than the cache TTL so entries stay warm.
```

When you change a name, a value, a default, an error, a return value, or a thread safety rule:

1. Search the whole repository for the old name and the old value. Include `docs/`, the README, and doc comments.
2. Change each comment and doc that states the old fact, or remove it.
3. Remove comments that only say again what the changed code says.

## Example

```zig
// Bad: This is not a simple copy, it is a carefully measured, robust fast path.
// Good: Copies 8 bytes at a time while both pointers are aligned.
```

```c
// TODO: Support big endian hosts.
// FIXME: Leaks `buf` when `parse` returns an error.
```

## Check before you finish

Count the comment lines against the code lines in the change. If the comments are close to the code in size, remove the ones that repeat the code.
