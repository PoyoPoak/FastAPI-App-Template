# Copilot Coding Agent Instructions

Trust these instructions first. Only search the codebase if information here is incomplete or found to be in error.

## Repository Overview

Full-stack web application built on the FastAPI Full Stack Template. **This is not a template under development—it is a template being used to build real web applications.** Make changes as application features, not template improvements.

- **Backend**: Python 3.10+ with FastAPI, SQLModel ORM, PostgreSQL, Alembic migrations, JWT auth
- **Frontend**: React 19 + TypeScript + Vite 7 + Tailwind CSS 4 + shadcn/ui + TanStack Router/Query
- **Package managers**: `uv` (Python), `bun` (JavaScript/TypeScript)
- **Infrastructure**: Docker Compose with Traefik reverse proxy, Mailcatcher for dev email
- **Linting**: Ruff + mypy (backend), Biome (frontend), prek pre-commit hooks
- **Testing**: pytest (backend), Playwright (frontend E2E)

## Project Layout

```
.                           # Root: workspace configs, Docker Compose, .env
├── backend/
│   ├── app/
│   │   ├── main.py         # FastAPI app entrypoint
│   │   ├── models.py       # SQLModel data models (User, Item, etc.)
│   │   ├── crud.py         # Database CRUD operations
│   │   ├── core/
│   │   │   ├── config.py   # Pydantic Settings (reads ../.env)
│   │   │   ├── db.py       # Database engine & init
│   │   │   └── security.py # JWT & password hashing
│   │   ├── api/
│   │   │   ├── main.py     # API router aggregation
│   │   │   ├── deps.py     # Dependency injection
│   │   │   └── routes/     # Endpoint modules (items, users, login, utils, private)
│   │   ├── alembic/        # Migration scripts
│   │   └── email-templates/# MJML source (src/) and built HTML (build/)
│   ├── tests/              # pytest tests (conftest.py, api/, crud/, utils/)
│   ├── scripts/            # prestart.sh, tests-start.sh, test.sh, lint.sh, format.sh
│   ├── pyproject.toml      # Python deps, ruff/mypy/coverage config
│   ├── alembic.ini         # Alembic configuration
│   └── Dockerfile          # Python 3.10 + uv
├── frontend/
│   ├── src/
│   │   ├── main.tsx        # React entrypoint
│   │   ├── client/         # Auto-generated OpenAPI SDK (DO NOT edit manually)
│   │   ├── components/     # App components + ui/ (shadcn, DO NOT edit ui/ manually)
│   │   ├── routes/         # TanStack Router pages
│   │   └── hooks/          # Custom React hooks
│   ├── tests/              # Playwright E2E tests
│   ├── package.json        # Bun deps & scripts
│   ├── biome.json          # Biome linter/formatter config
│   ├── playwright.config.ts
│   ├── vite.config.ts
│   ├── openapi-ts.config.ts# OpenAPI client generation config
│   ├── components.json     # shadcn/ui configuration
│   ├── Dockerfile          # Bun build → Nginx
│   └── Dockerfile.playwright
├── scripts/                # Root-level scripts
│   ├── generate-client.sh  # Regenerate frontend OpenAPI SDK from backend
│   ├── test.sh             # Full Docker-based test run
│   └── test-local.sh       # Legacy Docker Compose test
├── .env                    # Environment variables (shared by backend & Docker Compose)
├── compose.yml             # Production Docker Compose
├── compose.override.yml    # Dev overrides (ports, hot-reload, mailcatcher, playwright)
├── pyproject.toml          # Root uv workspace config (members: ["backend"])
├── package.json            # Root bun workspace config (workspaces: ["frontend"])
└── .pre-commit-config.yaml # prek/pre-commit hooks config
```

## Build, Test & Lint Commands

### Backend

All backend commands run from the **repository root** unless noted. The backend requires a running PostgreSQL database (use Docker Compose).

```bash
# Install Python dependencies (from repo root)
uv sync --all-packages

# Start database + mailcatcher
docker compose up -d db mailcatcher

# Run Alembic migrations + seed data (required before tests)
cd backend && uv run bash scripts/prestart.sh && cd ..

# Run backend tests with coverage (requires db + migrations)
cd backend && uv run bash scripts/tests-start.sh && cd ..

# Coverage must remain ≥90% — CI will fail otherwise
cd backend && uv run coverage report --fail-under=90 && cd ..

# Lint backend (mypy + ruff check + ruff format check)
cd backend && uv run bash scripts/lint.sh && cd ..

# Auto-format backend
cd backend && uv run bash scripts/format.sh && cd ..

# Ruff only (used by pre-commit)
uv run ruff check --force-exclude --fix
uv run ruff format --force-exclude
```

### Frontend

```bash
# Install frontend dependencies (from repo root)
bun install

# Lint + format frontend (Biome — auto-fixes)
bun run lint

# Build frontend (TypeScript check + Vite build)
cd frontend && bun run build && cd ..

# Run Playwright E2E tests (requires full stack running)
docker compose up -d --wait backend
cd frontend && bunx playwright test && cd ..
```

