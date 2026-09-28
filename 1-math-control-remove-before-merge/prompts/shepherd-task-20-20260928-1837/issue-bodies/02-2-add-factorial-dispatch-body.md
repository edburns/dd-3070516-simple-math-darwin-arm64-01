## Campaign context and required reading

On the `experiment/shepherd-control` branch, the directory `1-math-control-remove-before-merge` contains the plan (`math-tool-ignorance-reduction-plan.md`) and supporting resources (diagrams, decision records). Spike subdirectories are research artifacts — read the plan's Resolution sections for findings, not the spike source code.

Read the entire plan before working. Then re-read these exact sections:

- `## Ignorance reduction`
- `### Repository-owned validation`
- `### Output and ordering contracts`
- `## Implementation`
- `### 1. Implement Fibonacci with unit and isolated CLI coverage`
- `### 2. Add factorial and operation dispatch`

Apply these resolved decisions:

- Repository acceptance is defined by `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1`. The baseline workflow `.github/workflows/shepherd-task-math-tool.yml` installs exactly Pester 5.7.1 and invokes that repository-owned runner. Do not replace or bypass the runner.
- Direct CLI execution must write exactly one result line to stdout: `Fibonacci(N) = value` for Fibonacci or `Factorial(N) = value` for factorial. Pure functions return only numeric values, with no incidental output.
- Inputs are non-negative integers.
- The production and test files remain the repository-root files `math-tool.ps1` and `math-tool.Tests.ps1`.
- Work is serial. This task depends on task 1 having been merged, and all Fibonacci behavior and coverage from task 1 must remain intact.

The plan records no separate spike finding for this task. Implement the resolved production behavior from scratch; do not read, copy, or adapt spike source code.

## Branch and execution order

Use `experiment/shepherd-control` from remote `origin` as the base branch for the pull request. This is the second of two ordered tasks. The tasks are assigned, completed, and merged serially in plan order. Do not begin work until task 1 is merged and this issue is assigned to you.

## Implement

Extend the merged task-1 implementation in repository-root `math-tool.ps1`:

- Add a pure `Get-Factorial` function that computes and returns the factorial of non-negative integer `N`.
- Add an `Operation` parameter that dispatches between `fibonacci` and `factorial` while retaining the `N` parameter.
- Preserve the task-1 Fibonacci interface and behavior. Existing Fibonacci invocations must continue to work, so Fibonacci remains the behavior when no operation is explicitly supplied.
- For Fibonacci dispatch, print exactly `Fibonacci(N) = value` to stdout.
- For factorial dispatch, print exactly `Factorial(N) = value` to stdout.
- Keep both functions free of incidental output; each function returns only its numeric result.
- Correctly handle factorial base cases `N=0` and `N=1`, both of which return `1`, plus at least one small representative positive value.

Extend `math-tool.Tests.ps1` so the combined regression suite:

- Retains all existing Fibonacci unit and isolated child-process CLI coverage from task 1.
- Adds direct unit coverage for `Get-Factorial` at `N=0`, `N=1`, and at least one small representative positive value.
- Adds isolated child-`pwsh` coverage for explicit Fibonacci and factorial operation dispatch.
- Asserts exact single-line stdout, successful child-process exit status, correct operation labels, and no extra stdout for both operations.
- Proves the default/no-operation Fibonacci CLI behavior still matches task 1.

Keep the interface and tests objective and small. Follow existing repository conventions and do not weaken the committed test runner or workflow.

## Completion gates

- `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1` exits zero for the combined regression suite using Pester 5.7.1.
- Unit coverage proves `Get-Factorial 0` and `Get-Factorial 1` each return numeric `1`, and the representative case returns the correct numeric value without incidental output.
- Isolated CLI coverage proves explicit Fibonacci and factorial dispatch each exit zero and emit exactly one correctly labeled result line.
- A regression gate proves invoking the script with `N` and no explicit `Operation` still emits the task-1 Fibonacci result exactly.
- All task-1 Fibonacci unit and CLI cases continue to pass unchanged in meaning.
- The pinned pull-request CI workflow passes.

## Out of scope

- Do not add operations other than `fibonacci` and `factorial`.
- Do not modify `eng/test-math-tool.ps1`, replace the Pester version, or bypass `.github/workflows/shepherd-task-math-tool.yml`.
- Do not redesign unrelated repository infrastructure, add external dependencies, or expand the tool beyond the two planned operations.
- Do not remove or weaken task-1 Fibonacci behavior or coverage.
