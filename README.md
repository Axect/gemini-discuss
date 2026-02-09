# gemini-discuss

A Claude Code plugin for discussing with Gemini using the correct model (`gemini-3-pro-preview`).

## Problem

The Gemini CLI defaults to a different model, and remembering to pass `-m gemini-3-pro-preview` every time is error-prone. This plugin ensures every Gemini call explicitly uses the correct model while providing convenient slash commands with automatic project context gathering.

## Commands

| Command | Description |
|---------|-------------|
| `/gemini-discuss discuss <topic>` | General discussion with Gemini based on current context |
| `/gemini-discuss review [file]` | Code review of changes or a specific file |
| `/gemini-discuss brainstorm <topic>` | Generate ideas using structured methodology |
| `/gemini-discuss analyze <file/topic>` | Deep analysis of a file or topic |
| `/gemini-discuss compare <topic>` | Compare Claude and Gemini perspectives |
| `/gemini-discuss help` | Show usage help |

All commands can also be invoked as `/gemini-discuss:<subcommand>`.

## Features

- **Model enforcement**: Always uses `gemini-3-pro-preview`, never the default
- **No MCP dependency**: Calls Gemini CLI directly — no MCP server required
- **Auto context collection**: Gathers git state, recent files, and project info before each call
- **Smart routing**: `/gemini-discuss <anything>` routes unknown subcommands to `discuss`
- **Structured brainstorming**: Automatically selects methodology (SCAMPER, Design Thinking, First Principles, etc.) based on topic

## Installation

```bash
# 1. Add the marketplace
claude plugin marketplace add Axect/gemini-discuss

# 2. Install the plugin
claude plugin install gemini-discuss
```

## Requirements

- [Claude Code](https://claude.com/claude-code) CLI
- [Gemini CLI](https://github.com/google-gemini/gemini-cli) installed and authenticated

## License

MIT
