# Setting Up Git Templates for Team Collaboration

This repository provides structured templates for commits and pull requests to help the team maintain consistency.

## What We've Set Up

### 1. Pull Request Template (Auto-Applied on GitHub)

When you open a PR, GitHub automatically loads `.github/pull_request_template.md` with sections tailored to our FastAPI + React architecture:

- Checklist for backend (FastAPI/SQLModel) vs frontend (React/Vite) changes
- Database migration tracking
- Docker Compose verification steps  
- Environment variable documentation

No configuration needed - it just works when you create PRs on GitHub.

### 2. Commit Message Template (Requires One-Time Setup)

The commit template in `.github/.gitmessage` provides guidance and examples specific to this project's structure.

**To enable it on your machine:**

```bash
cd /home/runner/work/FastAPI-App-Template/FastAPI-App-Template
git config commit.template .github/.gitmessage
```

This tells git to pre-fill your commit message editor with our template whenever you run `git commit` (without `-m`).

**How to use it:**

1. Stage your changes: `git add .`
2. Start a commit: `git commit` (editor opens with template)
3. Replace the placeholder text with your actual commit message
4. Delete unused sections (anything starting with `#` is a comment)
5. Save and close the editor

**For quick commits**, you can still bypass the template:
```bash
git commit -m "api: Fix user endpoint returning 500 on empty query"
```

## Commit Message Structure for This Project

Our template suggests this format:

```
prefix: Concise summary of what changed

The problem this solves:
[Why was this necessary?]

How this changes the codebase:
[What did you modify?]

Validation completed:
[How you tested it]
```

### Prefix Categories Mapped to Our Stack

The template includes prefixes aligned with our project structure:

| Prefix | Use For | Example Files |
|--------|---------|---------------|
| `api:` | Backend route handlers | `backend/app/api/routes/*.py` |
| `model:` | Database schemas | `backend/app/models/*.py` |
| `ui:` | Frontend components | `frontend/src/components/**/*.tsx` |
| `route:` | TanStack Router pages | `frontend/src/routes/**/*.tsx` |
| `compose:` | Docker services | `compose.yml`, `compose.override.yml` |
| `migration:` | Database changes | `backend/alembic/versions/*.py` |
| `test:` | Pytest or Playwright | `backend/tests/*`, `frontend/tests/*` |
| `workflow:` | CI/CD pipelines | `.github/workflows/*.yml` |
| `client:` | Generated API client | `frontend/src/client/*` |
| `config:` | Settings & environment | `backend/app/core/config.py`, `.env` |

See the full list in `.github/.gitmessage`.

## Integration with Existing Development Workflow

These templates complement our current setup:

1. **Pre-commit hooks (prek)**: Runs linting/formatting before commits
2. **Commit template**: Guides you to write clear commit messages
3. **PR template**: Ensures thorough documentation when opening PRs
4. **Docker Compose validation**: Template reminds you to test `docker compose watch`

## Example Workflow

```bash
# 1. Make your changes
vim backend/app/api/routes/users.py

# 2. Pre-commit hooks auto-run on commit
git add backend/app/api/routes/users.py
git commit
# (Editor opens with our template - fill it out)

# 3. Push and open PR
git push origin feature-branch
# (Open PR on GitHub - template auto-loads)
```

## Customizing for Your Team

If your team wants to modify these templates:

- **PR template**: Edit `.github/pull_request_template.md`
- **Commit template**: Edit `.github/.gitmessage`

After changing the commit template, team members don't need to reconfigure - their existing `git config commit.template` path still points to the right file.

## Questions?

- Not sure which prefix to use? Look at recent commits for similar changes: `git log --oneline`
- Template too verbose? You can still use `git commit -m "quick message"` for trivial changes
- Want to disable the template temporarily? `git commit --no-template -m "message"`

For more development workflow details, see [development.md](../development.md).
