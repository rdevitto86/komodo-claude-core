# komodo-claude

Shared Claude Code configuration for all Komodo projects. Settings, skills, agents, hooks, and standards live here and are symlinked into `~/.claude/` via `setup.sh`.

## What this repo is

This is not a product codebase. It is the Claude Code configuration layer — agents, skills, standards, and hooks that are shared across every Komodo project. Changes here affect all projects on the next Claude Code session.

## Directory layout

```
claude/
├── agents/          # Subagents Claude can spawn
├── skills/          # User-invocable slash commands (/feature-workflow, /dispatch, etc.)
├── standards/       # Engineering and operational standards referenced by agents and skills
├── hooks/           # Shell scripts triggered automatically by Claude Code events
└── settings.json    # Global permissions, allowed commands, plugins, hook registration
```

## Agents

| Agent | Model | Role |
|-------|-------|------|
| `architect` | opus | Cross-business domain strategy and architecture — software is the primary lens, but covers product, commercial, ops, org, and legal at a strategic level. Chat-first, formalizes when settled. |
| `swe` | sonnet | Senior/tech lead level — implementation, code review, debugging, refactoring, CI/CD, security, and performance. |
| `devops` | sonnet | CI/CD, infrastructure, deployments, monitoring, incident response. |
| `quality-assurance` | sonnet | Test planning, QA review, bug triage, release gates. |
| `electrical-engineer` | sonnet | Circuit design, schematic review, PCB layout, component selection. |
| `robotics` | sonnet | ROS 2, motion planning, sensor integration, robot perception. |
| `mechatronics` | sonnet | Embedded firmware, actuator/sensor interfaces, hardware-software integration. |
| `project-manager` | sonnet | Task breakdown, sprint planning, delivery risk, stakeholder communication. |
| `lawyer` | opus | Contract review, compliance, legal research. Not legal advice. |
| `botanist` | haiku | Crop health, plant science, agricultural diagnosis. |
| `customer-servicing` | haiku | Customer response drafting, ticket triage, escalation summaries. |
| `marketing` | haiku | Campaign strategy, copywriting, brand messaging. |
| `sales` | haiku | Lead qualification, proposals, negotiation, CRM. |
| `warehouse-manager` | haiku | Inventory control, logistics, warehouse operations. |

**Model tiers:**
- `haiku` — simple/lookup/drafting tasks
- `sonnet` — complex technical work (default)
- `opus` — highest reasoning demand (architecture, legal)

## Key skills

| Skill | When to use |
|-------|-------------|
| `/feature-workflow` | Multi-phase: software-architect designs → user approves → parallel implementation dispatch |
| `/dispatch` | Route a task to multiple domain agents in parallel with isolated context windows |
| `/git-flow` | Branch naming, commit conventions, PR process |
| `/new-service` | Scaffold a Go microservice |
| `/new-migration` | Create a database schema migration |
| `/new-tf-module` | Scaffold a Terraform module |
| `/new-page` | Scaffold a SvelteKit 5 page |
| `/new-component` | Scaffold a Svelte 5 component |

See `claude/skills/` for the full list.

## Standards

Engineering and operational standards in `claude/standards/`. Agents reference these by name — do not rename files without updating agent prompts.

| File | Covers |
|------|--------|
| `security.md` | Secrets, input validation, auth, OWASP, incident response |
| `pull-requests.md` | PR size, descriptions, review duties, merge criteria |
| `api-design.md` | URL conventions, HTTP methods, status codes, versioning, OpenAPI |
| `go.md` | Formatting, error handling, naming, testing, concurrency |
| `typescript.md` | Type safety, naming, async patterns, module conventions, testing |
| `sql.md` | Schema conventions, migrations, indexing, query safety |
| `logging.md` | Log levels, required fields, what never to log, correlation |

## Hooks (auto-run)

| Hook | Trigger | What it does |
|------|---------|--------------|
| `post-edit-lint.sh` | After Edit or Write | Runs `golangci-lint` (Go) or `tsc --noEmit` (TS/Svelte) |
| `stop-summary.sh` | Session end | Shows git diff summary if uncommitted changes exist |
| `post-pr-trello.sh` | After `gh pr create` | Surfaces PR URL and Trello card reminder |

## Setup

Run once after cloning:

```bash
bash setup.sh
```

Symlinks `claude/` contents into `~/.claude/`. Restart Claude Code after running.
