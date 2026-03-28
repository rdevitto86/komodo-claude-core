# Skill: /feature-workflow

Orchestrate a multi-agent feature development workflow: architect designs, user approves, SWE implements. Keeps each agent's context window isolated to only what it needs.

## Usage

```
/feature-workflow <description>
```

- `<description>` — What needs to be built, changed, or investigated. Can be brief; the architect will ask for more if needed.

---

## Why this workflow

Each agent below runs as an isolated subagent with its own fresh context window. Nothing from the current conversation bleeds into them — only the structured packet you explicitly pass. This keeps per-agent token cost low and avoids agents being confused by unrelated context.

You (the user) are the decision gate between phases. Nothing moves forward without your sign-off.

---

## Phase 1 — Architecture

Spawn the `architect` subagent with this exact context packet (nothing more):

```
Task: [the feature description]
Codebase context: [3–5 bullet summary of relevant services, patterns, constraints — read CLAUDE.md if present]
Constraints: [any you know of: deadline, no-new-services, must-use-existing-infra, etc.]

Produce:
1. A brief problem restatement (1 para)
2. Proposed approach (bullet points, not prose)
3. Files/services affected (list)
4. Open questions requiring user decision (numbered)
5. Risks (bullet points)

Keep total output under 400 words. No implementation code.
```

**Checkpoint A** — Present the architect's output to the user in a clean block. Ask:
- "Do you approve this approach, or should the architect revise?"
- Address each open question directly (user answers, not architect guesses)

Do not proceed to Phase 2 until the user explicitly approves.

---

## Phase 2 — Parallel implementation dispatch

Once the user approves, extract a **spec packet** from the architect output:

```
Approved spec:
- Approach: [architect's proposed approach, revised per user answers]
- Files to change: [list]
- Constraints: [any user-added constraints from Checkpoint A]
- Out of scope: [explicitly list what is NOT being built]
```

Spawn all applicable agents **in the same response** so they run in parallel:

### Always: `swe`

```
Task: implement the following spec. Do not deviate from the approach.
[paste spec packet]

Coding conventions: follow patterns in the files you'll be modifying.
Output: list of changes made, any blockers encountered, and any decisions you made that weren't covered by the spec.
```

### If the feature has user-facing copy or announcement needs: `marketing`

```
Task: draft internal and/or external messaging for this feature.
Feature summary: [1-sentence plain-English description of what changed and why users care]
Audience: [internal team / external customers / both]
Output: release note (2–3 sentences), internal Slack announcement (2–3 sentences).
```

### If the feature affects pricing, packaging, or a customer contract: `sales`

```
Task: flag any sales or commercial implications.
Feature summary: [same 1-sentence description]
Output: bullet list of commercial implications, talking points for AEs, any contract clauses that may need updating.
```

### If the feature involves a new legal surface (data handling, ToS change, third-party): `lawyer`

```
Task: identify legal considerations.
Feature summary: [1-sentence description]
New data handled or shared: [yes/no + description]
Output: bullet list of legal considerations and recommended next steps.
```

---

## Phase 3 — Review and checkpoint B

Once all parallel agents complete, present a consolidated summary:

```
## Implementation
[SWE's summary of changes made and any blockers]

## Decisions made without spec guidance
[SWE's list — these need user review]

## Messaging (if generated)
[marketing's output]

## Commercial notes (if generated)
[sales output]

## Legal flags (if generated)
[lawyer output]
```

**Checkpoint B** — Ask the user:
1. Are the SWE's unspecified decisions acceptable?
2. Any revisions needed to messaging or commercial notes before sharing?
3. Are legal flags being tracked somewhere?

---

## Token and context hygiene rules

- Never pass raw conversation history to a subagent. Always distill to a structured packet.
- Never include file contents in a subagent packet unless that file is the primary subject of the task. Pass file paths and let the subagent read what it needs.
- Keep context packets under 300 words. If you can't summarize the task in 300 words, the task is too large — split it.
- If a phase produces a long output (>500 words), summarize it before passing to the next phase.
