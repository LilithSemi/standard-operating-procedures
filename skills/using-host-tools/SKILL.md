---
name: using-host-tools
description: Use when about to run python, python3, node, perl, ruby, or another language interpreter from the shell, when parsing JSON, when a needed command is missing, when searching the filesystem with find, or when creating temporary files, downloads, logs, core dumps, or scratch build copies.
---

# Using host tools

## Overview

Use the harness tools and small single purpose CLI tools. Do not start a language interpreter to do work a tool already does.

## Rules

1. **Edit files with the harness.** Use the read, write, and edit tools that the harness gives you. Do not run `python -c`, `node -e`, `perl -pi -e`, or similar to change a file.
2. **Parse JSON with jq.** Do not run `python -c 'import json'` or `node -e 'JSON.parse(...)'`. Use `jq`.
3. **Get missing tools from Nix when the host has Nix.** Check with `command -v nix`. Then use `nix run nixpkgs#<pkg> -- <args>` for one command, or `nix-shell -p <pkg> --run '<cmd>'` for a few. Do not install with `pip`, `npm -g`, `apt`, or `brew` on a Nix host.
4. **Do not search from the root.** Do not run `find /` or `find /nix/store`. For files, start `find` from the smallest directory that can hold the result, such as the project root, `$HOME/.config`, or `/etc`. For Nix store paths, ask Nix:

| Need | Command |
|---|---|
| Path of a package | `nix build nixpkgs#<pkg> --print-out-paths --no-link` |
| Files in a package | `ls $(nix build nixpkgs#<pkg> --print-out-paths --no-link)` |
| Path of a command on PATH | `readlink -f $(command -v <cmd>)` |
| Dependencies of a path | `nix-store -q --references <path>` |
| Package that holds a file | `nix-locate <file>` (from `nix run nixpkgs#nix-index`) |

5. **Keep temporary files in one directory.** If the harness gives you a scratchpad directory, use it. If not, make one directory for the task and keep its path:

```sh
work=$(mktemp -d "${TMPDIR:-/tmp}/<task>.XXXXXX")
```

Put downloads, logs, core dumps, and scratch build copies in subdirectories of that one directory. Do not write loose files to `/tmp`. Do not make new directories in `$HOME`, in the project, or next to the project.

6. **Remove what you put in `/tmp`.** When you no longer need the files, run `rm -rf "$work"`. Do this before your final reply, also when the task fails. Give the user the result in the reply, for example the diff or the log lines. If the user needs a file to stay, move it to a path the user names, then remove the rest. A script that makes its own directory removes it with `trap 'rm -rf "$work"' EXIT`.

## When an interpreter is correct

Run an interpreter when the task is the program itself: run the project's tests, run a script the project ships, or run a script the user asked for.

## Red flags

- `python3 -c` in a command you are about to run
- `| python -m json.tool` or `| node -e`
- `pip install` on a host with Nix
- `find / -name`
- `find /nix/store`
- `/tmp/<name>` written by hand, or a second `mktemp -d` in the same task
- `mkdir ~/something-debug` or a scratch directory in the project
- A final reply while a directory you made in `/tmp` still exists

Each of these means stop and use the rule above.
