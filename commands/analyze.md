---
description: Deep analysis of a file or topic with Gemini
argument-hint: <file_path or topic>
allowed-tools: ["Bash", "Read", "Grep", "Glob"]
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

Call `mcp__gemini-cli__ask-gemini` with:
- **model**: `"gemini-3-pro-preview"` (MANDATORY - never omit this parameter)
- **prompt**: Structure the analysis request:

**For File Analysis:**
```
Perform a deep analysis of the following file and its role in the project.

Project context:
{context from gather-context.sh}

Target file: {filepath}
Related files that reference it: {list}
Test files: {list}

@{target_filepath}
@{related_file_1}
@{related_file_2}

Please analyze:
1. **Purpose & Responsibility**: What does this file do? Is it well-scoped?
2. **Architecture**: How does it fit into the overall project? Dependencies and dependents.
3. **Code Quality**: Complexity, readability, maintainability assessment.
4. **Potential Issues**: Bugs, edge cases, error handling gaps.
5. **Improvement Opportunities**: Refactoring suggestions, performance optimizations.
6. **Test Coverage**: Are the tests adequate? What's missing?

Provide a structured analysis report.
```

**For Topic Analysis:**
```
Perform a deep analysis of the following topic in the context of this project.

Project context:
{context from gather-context.sh}

Topic: {$ARGUMENTS}

Relevant files found:
@{file1}
@{file2}
...

Please analyze:
1. **Current State**: How is this topic currently handled in the project?
2. **Strengths**: What's working well?
3. **Weaknesses**: What could be improved?
4. **Risks**: Potential problems or technical debt.
5. **Recommendations**: Concrete, actionable suggestions with priority levels.
6. **Implementation Path**: If changes are needed, suggest an approach.

Provide a structured analysis report.
```

## Step 4: Present Analysis

Display Gemini's analysis as a structured report. Add a footer:

```
---
*Analysis by Gemini (gemini-3-pro-preview). Mode: {File|Topic} Analysis.*
```

## CRITICAL RULES

1. **ALWAYS** pass `model: "gemini-3-pro-preview"` to `mcp__gemini-cli__ask-gemini`. Never omit it.
2. Do NOT use `gemini-2.5-pro` or any other model.
3. Always include related files for comprehensive analysis — not just the target file in isolation.
4. Use `@filepath` syntax to include file contents for Gemini to read.
