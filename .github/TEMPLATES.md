# Team Guide: Using Commit and PR Templates

## What we added

Two template files to help write better commits and pull requests:

1. **`.github/pull_request_template.md`** - Automatically loads when creating PRs on GitHub
2. **`.github/.gitmessage`** - Shows up when you commit (needs setup below)

## Setting up the commit template

This is a one-time thing each person does in their local clone:

```bash
git config commit.template .github/.gitmessage
```

Now when you run `git commit` (without the `-m` flag), your editor opens with helpful prompts.

## How to actually use them

### For commits

**With the template (detailed commits):**
```bash
git add backend/app/api/routes/users.py
git commit
# Editor opens with questions → answer them → save and close
```

**Quick commits (still works):**
```bash
git commit -m "bugfix: correct typo in users route response"
```

### For pull requests

Just create a PR on GitHub like normal - the template appears automatically. Answer the questions that apply, delete the rest.

## Why these templates help

They're designed around the actual files in this repo:

**Commit template mentions:**
- Real route files (`items.py`, `users.py`, `login.py`)
- Actual frontend pages (`login.tsx`, `signup.tsx`, `reset-password.tsx`)
- Specific directories (`backend/app/models/`, `frontend/src/components/`)
- Commands we actually use (`docker compose watch`, `pytest`)

**PR template asks:**
- Did you test with `docker compose watch`?
- Did backend pytest pass?
- Did you create an Alembic migration?
- What did you manually test in the browser?

## Suggested commit prefixes

Based on which files you're changing:

| If you changed... | Try this prefix | Example |
|-------------------|----------------|---------|
| `backend/app/api/routes/users.py` | `users route:` | `users route: add pagination` |
| `backend/app/api/routes/items.py` | `items route:` | `items route: fix delete permission` |
| `backend/app/api/routes/login.py` | `login route:` | `login route: add rate limiting` |
| `backend/app/models/*.py` | `models:` | `models: add User.bio field` |
| `backend/app/core/config.py` | `config:` | `config: add SMTP settings` |
| `backend/alembic/versions/*.py` | `alembic:` | `alembic: create items_idx migration` |
| `frontend/src/routes/login.tsx` | `login page:` | `login page: add remember me checkbox` |
| `frontend/src/routes/signup.tsx` | `signup page:` | `signup page: validate password strength` |
| `frontend/src/components/**` | `components:` | `components: create DataTable` |
| `frontend/src/hooks/*.ts` | `hooks:` | `hooks: add useDebounce` |
| `compose.yml` | `docker services:` | `docker services: upgrade PostgreSQL to 16` |
| `.github/workflows/*.yml` | `ci pipeline:` | `ci pipeline: add frontend linting` |
| README/docs | `docs:` | `docs: update setup instructions` |

See more examples in `.github/.gitmessage` itself.

## Fitting into your workflow

The templates work alongside existing tools:

1. Make changes to code
2. Run `git add`
3. Run `git commit` ← template guides your message
4. Pre-commit hooks (prek) run automatically
5. Run `git push`
6. Create PR on GitHub ← template guides your description

## Customizing

Both templates are just markdown files you can edit:

```bash
vim .github/pull_request_template.md
vim .github/.gitmessage
```

Changes take effect immediately. Team members don't need to reconfigure anything.

## Turning templates off

**Skip PR template:** Delete the pre-filled text when creating the PR

**Skip commit template:** Use `git commit -m "message"`

**Permanently disable commit template:**
```bash
git config --unset commit.template
```

## Quick reference commands

```bash
# View recent commits to see how others format them
git log --oneline -15

# Preview the commit template without committing
cat .github/.gitmessage

# Check if commit template is configured
git config --get commit.template

# Commit without using the template once
git commit --no-template -m "quick change"
```

## Getting started

1. Run the setup command above to configure commit template
2. Make a small change (like fix a typo in a comment)
3. Run `git commit` to see the template in action
4. Create a test PR to see the PR template

Questions? Check [development.md](../development.md) for more workflow info.
