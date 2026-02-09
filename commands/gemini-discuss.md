---
description: "Main router for Gemini discussion commands: discuss, review, brainstorm, analyze, compare, help"
argument-hint: "<subcommand> [args]"
allowed-tools: ["Skill"]
---

# Gemini Discuss - Command Router

Route the user's input to the appropriate gemini-discuss subcommand.

## Input

- Full input: `$ARGUMENTS`

## Routing Logic

Parse the first word of `$ARGUMENTS` as the subcommand, and the rest as arguments to pass along.

| First Word | Action |
|------------|--------|
| `discuss` | Invoke `/gemini-discuss:discuss` with remaining args |
| `review` | Invoke `/gemini-discuss:review` with remaining args |
| `brainstorm` | Invoke `/gemini-discuss:brainstorm` with remaining args |
| `analyze` | Invoke `/gemini-discuss:analyze` with remaining args |
| `compare` | Invoke `/gemini-discuss:compare` with remaining args |
| `help` | Invoke `/gemini-discuss:help` |
| (empty) | Invoke `/gemini-discuss:help` |
| (anything else) | Treat entire `$ARGUMENTS` as a discuss topic — invoke `/gemini-discuss:discuss` with full `$ARGUMENTS` |

## Execution

Use the Skill tool to invoke the appropriate subcommand. For example:
- Input: `discuss how should I structure this API`
  → Invoke Skill with `skill: "gemini-discuss:discuss"` and `args: "how should I structure this API"`
- Input: `review src/main.rs`
  → Invoke Skill with `skill: "gemini-discuss:review"` and `args: "src/main.rs"`
- Input: `help`
  → Invoke Skill with `skill: "gemini-discuss:help"`
- Input: `이 아키텍처 괜찮아?`
  → No known subcommand, so invoke Skill with `skill: "gemini-discuss:discuss"` and `args: "이 아키텍처 괜찮아?"`

## CRITICAL RULES

1. Always route to the correct subcommand via the Skill tool.
2. If the input doesn't match any subcommand, default to `discuss`.
3. Do NOT call Gemini MCP tools directly from this router — always delegate to subcommands.
