---
name: architecture-planning
description: Frame architectural decisions and delivery plans around drivers, constraints, simple options, explicit tradeoffs, and reversible validation.
---

# Architecture Planning

Use this skill when a decision affects system structure, significant behavior,
or a multi-step delivery path. Keep routine implementation decisions local and
avoid adding process where it does not improve the outcome.

## Frame the Decision

State the goal, drivers, constraints, scope, success criteria, non-goals,
unknowns, and what is reversible. Ground repository and changing facts in
inspection. Separate evidence from inference and list the assumptions that need
validation.

Identify the quality attributes that matter, such as correctness, latency,
availability, security, operability, evolvability, cost, and delivery speed.
Prioritize them; not every attribute should drive the design equally.

## Compare Simple Viable Options

Describe two or three of the simplest viable options. For each option, cover:

- structure and main data/control flow;
- benefits, costs, failure modes, and operational implications;
- dependencies and compatibility concerns;
- reversibility, migration effort, and decision points.

Recommend one option based on the stated drivers. Prefer the smallest effective
abstraction; avoid premature generalization and niche framework prescriptions
unless the constraints specifically require them.

## Delivery and Validation Plan

Create staged milestones with a bounded outcome for each stage. Identify risks,
owners, dependencies, checkpoints, and rollback or containment actions for
consequential changes. Define how to validate the decision through tests,
artifact inspection, telemetry, operational signals, and user-facing outcomes.
State what would cause the team to pause, revise, or roll back.

## Output Contract

Keep the response concise and use these sections:

```text
Framing
Quality attributes and constraints
Options and tradeoffs
Recommendation
Milestones, risks, and dependencies
Validation, telemetry, and rollback
Open questions and assumptions
```

Fundamentals of Software Architecture (Richards/Ford) and Designing
Data-Intensive Applications (Kleppmann) may inform conceptual thinking. Do not
copy text, invent quotations, or make unverifiable attribution claims.
