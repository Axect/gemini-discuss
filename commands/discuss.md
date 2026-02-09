---
description: Discuss a topic with Gemini using current project context
argument-hint: <topic>
allowed-tools: ["Bash", "Read", "Grep", "Glob"]
---

# Gemini Discuss

Have a contextual discussion with Gemini about the given topic. You MUST follow every step below.

## Input

- Topic: `$ARGUMENTS`

If `$ARGUMENTS` is empty, ask the user what they want to discuss with Gemini.

## Step 1: Gather Project Context

Run the context gathering scripts using Bash:

```
sh "${CLAUDE_PLUGIN_ROOT}/scripts/gather-context.sh" .
```

```
sh "${CLAUDE_PLUGIN_ROOT}/scripts/recent-files.sh" . 30
```

Capture both outputs — these provide git state, project type, and recent activity.

## Step 2: Find Relevant Files

Based on the topic (`$ARGUMENTS`), use Grep and Glob to find files related to the discussion:
- Search for keywords from the topic in the codebase
- Read the most relevant files (up to 3-5 files) to provide concrete context
- Use `@filename` syntax in the prompt to include file contents when calling ask-gemini

## Step 3: Call Gemini

Call `mcp__gemini-cli__ask-gemini` with:
- **model**: `"gemini-3-pro-preview"` (MANDATORY - never omit this parameter)
- **prompt**: Combine the following into a clear prompt:
  1. Project context from Step 1
  2. Recently modified files list
  3. The user's topic: `$ARGUMENTS`
  4. Reference relevant files with `@filepath` syntax
  5. Ask Gemini to provide its perspective, suggestions, or analysis on the topic

Example prompt structure:
```
Given this project context:
{context from gather-context.sh}

Recently modified files:
{output from recent-files.sh}

Topic for discussion: {$ARGUMENTS}

Please provide your perspective and suggestions on this topic. Consider the current state of the project and any relevant patterns or best practices.
```

## Step 4: Present Response

Display Gemini's response to the user. Add a brief note at the end:

```
---
*Gemini (gemini-3-pro-preview) response based on current project context.*
```

## CRITICAL RULES

1. **ALWAYS** pass `model: "gemini-3-pro-preview"` to `mcp__gemini-cli__ask-gemini`. Never omit it.
2. Do NOT use `gemini-2.5-pro` or any other model.
3. Always gather context before calling Gemini.
4. Include relevant file contents via `@filepath` syntax for concrete discussions.
