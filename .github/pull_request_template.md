### What does this PR do?

*Briefly explain what you're changing and why it matters for the FastAPI full-stack template*

---

### Which parts of the stack are affected?

**Python Backend (FastAPI/SQLModel)**
- [ ] API routes in `backend/app/api/`
- [ ] Database models in `backend/app/models/`
- [ ] Core utilities or config in `backend/app/core/`
- [ ] Alembic migrations
- [ ] Backend tests

**React Frontend (TypeScript/Vite/TanStack)**
- [ ] Route components in `frontend/src/routes/`
- [ ] Reusable components in `frontend/src/components/`
- [ ] API client in `frontend/src/client/`
- [ ] Custom hooks in `frontend/src/hooks/`
- [ ] Playwright E2E tests

**Docker & Orchestration**
- [ ] compose.yml or compose.override.yml
- [ ] Dockerfiles
- [ ] Traefik configuration
- [ ] PostgreSQL setup

**Development Tooling**
- [ ] Pre-commit configuration (.pre-commit-config.yaml)
- [ ] GitHub Actions workflows
- [ ] Scripts in `/scripts` or `/backend/scripts`

**Documentation**
- [ ] README, development.md, or deployment.md

---

### How did you verify this works?

**Local validation steps I completed:**
- [ ] Ran `docker compose watch` and the stack built successfully
- [ ] Backend pytest suite passes (`docker compose exec backend pytest`)
- [ ] Frontend builds without errors
- [ ] Playwright tests pass (if UI changes)
- [ ] Pre-commit hooks (prek) run clean
- [ ] Manually tested the feature in browser at localhost:5173

**Specific scenarios tested:**

*Describe what you actually tried - e.g., "Created a new user, logged in, verified the profile page shows correct data"*

---

### Database impact?

- [ ] This PR has zero database changes
- [ ] New SQLModel models added (list them:
- [ ] Existing models modified (describe:
- [ ] Alembic migration included (version:

---

### Environment variables or secrets?

*Do any .env variables need to be added or changed for this to work?*

---

### Anything that could break existing functionality?

*Will this change APIs that existing frontends depend on? Change database schemas? Modify authentication flows?*

---

### Visual proof (if UI changed)

*Paste screenshots or GIFs here showing before/after for any UI modifications*

---

### For reviewers

*Anything specific you want reviewers to focus on or test?*
