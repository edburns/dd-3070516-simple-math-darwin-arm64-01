## Campaign context and required reading

On the `experiment/shepherd-control` branch, the directory `1-math-control-remove-before-merge` contains the plan (`math-tool-ignorance-reduction-plan.md`) and supporting resources (diagrams, decision records). Spike subdirectories are research artifacts — read the plan's Resolution sections for findings, not the spike source code.

Read the entire plan before working. Then re-read these exact sections:

- `## Ignorance reduction`
- `### Repository-owned validation`
- `### Output and ordering contracts`
- `## Implementation`
- `### 1. Implement Fibonacci with unit and isolated CLI coverage`

Apply these resolved decisions:

- Repository acceptance is defined by `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1`. The baseline workflow `.github/workflows/shepherd-task-math-tool.yml` installs exactly Pester 5.7.1 and invokes that repository-owned runner. Do not replace or bypass the runner.
- Direct CLI execution must write exactly one result line to stdout in the form `Fibonacci(N) = value`. The function itself returns only the numeric value, with no incidental output.
- Inputs are non-negative integers.
- The production and test files are the repository-root files `math-tool.ps1` and `math-tool.Tests.ps1`.
- Work is serial. This is task 1; task 2 may start only after this issue is merged.

The plan records no separate spike finding for this task. Implement the resolved production behavior from scratch; do not read, copy, or adapt spike source code.

## Branch and execution order

Use `experiment/shepherd-control` from remote `origin` as the base branch for the pull request. This issue is the first of two ordered tasks. The tasks are assigned, completed, and merged serially in plan order. Do not begin work until this issue is assigned to you. Leave task 2 untouched.

## Implement

Create repository-root `math-tool.ps1` with:

- A required non-negative integer parameter named `N`.
- A pure `Get-Fibonacci` function that computes and returns the Fibonacci value for `N`.
- Direct script execution that invokes the function and writes exactly `Fibonacci(N) = value` to stdout, with `N` and `value` replaced by their numeric values.
- Correct base cases for `N=0` and `N=1`, plus correct behavior for a small representative positive value.
- No incidental output from `Get-Fibonacci`; callers that dot-source the script and invoke the function must receive only the numeric result.

Create repository-root `math-tool.Tests.ps1` with Pester tests that:

- Dot-source `math-tool.ps1` and exercise `Get-Fibonacci` directly.
- Cover `N=0`, `N=1`, and at least one small representative positive value.
- Start isolated child `pwsh` processes to test direct CLI execution rather than treating an in-process invocation as CLI coverage.
- Assert the exact single stdout result line for each CLI case, including punctuation, capitalization, spacing, input, and result.
- Assert successful child-process exit status and ensure no extra stdout lines are emitted.

Keep the implementation deterministic, objective, and small. Follow existing repository conventions and do not weaken the committed test runner or workflow.

## Completion gates

- `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1` exits zero using the repository-owned runner and Pester 5.7.1.
- Unit coverage proves `Get-Fibonacci 0` returns numeric `0`, `Get-Fibonacci 1` returns numeric `1`, and the representative case returns the correct numeric value without incidental output.
- Isolated CLI coverage proves direct execution for the same edge and representative cases exits zero and emits exactly one line such as `Fibonacci(0) = 0`.
- `math-tool.ps1` and `math-tool.Tests.ps1` are introduced together, satisfying the runner's file-pair contract.
- The pinned pull-request CI workflow passes.

## Out of scope

- Do not implement factorial, operation dispatch, or the task-2 interface.
- Do not modify `eng/test-math-tool.ps1`, replace the Pester version, or bypass `.github/workflows/shepherd-task-math-tool.yml`.
- Do not add unrelated operations, dependencies, packaging, documentation, or repository changes.
- Do not assign or start task 2; it follows only after this issue is merged.
