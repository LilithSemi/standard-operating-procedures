---
name: keeping-git-history-small
description: Use when about to create a git commit, when fixing a bug or regression on a branch or pull request that is not yet merged, or when a review asks for changes to earlier commits.
---

# Keeping git history small

## Overview

Each commit on a branch is one logical change. A fix for a bug that the same branch added goes into the commit that added it. It does not get a new "fix" commit.

## Rules

1. Make as few commits as the change needs. Do not commit after each small step.
2. When a change on the branch causes a regression, find the commit that caused it and squash the fix into that commit.
3. Only rewrite commits that are not yet merged into the base branch.
4. Ask the user before you rewrite history or force push.

## Squash a fix into the commit that caused it

```sh
# Find the commit that added the behavior.
git log --oneline <base>..HEAD
git bisect start HEAD <base>   # if the log does not make it clear

# Stage the fix, then make a fixup commit for that target.
git add <files>
git commit --fixup=<sha>

# Fold it in without an interactive editor.
GIT_SEQUENCE_EDITOR=true git rebase -i --autosquash <base>
```

After the rebase, run the tests again on the new HEAD.

## Common mistakes

| Mistake | Fix |
|---|---|
| New commit "fix tests" on top of the branch | `--fixup` the commit that broke them |
| Add a fix commit so the reviewer can see what changed | The reviewer can use `git range-diff`. Squash the fix into the commit that broke it. |
| Push the `fixup!` commit and squash it later | Run the autosquash rebase before you push |
| Leave it for a squash merge | The base branch can use merge commits. Make each commit correct now. |
| Rewrite commits that are already on the base branch | Make a new commit instead |
| Force push without asking | Ask first, then use `--force-with-lease` |
