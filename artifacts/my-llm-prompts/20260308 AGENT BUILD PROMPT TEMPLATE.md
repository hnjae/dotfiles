# Agent Prompt Template for Building from SPEC.md

## Usage

Copy and adapt the prompt below when asking Claude Code (or similar coding agents) to implement a project from a specification document.

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
