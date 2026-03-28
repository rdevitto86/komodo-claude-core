# Skill: /trello

Interact with Trello via MCP to manage planning cards and TODO items that agents can act on.

## Usage

```
/trello <action> [args]
```

Actions: `plan`, `add`, `list`, `assign`, `status`, `breakdown`

---

## Actions

### `plan` — Convert a feature or goal into a set of Trello cards

```
/trello plan <description>
```

1. Ask the user for the target board and list (e.g., "Backlog") if not provided
2. Break the goal into discrete, agent-actionable tasks (see card format below)
3. Create one card per task via the Trello MCP tool
4. Report back the card URLs

Use this to turn a feature brief, meeting note, or TODO list into structured cards that agents can pick up.

---

### `add` — Add a single card

```
/trello add <title> [--list <list-name>] [--desc <description>]
```

Creates one card with the given title. If `--desc` is omitted, prompt the user for acceptance criteria before creating.

---

### `list` — Show cards in a list

```
/trello list [--board <board>] [--list <list-name>]
```

Fetches and displays cards from the specified list. Default: current project's active sprint list.

---

### `assign` — Assign a card to an agent or person

```
/trello assign <card-id-or-title> --to <agent-or-member>
```

Updates the card description or label to indicate which agent type should handle it (e.g., `[agent:swe]`, `[agent:devops]`). Useful for pre-routing work before dispatching.

---

### `status` — Update a card's status

```
/trello status <card-id-or-title> --move-to <list-name>
```

Moves a card to the specified list (e.g., "In Progress", "Done", "Blocked").

---

### `breakdown` — Break an existing card into subtasks

```
/trello breakdown <card-id-or-title>
```

Reads the card description, decomposes it into subtasks, and either:
- Adds a checklist to the card (for small breakdowns)
- Creates child cards in the same list (for larger breakdowns)

---

## Card format for agent-actionable tasks

When creating cards that agents will act on, include:

```
**Goal:** [what needs to be done, one sentence]

**Context:** [why this matters, 2–3 bullets]

**Scope:** [what to touch, what to leave alone]

**Acceptance criteria:**
- [ ] ...
- [ ] ...

**Agent:** [swe | devops | qa | pm | architect]
**Blocked by:** [card title or "nothing"]
```

Cards without acceptance criteria will not be picked up by agents — they are ambiguous by definition.

---

## Connecting cards to work

- When starting work from a Trello card, include the card URL in the PR description
- When a PR merges, move the card to "Done" using `/trello status`
- When a task is blocked, move it to "Blocked" and add a comment explaining what's needed

---

## MCP setup note

Requires the Trello MCP server to be configured and running. Until MCP tooling is set up locally, use this skill to generate the card structure and content — manually create the cards in Trello using the formatted output.
