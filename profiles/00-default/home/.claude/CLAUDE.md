# Global Settings

## Git Workflow: GitHub Flow

- Main branch is always deployable - never commit directly to main
- Create feature branches: `<type>/<description>` (e.g., `feature/user-auth`, `fix/login-bug`)
- Work on branch, create PR to main, review, merge, delete branch

## Conventional Commits

Format: `<type>(<scope>): <subject>`

**Types:**

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `refactor`: Code refactoring
- `perf`: Performance
- `test`: Tests
- `chore`: Build/tools
- `ci`: CI/CD

**Examples:**

- `feat(auth): add login functionality`
- `fix(api): resolve null pointer in user endpoint`
- `feat!: breaking change` (use `!` for breaking changes)

**Subject:**

- Imperative present tense ("add" not "added")
- Lowercase, <50 chars, no period
