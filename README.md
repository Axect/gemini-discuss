# gemini-discuss

A Claude Code plugin for discussing with Gemini using the correct model (`gemini-3-pro-preview`).

## Problem

The `gemini-mcp-tool` defaults to `gemini-2.5-pro`, and modifying npm cache files is fragile. This plugin ensures every Gemini call explicitly passes `model: "gemini-3-pro-preview"` while providing convenient slash commands.

## Commands

| Command | Description |
|---------|-------------|
| `/gemini discuss <topic>` | General discussion with Gemini based on current context |
| `/gemini review [file]` | Code review of changes or a specific file |
| `/gemini brainstorm <topic>` | Generate ideas using Gemini's brainstorm tool |
| `/gemini analyze <file/topic>` | Deep analysis of a file or topic |
| `/gemini compare <topic>` | Compare Claude and Gemini perspectives |
| `/gemini help` | Show usage help |

All commands can also be invoked as `/gemini:<subcommand>`.

## Features

- **Model enforcement**: Always uses `gemini-3-pro-preview`, never the default
- **Auto context collection**: Gathers git state, recent files, and project info before each call
- **Smart routing**: `/gemini <anything>` routes unknown subcommands to `discuss`

## Installation

```bash
claude plugin add axect/gemini-discuss
```

## Requirements

- [Claude Code](https://claude.com/claude-code) CLI
- [gemini-mcp-tool](https://www.npmjs.com/package/gemini-mcp-tool) MCP server configured

## License

MIT
