---
description: Deep analysis of a file or topic with Gemini
argument-hint: <file_path or topic>
allowed-tools: ["Bash", "Read", "Write", "Grep", "Glob"]
---

# Gemini Analyze

Perform deep analysis of a file or topic using Gemini. You MUST follow every step below.

## Input

- Target: `$ARGUMENTS`

If `$ARGUMENTS` is empty, ask the user what they want to analyze.

## Step 1: Determine Target Type

Check if `$ARGUMENTS` is a file path or a topic:
- Use Glob to check if a file matching `$ARGUMENTS` exists
- If it's a file → File Analysis mode
- If it's not a file → Topic Analysis mode

## Step 2: Gather Context

### File Analysis Mode

1. Read the target file using the Read tool
2. Find related files:
   - Use Grep to find files that import/reference the target file
   - Use Glob to find test files related to the target
   - Use Grep to find similar patterns or related modules
3. Read the most relevant related files (up to 3)

### Topic Analysis Mode

1. Use Grep to find files related to the topic keywords
2. Read the most relevant files (up to 5)
3. Look for configuration files, tests, and documentation related to the topic

### Both Modes

Run:
```
sh "${CLAUDE_PLUGIN_ROOT}/scripts/gather-context.sh" .
```

## Step 3: Call Gemini for Analysis

Write the full prompt to `/tmp/gemini-discuss-prompt.txt` using the Write tool.

**For File Analysis:**

```
<role>
You are a senior software architect performing a deep code analysis.
Provide actionable insights, not generic observations.
</role>

<project_context>
{paste gather-context.sh output here}
</project_context>

<target_file>
Path: {filepath}
Contents:
{paste file contents here}
</target_file>

<related_files>
{paste related file contents with paths as headers}
</related_files>

<instructions>
Perform a deep analysis of the target file and its role in the project.

1. **Purpose & Responsibility**: What does this file do? Is it well-scoped?
2. **Architecture**: How does it fit into the overall project? Dependencies and dependents.
3. **Code Quality**: Complexity, readability, maintainability assessment.
4. **Potential Issues**: Bugs, edge cases, error handling gaps.
5. **Improvement Opportunities**: Refactoring suggestions, performance optimizations.
6. **Test Coverage**: Are the tests adequate? What's missing?

Provide a structured analysis report with specific line references.
</instructions>
```

**For Topic Analysis:**

```
<role>
You are a senior software architect performing a deep analysis of a technical topic within a project.
</role>

<project_context>
{paste gather-context.sh output here}
</project_context>

<topic>
{$ARGUMENTS}
</topic>

<relevant_code>
{paste relevant file contents with paths as headers}
</relevant_code>

<instructions>
Perform a deep analysis of the topic in the context of this project.

1. **Current State**: How is this topic currently handled in the project?
2. **Strengths**: What's working well?
3. **Weaknesses**: What could be improved?
4. **Risks**: Potential problems or technical debt.
5. **Recommendations**: Concrete, actionable suggestions with priority levels.
6. **Implementation Path**: If changes are needed, suggest an approach.

Provide a structured analysis report.
</instructions>
```

Then run via Bash:

```
cat /tmp/gemini-discuss-prompt.txt | gemini -m gemini-3-pro-preview && rm -f /tmp/gemini-discuss-prompt.txt
```

## Step 4: Present Analysis

Display Gemini's analysis as a structured report. Add a footer:

```
---
*Analysis by Gemini (gemini-3-pro-preview). Mode: {File|Topic} Analysis.*
```

## CRITICAL RULES

1. **ALWAYS** pass `-m gemini-3-pro-preview` to the gemini CLI. Never omit it.
2. Always include related files for comprehensive analysis — not just the target file in isolation.
3. Always write the prompt to a temp file and pipe it — never embed large prompts in shell arguments.
4. Clean up the temp file after the call.
