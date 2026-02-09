---
description: Discuss a topic with Gemini using current project context
argument-hint: <topic>
allowed-tools: ["Bash", "Read", "Write", "Grep", "Glob"]
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

## Step 3: Call Gemini via CLI

Write the full prompt to `/tmp/gemini-discuss-prompt.txt` using the Write tool. The prompt should combine:

```
<context>
{paste gather-context.sh output here}
</context>

<recent_files>
{paste recent-files.sh output here}
</recent_files>

<relevant_code>
{paste contents of relevant files found in Step 2, with file paths as headers}
</relevant_code>

<topic>
{$ARGUMENTS}
</topic>

<instructions>
Based on the project context and relevant code above, provide your perspective and suggestions on the topic.
Consider the current state of the project, recent activity, and any relevant patterns or best practices.
Be specific and reference the actual code and files when making suggestions.
</instructions>
```

Then run via Bash:

```
cat /tmp/gemini-discuss-prompt.txt | gemini -m gemini-3-pro-preview && rm -f /tmp/gemini-discuss-prompt.txt
```

## Step 4: Present Response

Display Gemini's response to the user. Add a brief note at the end:

```
---
*Gemini (gemini-3-pro-preview) response based on current project context.*
```

## CRITICAL RULES

1. **ALWAYS** pass `-m gemini-3-pro-preview` to the gemini CLI. Never omit it.
2. Always gather context BEFORE calling Gemini.
3. Always write the prompt to a temp file and pipe it — never embed large prompts in shell arguments.
4. Clean up the temp file after the call.
