---
description: Review Python changes against quality checklists using parallel subagents
argument-hint: "[branch name | PR number | blank]"
allowed-tools: Bash, Read, Glob, Grep, Skill, Agent, TaskCreate, TaskUpdate
---

This command always operates in **reviewer mode**: the user is reviewing someone else's code (or their own PR as a reviewer would), not authoring it. Never fix code directly.. draft comments and let the user review them.

The only review scope is **branch** — the isolated diff between a single branch and its parent. Each invocation reviews exactly one branch and then stops. File-path, git-range, and stack scopes are not supported. To review a second branch, finish this invocation, then run the command again with the new branch as the argument — this command does not iterate across branches.

## Process

1. **Initialize.**

   Create a task list using TaskCreate. The first task is "Print local time". Run `date` via Bash, then mark the task complete. This anchors timing measurements for the session.

   Then create tasks: "Resolve branch", "Launch reviewers", "Walk through findings", "Finalize review status".

2. **Resolve branch.** Parse `$ARGUMENTS` into one of three forms — all resolve to a branch diff:
   - **PR number** (e.g., `26453`) — fetch head branch, head SHA, and base branch via `gh pr view <pr> --json headRefName,headRefOid,baseRefName`, then `git fetch origin <branch>` and `git checkout origin/<branch>` (detached HEAD). Capture `{owner}`, `{repo}`, `{pr}`, the head SHA, and the base branch.
   - **Branch name** (e.g., `pydev/feature-name`) — `git fetch origin <branch>` and `git checkout origin/<branch>` (detached HEAD). Then look up the branch's PR with `gh pr view <branch> --json number,headRefOid,baseRefName`; if one exists, capture `{owner}`, `{repo}`, `{pr}`, head SHA, and base branch.
   - **Blank** — use the current branch as-is (do not re-checkout). Look up its PR with `gh pr view --json number,headRefOid,baseRefName` the same way.

   **Important:** Check out the branch in detached HEAD via `git checkout origin/<branch>` (not `git checkout <branch>`). This pins the review to the remote state and avoids accidentally mutating any local branch.

   Compute the branch's isolated diff against its parent:
   ```bash
   git diff origin/<parent-branch>...HEAD -- '*.py'
   ```
   The parent branch is the PR's base branch (from `gh pr view --json baseRefName`) if a PR exists, otherwise the repo's default branch (`gh repo view --json defaultBranchRef`).

   Collect the changed `.py` files and separate into **source files** and **test files** (any file under a `test/` or `tests/` directory, or named `test_*.py`).

3. **Launch adversarial-reviewer agents.**

   Each reviewer receives a **reference file path** (the standalone review standard) and the artifact paths. Reference paths are relative to `python-development/skills/` in the plugins repo.

   Launch up to 5 agents simultaneously, one per reference file:

   **Agent A — Source code conventions** (only if source files changed):
   ```
   Reference: writing-python-code/references/code-conventions.md
   Artifact: {changed source file paths}
   ```

   **Agent B — Source code quality** (only if source files changed):
   ```
   Reference: writing-python-code/references/code-quality.md
   Artifact: {changed source file paths}
   ```

   **Agent C — Test conventions** (only if test files changed):
   ```
   Reference: writing-python-tests/references/test-conventions.md
   Artifact: {changed test file paths}
   ```

   **Agent D — Test quality** (only if test files changed):
   ```
   Reference: writing-python-tests/references/test-quality.md
   Artifact: {changed test file paths}
   ```

   **Agent E — Source code conventions on tests** (only if test files changed):
   ```
   Reference: writing-python-code/references/code-conventions.md
   Artifact: {changed test file paths}
   ```

4. **Walk through findings one by one.**

   Once all reviewer agents have completed, internally collect their findings and deduplicate — if multiple reviewers flagged the same file/line with an equivalent issue, collapse them into a single entry (keep the highest severity and merge the discussion points). Do this silently: do NOT flash the deduplicated list or a summary table to the reviewer. Only tell the user how many findings are queued (e.g., "7 findings to walk through") before starting the loop.

   For each finding, present to the user:

   - **Severity**: the severity of this finding
     - `**issue (blocking):** <subject>` — bugs, correctness, security. Always blocking.
     - `**suggestion (non-blocking):** <subject>` — concrete improvement with reasoning.
     - `**question (non-blocking):** <subject>` — ask for clarification when unsure if it's a real problem.
     - `**nitpick (non-blocking):** <subject>` — trivial, preference-based.

     Default severity mapping from the reviewer's output: high → `issue (blocking)`, medium → `suggestion (non-blocking)`, low → `nitpick (non-blocking)`. Prefer questions over statements when there's ambiguity about whether the code is actually wrong. Keep subject under one sentence; add 1-3 sentences of discussion only if needed.

   - **Location**: file path and line number for the comment.

   Ask: **skip**, or **discuss**.

   Only after the user resolves the current finding, move to the next one.

   Never fix code directly in this flow — the user is reviewing, not authoring.

Input: $ARGUMENTS
