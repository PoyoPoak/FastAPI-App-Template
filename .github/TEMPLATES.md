# GitHub Templates Guide

This repository uses templates to maintain consistency across commits and pull requests.

## Pull Request Template

When creating a new pull request, GitHub will automatically populate the description with our PR template. Simply fill in the relevant sections:

- **Description**: Brief summary of your changes
- **Type of Change**: Check the box that applies
- **Changes Made**: List key changes
- **Testing**: Describe your testing approach
- **Checklist**: Ensure all items are addressed

## Commit Message Template

To use the commit message template locally, configure it once:

```bash
git config commit.template .github/.gitmessage
```

After configuration, when you run `git commit`, your editor will open with the template pre-filled.

### Commit Message Format

```
<type>: <subject>

<body>

<footer>
```

**Common types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `refactor`: Code refactoring
- `test`: Test updates
- `chore`: Maintenance tasks

**Examples:**
```
feat: Add user authentication endpoint

Implement JWT-based authentication for API users.
Includes login, logout, and token refresh endpoints.

Closes #42
```

```
fix: Resolve database connection timeout

Increase connection pool timeout from 5s to 30s
to handle high load scenarios.

Fixes #156
```

## Best Practices

- Keep commits focused on a single change
- Write clear, descriptive PR descriptions
- Reference related issues in commit messages and PRs
- Review your own changes before requesting review
- Ensure tests pass before submitting PRs
