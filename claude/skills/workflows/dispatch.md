# Skill: /dispatch

Route a task to one or more domain agents in parallel. Use when you have a task that spans multiple domains and want all relevant agents working simultaneously with isolated context windows.

## Usage

```
/dispatch <task>
```

- `<task>` — What needs to happen. Can reference multiple domains. Dispatch will identify relevant agents and run them in parallel.

---

## Step 1 — Identify relevant agents

Read the task and select from this agent roster. Pick only agents where there is clear, actionable work — do not include agents "just in case":

| Agent | Use when the task involves... |
|-------|------------------------------|
| `architect` | Cross-domain strategy and architecture decisions — software, product, commercial, operations, org |
| `swe` | Implementation, code review, debugging, refactoring, and technical leadership |
| `project-manager` | Task breakdown, sprint planning, stakeholder updates, delivery risk |
| `quality-assurance` | Test planning, QA review, bug triage, release gates |
| `devops` | CI/CD, infrastructure, deployments, monitoring, incidents |
| `electrical-engineer` | Circuit design, schematics, PCB, component selection |
| `robotics` | ROS 2, motion planning, sensor integration, robot perception |
| `mechatronics` | Embedded firmware, actuator/sensor interfaces, hardware-software integration |
| `sales` | Proposals, lead qualification, pipeline, commercial terms |
| `marketing` | Campaign copy, messaging, positioning, content |
| `customer-servicing` | Customer responses, ticket triage, escalation drafts |
| `lawyer` | Contracts, compliance, legal review |
| `botanist` | Crop science, plant health, growing conditions |
| `warehouse-manager` | Inventory, logistics, warehouse operations |

If only one agent applies, just invoke that agent directly without the dispatch wrapper.

---

## Step 2 — Build isolated context packets

For each selected agent, build a **minimal context packet** containing only what that agent needs:

```
Agent: <name>
Task: <specific sub-task for this agent — not a copy-paste of the full request>
Context: <1–3 bullet points of relevant background, nothing more>
Output format: <what you want back — bullets, draft, list, decision, etc.>
Word limit: <200 for simple tasks, 400 for complex ones>
```

Never give all agents the same packet. Each packet should be scoped to that agent's domain slice of the overall task.

---

## Step 3 — Spawn all agents in the same response

Call all selected agents in a single response so they run in parallel. Do not wait for one to finish before starting the next.

---

## Step 4 — Synthesize and present

Once all agents complete, present results grouped by agent with a brief header. If agents produced conflicting recommendations, flag the conflict explicitly rather than silently picking one.

If any agent output requires a user decision before the work can be acted on, call that out as a numbered decision item at the end:

```
## Decisions needed
1. [agent]: [decision + options]
2. ...
```

---

## When NOT to use dispatch

- Single-domain tasks: just call the agent directly.
- Sequential tasks where phase 2 depends on phase 1 output: use `/feature-workflow` instead.
- Tasks where you need the agents to confer: dispatch doesn't support inter-agent communication — each agent works in isolation.
