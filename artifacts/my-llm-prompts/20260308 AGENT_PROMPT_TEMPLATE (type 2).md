# Agent Prompt Template for Building from SPEC.md

## Usage

Copy and adapt the prompts below when asking coding agents to implement a project from a specification document.

- **Prompt** — for starting a new implementation from scratch.
- **Continuation Prompt** — for handing off to a different agent when the first one stopped mid-work.

---

## Prompt

```
Read the SPEC.md file in this repository carefully. You will implement the entire program described in it. Work through the entire implementation autonomously without stopping for approval.

## Rules

1. **Plan first, code second.**
   - Before writing any code, output a numbered implementation plan broken into small, incremental steps.
   - Each step should be a shippable unit — the project must build and pass existing tests after every step.
   - Then immediately begin execution. Do NOT wait for confirmation.

2. **Work autonomously.**
   - Do NOT ask clarifying questions. Make reasonable assumptions and state them explicitly.
   - If the spec is ambiguous, choose the simpler interpretation.
   - Proceed through all steps without pausing for feedback.

3. **Commit after every step.**
   - After completing each step, create a git commit.
   - Use Conventional Commits format: `feat:`, `fix:`, `refactor:`, `test:`, `chore:`, etc.
   - Commit messages should be concise but descriptive.
   - Example: `feat: add user authentication endpoint with JWT`

4. **Tests alongside code.**
   - Write or update tests relevant to the current step.
   - Run tests after each step to verify nothing is broken.
   - Do NOT leave test-writing to the end.

5. **Dependencies first.**
   - If a step requires new packages/dependencies, install and commit them separately before writing the code that uses them.
   - Example: `chore: add jsonwebtoken and bcrypt dependencies`

6. **Lint and format last.**
   - Do NOT run linters or formatters during implementation steps.
   - After all steps are complete, run linting/formatting as a final dedicated step.
   - Commit this separately: `chore: apply linting and formatting`

7. **Keep changes small and focused.**
   - Avoid creating more than 3-4 files in a single step.
   - If a step feels too large, break it down further.

8. **Verify before committing.**
   - After each step, run a quick build/compile check (if applicable).
   - Run the relevant tests.
   - Only commit if the project is in a working state.

9. **Handle ambiguity decisively.**
   - If the spec is unclear, pick the simplest reasonable interpretation.
   - State your assumption in the commit message or as a code comment prefixed with `ASSUMPTION:`.
   - Never block progress waiting for clarification.

10. **Write clean, testable code.**
   - Follow the conventions and best practices of the language/framework in use.
   - Design for testability: use dependency injection, avoid hidden side effects, keep functions/methods focused on a single responsibility.
   - Apply OOP principles (encapsulation, composition over inheritance, program to interfaces) where the language supports it.
   - Do NOT over-engineer. Only introduce abstractions when they serve a clear purpose.

## Output format for the plan

Use this structure:

### Implementation Plan
- Step 1: [short description] — [files involved]
- Step 2: [short description] — [files involved]
- ...
- Step N: Linting, formatting, and final cleanup

Then immediately begin with Step 1 and work through all steps.
```

---

## Continuation Prompt (Agent Handoff)

Use this when a previous agent stopped mid-implementation and a new agent needs to pick up the work.

```
A previous agent was implementing a program based on SPEC.md but stopped before finishing. You will continue the work. Work autonomously without stopping for approval.

## Before writing any code, do the following analysis:

1. Read SPEC.md to understand the full scope of the project.
2. Run `git log --oneline` to see what has been done so far.
3. Review the existing codebase: file structure, patterns, naming conventions, and test style.
4. Run the existing tests to confirm the current state is green. If tests fail, fix them before adding new work.
5. Identify what remains to be done by comparing the spec against the current implementation.

## Then output:

- **Done**: a short summary of what the previous agent completed (based on git log and code).
- **Remaining**: a numbered list of steps still needed to finish the spec.
- **Conventions observed**: language, framework, naming style, test framework, commit message format, and any patterns you will follow to stay consistent.

Then immediately begin working through the remaining steps.

## Rules

Follow ALL of these rules — they are the same rules the previous agent was given:

1. Do NOT ask clarifying questions. Make reasonable assumptions and state them explicitly.
2. If the spec is ambiguous, choose the simpler interpretation.
3. Commit after every step using the same Conventional Commits format found in the git history.
4. Write or update tests for each step. Run tests before committing.
5. If a step requires new dependencies, install and commit them separately.
6. Do NOT run linters or formatters until all implementation is complete.
7. Keep changes small and focused (3-4 files max per step).
8. Verify the project builds and tests pass before each commit.
9. State assumptions with `ASSUMPTION:` prefix in code comments.
10. Follow the conventions and patterns already established in the codebase. Match the existing style — do NOT refactor or rewrite what the previous agent wrote unless it is broken.
```

---

## Customization Tips

| Situation | Add to prompt |
|---|---|
| Monorepo / specific directory | `Work only inside the packages/core directory.` |
| Specific language/framework | `Use TypeScript with strict mode. Use Next.js App Router.` |
| Existing codebase | `Study the existing code style and patterns before starting. Match them.` |
| CI pipeline exists | `Make sure all CI checks pass after each step.` |
| Database migrations | `Create migration files as separate steps and commits.` |
| You want checkpoint approval | Add to Rule 1: `Wait for my approval before starting.` Add to Rule 2: `Stop after each step and wait for confirmation.` |
| Long-running project | Add: `At the start of each step, re-read SPEC.md to stay aligned.` |

---

## Why This Works

- **Fully autonomous** = no interruptions, the agent completes the entire project in one session.
- **Assumptions stated explicitly** = you can review decisions after the fact via commit history and `ASSUMPTION:` comments.
- **Simpler interpretation by default** = prevents the agent from over-engineering ambiguous requirements.
- **Incremental commits** = easy rollback if any single step went wrong.
- **Tests per step** = regressions are caught immediately, not at the end.
- **Lint last** = avoids noisy diffs mid-implementation and keeps the agent focused on logic.
- **Small steps** = stays within context window limits and produces more reliable output.
- **Dependencies first** = prevents import errors mid-step that confuse the agent.

### Why the Continuation Prompt works

- **Analyze before coding** = the new agent builds a mental model of the project before touching anything, instead of blindly starting from SPEC.md.
- **Git log as ground truth** = commit history is the most reliable record of what was done, more so than asking the user to explain.
- **Test-first verification** = running existing tests first catches any broken state the previous agent may have left behind.
- **"Match the existing style"** = the single most important rule for handoffs. Without it, the new agent will rewrite half the codebase to match its own preferences.
