# komodo-claude-core

Shared Claude Code configuration for all Komodo projects. Settings, skills, and agents live here and are symlinked into `~/.claude/` so every project inherits them automatically.

## Structure

```
komodo-claude-core/
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

This symlinks everything in `claude/` into `~/.claude/` automatically. Any new file or directory added to `claude/` will be picked up on the next run.

Restart Claude Code after running setup.

## Workflows

Multi-agent orchestration with human checkpoints. Each agent runs in an isolated context window — nothing from the conversation bleeds across agents, keeping token usage proportional to the task.

| Skill | Description |
|-------|-------------|
| `/feature-workflow` | Architect → user approval → parallel SWE + marketing/sales/legal dispatch |
| `/dispatch` | Route any task to relevant domain agents in parallel, synthesize results |

**Token hygiene enforced by both skills:** agents receive structured packets (≤300 words), never raw conversation history. File contents are never passed — only paths.

**MCP path:** when you have an MCP server running, each agent call maps directly to a tool call. The workflow skills are already structured around isolated packets, so the migration is mechanical.

## Skills

### Engineering — Software

| Skill | Path | Description |
|-------|------|-------------|
| `/new-service` | `engineering/software/ui` | Scaffold a new Go microservice (Fargate or Lambda target) |
| `/add-route` | `engineering/software/ui` | Add handler + test stub + OpenAPI entry to an existing service |
| `/new-component` | `engineering/software/ui` | Scaffold a Svelte 5 component with accessibility and test stub |
| `/new-page` | `engineering/software/ui` | Scaffold a SvelteKit 5 page (SSR, auth guard, optional BFF route) |
| `/new-middleware` | `engineering/software/api` | Scaffold a new HTTP middleware in `komodo-forge-sdk-go` |
| `/new-migration` | `engineering/software/db` | Create a new database schema migration |
| `/new-tf-module` | `engineering/software/infra` | Scaffold a Terraform module for a service or shared resource |

### Engineering — Other

| Skill | Path | Description |
|-------|------|-------------|
| `/circuit-review` | `engineering/electrical` | Review an electrical circuit design or schematic |
| `/new-bom` | `engineering/hardware` | Generate or review a hardware Bill of Materials |
| `/design-review` | `engineering/mechanical` | Review a mechanical design for structural, thermal, or DFM issues |
| `/new-ros-node` | `engineering/robotics` | Scaffold a ROS 2 node (C++ or Python) |

### Business Operations

| Skill | Path | Description |
|-------|------|-------------|
| `/crop-analysis` | `agriculture` | Analyze crop health, yield data, or soil conditions |
| `/ticket-response` | `customer-servicing` | Draft a customer-facing response to a support ticket |
| `/stock-report` | `inventory` | Generate an inventory stock report |
| `/campaign-brief` | `marketing` | Generate a marketing campaign brief |
| `/proposal` | `sales` | Draft a sales proposal or quote document |

## Agents

| Agent | Model | Description |
|-------|-------|-------------|
| `architect` | opus | Cross-business domain strategy and architecture — software, product, commercial, ops, org |
| `swe` | sonnet | Senior/tech lead — implementation, code review, security, performance, CI/CD, maintainability |
| `devops` | sonnet | CI/CD, infrastructure, deployments, monitoring, incident response |
| `quality-assurance` | sonnet | Test planning, QA review, bug triage, release gates |
| `electrical-engineer` | sonnet | Circuit design, schematic review, PCB layout, component selection |
| `robotics` | sonnet | ROS 2 development, motion planning, sensor integration |
| `mechatronics` | sonnet | Embedded firmware, actuator/sensor interfaces, hardware-software integration |
| `project-manager` | sonnet | Task breakdown, sprint planning, delivery risk, stakeholder communication |
| `lawyer` | opus | Contract review, compliance analysis, legal research (not legal advice) |
| `botanist` | haiku | Plant science, crop health diagnosis, and agricultural botany |
| `customer-servicing` | haiku | Customer response drafting, ticket triage, and escalation support |
| `marketing` | haiku | Campaign strategy, copywriting, and brand messaging |
| `sales` | haiku | Lead qualification, proposal writing, and negotiation preparation |
| `warehouse-manager` | haiku | Warehouse operations, inventory control, and logistics planning |

## Project-level config

Individual projects keep only project-specific overrides in their own `.claude/settings.json`. Global permissions and skills live here and should not be duplicated per-project.