### Regenerating the Frontend OpenAPI Client

Always regenerate after changing any backend API endpoint, model, or route:

```bash
bash ./scripts/generate-client.sh
```

This script: extracts OpenAPI JSON from the backend → writes `frontend/openapi.json` → runs `openapi-ts` → runs `bun run lint`. The generated files in `frontend/src/client/` must be committed.

### Full Stack Docker

```bash
# Start everything for development (hot-reload enabled)
docker compose watch

# Or start specific services
docker compose up -d db mailcatcher backend frontend

# Clean teardown
docker compose down -v --remove-orphans
```

### Creating Alembic Migrations

After modifying SQLModel models in `backend/app/models.py`:

```bash
docker compose exec backend bash
alembic revision --autogenerate -m "Description of change"
alembic upgrade head
```

Commit the generated migration files in `backend/app/alembic/versions/`.

## CI Checks on Pull Requests

Every PR triggers these workflows that **must all pass**:

| Workflow | File | What it checks |
|---|---|---|
| **pre-commit** | `pre-commit.yml` | Runs `prek` (ruff check, ruff format, biome check, large files, YAML/TOML, trailing whitespace, end-of-file fixer, frontend SDK regeneration). Auto-commits fixes. |
| **Test Backend** | `test-backend.yml` | Spins up PostgreSQL + mailcatcher via Docker Compose, runs `uv run bash scripts/prestart.sh` then `uv run bash scripts/tests-start.sh`, enforces ≥90% coverage. Python 3.10. |
| **Playwright Tests** | `playwright.yml` | Builds Docker images, runs Playwright tests sharded across 4 workers. Only runs when backend/, frontend/, .env, compose*.yml, or the workflow file changes. |
| **Test Docker Compose** | `test-docker-compose.yml` | Builds and starts full stack, curls health endpoints. |
| **Labels** | `labeler.yml` | Requires exactly one label from: `breaking, security, feature, bug, refactor, upgrade, docs, lang-all, internal`. |
| **Conflict detector** | `detect-conflicts.yml` | Flags PRs with merge conflicts. |

### Pre-commit Hooks (prek)

The `.pre-commit-config.yaml` defines these hooks executed in order:

1. `check-added-large-files` — blocks large file commits
2. `check-toml` / `check-yaml` — syntax validation
3. `end-of-file-fixer` — ensures files end with newline (excludes `frontend/src/client/`, `backend/app/email-templates/build/`)
4. `trailing-whitespace` — removes trailing spaces (excludes `frontend/src/client/`)
5. `biome check` — frontend linting (runs `npm run lint` on `frontend/` files)
6. `ruff check` — Python linting with auto-fix
7. `ruff format` — Python formatting
8. `generate-frontend-sdk` — re-generates `frontend/src/client/` when backend files change

## Key Conventions

- **Python**: Target Python 3.10. Ruff enforces pycodestyle, pyflakes, isort, flake8-bugbear, comprehensions, pyupgrade, no-print, no-unused-args. No `print()` statements allowed (T201 rule).
- **TypeScript**: Biome enforces double quotes, space indentation, semicolons only as needed. Files in `src/client/`, `src/components/ui/`, and `src/routeTree.gen.ts` are excluded from linting (auto-generated).
- **Do not manually edit**: `frontend/src/client/**` (generated by openapi-ts), `frontend/src/components/ui/**` (managed by shadcn/ui), `frontend/src/routeTree.gen.ts` (generated by TanStack Router plugin).
- **Environment variables**: All in root `.env` file. Backend reads via `pydantic-settings` from `../.env`. Never commit real secrets.
- **API prefix**: All backend routes are under `/api/v1`. The `private` router only loads when `ENVIRONMENT=local`.
- **Database models**: Defined in `backend/app/models.py` using SQLModel. Always create Alembic migrations after model changes.
- **Shell scripts**: Must use LF line endings (enforced by `.gitattributes`).
- **Coverage threshold**: Backend test coverage must be ≥90%.

## Common Pitfalls

- **Backend tests require a running PostgreSQL**: Always `docker compose up -d db mailcatcher` and run `prestart.sh` before running pytest.
- **Frontend client out of sync**: If you change backend API routes/models and forget to run `bash ./scripts/generate-client.sh`, pre-commit and CI will fail.
- **`uv sync --all-packages`** must be run from the repo root (not `backend/`) to resolve the workspace correctly. Running `uv sync` from `backend/` also works for backend-only deps.
- **`bun install`** must be run from the repo root to install the workspace. Running from `frontend/` also works but the root lockfile (`bun.lock`) is the source of truth.
- **PR label requirement**: CI requires one of: `breaking, security, feature, bug, refactor, upgrade, docs, lang-all, internal`. PRs without a label will fail the Labels check.
