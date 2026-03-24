# komodo-claude

Shared Claude Code configuration for all Komodo projects. Settings, skills, and agents live here and are symlinked into `~/.claude/` so every project inherits them automatically.

## Structure

```
komodo-claude/
├── claude/
│   ├── settings.json   # Global permissions, plugins, allowed commands
│   ├── skills/         # User-invocable skills (/new-service, /add-route, etc.)
│   └── agents/         # Shared agents (future — advisor, swe, etc.)
├── setup.sh            # One-time symlink bootstrap
└── README.md
```

## Setup

Run once after cloning:

```bash
bash setup.sh
```

This symlinks:
- `~/.claude/settings.json` → `komodo-claude/claude/settings.json`
- `~/.claude/skills/` → `komodo-claude/claude/skills/`

Restart Claude Code after running setup.

## Skills

| Skill | Description |
|-------|-------------|
| `/new-service` | Scaffold a new Go microservice (Fargate or Lambda target) |
| `/add-route` | Add handler + test stub + OpenAPI entry to an existing service |
| `/new-component` | Scaffold a Svelte 5 component with accessibility and test stub |
| `/new-page` | Scaffold a SvelteKit 5 page (SSR, auth guard, optional BFF route) |

## Project-level config

Individual projects keep only project-specific overrides in their own `.claude/settings.json`. Global permissions and skills live here and should not be duplicated per-project.
