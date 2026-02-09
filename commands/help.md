---
description: Show gemini-discuss plugin usage and available commands
allowed-tools: []
---

# Gemini Discuss - Help

Display the following help information to the user:

---

## gemini-discuss Plugin

Discuss with Gemini using the correct model (`gemini-3-pro-preview`). All commands automatically collect project context and call the Gemini CLI directly.

### Available Commands

| Command | Description |
|---------|-------------|
| `/gemini discuss <topic>` | General discussion with Gemini based on current context |
| `/gemini review [file]` | Code review of changes or a specific file |
| `/gemini brainstorm <topic>` | Generate ideas with structured methodology |
| `/gemini analyze <file/topic>` | Deep analysis of a file or topic |
| `/gemini compare <topic>` | Compare Claude and Gemini perspectives |
| `/gemini help` | Show this help message |

### Alternative Invocation

All commands can also be called with colon syntax:
- `/gemini:discuss <topic>`
- `/gemini:review [file]`
- `/gemini:brainstorm <topic>`
- `/gemini:analyze <file/topic>`
- `/gemini:compare <topic>`
- `/gemini:help`

### How It Works

This plugin calls the Gemini CLI (`gemini -m gemini-3-pro-preview`) directly via Bash, ensuring the correct model is always used. No MCP server dependency required — only the Gemini CLI needs to be installed.

### Context Collection

Each command automatically gathers:
- Git branch, recent commits, and diff summary
- Recently modified files (last 30 minutes)
- Relevant files based on the topic

---
