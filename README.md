# standard-operating-procedures

Engineering procedures for coding agents. The plugin works with Claude Code, Codex, and Chock.

## Skills

| Area | Skill | Covers |
|---|---|---|
| Tooling | `checking-the-host` | Read the architecture, OS, and hardware before you pick commands |
| Tooling | `using-host-tools` | Harness edits, `jq` for JSON, Nix for missing tools, scoped `find`, one temp directory that gets removed |
| Tooling | `watching-build-and-test-time` | Expected build and test times, and finding the cause of a stall |
| Language | `taking-the-direct-approach` | Use the stdlib and current dependencies directly, with no shims, and read the API for the version in use |
| Language | `writing-zig` | Read the Zig version and its std source, and the Zig 0.17 API changes |
| Language | `writing-code-comments` | When to comment, and plain ASD-STE100 English |
| Git | `keeping-git-history-small` | Few commits, and squash regression fixes into the commit that caused them |

## Install

Claude Code:

```sh
claude plugin marketplace add https://git.lilithsemi.com/LilithSemi/standard-operating-procedures.git
claude plugin install standard-operating-procedures@lilithsemi
```

Codex reads `.codex-plugin/plugin.json` and `.agents/plugins/marketplace.json`.

Chock reads skills from `share/agent-skills/` in the dev shell. Add the flake package to your dev shell:

```nix
devShells.default = pkgs.mkShell {
  packages = [ inputs.standard-operating-procedures.packages.${system}.default ];
};
```
