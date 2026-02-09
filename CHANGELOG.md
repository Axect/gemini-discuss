# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [0.1.0] - 2026-02-10

### Added
- `/gemini discuss` — general discussion with project context
- `/gemini review` — code review of changes or specific files
- `/gemini brainstorm` — structured idea generation with methodology selection
- `/gemini analyze` — deep analysis of files or topics
- `/gemini compare` — Claude vs Gemini perspective comparison
- `/gemini help` — usage help
- Auto context collection via `gather-context.sh` and `recent-files.sh`
- Smart routing: unknown subcommands default to `discuss`

### Architecture
- Direct Gemini CLI calls (`gemini -m gemini-3-pro-preview`) — no MCP server dependency
- Temp file pipe pattern for large prompt handling
- XML-tagged structured prompts for consistent output formatting
