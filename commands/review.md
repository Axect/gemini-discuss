---
description: Get a Gemini code review of changes or a specific file
argument-hint: "[file_path]"
allowed-tools: ["Bash", "Read", "Grep", "Glob"]
---

# Gemini Code Review

Get Gemini's code review on recent changes or a specific file. You MUST follow every step below.

## Input

- Target: `$ARGUMENTS` (optional file path; if empty, review git diff)

## Step 1: Collect Code to Review

**If `$ARGUMENTS` contains a file path:**
- Read the specified file using the Read tool
- Also check for related test files using Glob (e.g., `**/test_*`, `**/*_test.*`, `**/*.test.*`)

**If `$ARGUMENTS` is empty:**
- Run `git diff` via Bash to get unstaged changes
- Run `git diff --cached` via Bash to get staged changes
- If both are empty, run `git diff HEAD~1` to review the last commit

## Step 2: Gather Project Context

Run:
```
sh "${CLAUDE_PLUGIN_ROOT}/scripts/gather-context.sh" .
```

Also check if there's a CLAUDE.md or similar project conventions file:
- Read `.claude/CLAUDE.md` or `CLAUDE.md` if it exists (for coding conventions)

## Step 3: Call Gemini for Review

Call `mcp__gemini-cli__ask-gemini` with:
- **model**: `"gemini-3-pro-preview"` (MANDATORY - never omit this parameter)
- **prompt**: Structure the review request as follows:

```
You are reviewing code changes. Please provide a thorough code review.

Project context:
{context from gather-context.sh}

Project conventions (if found):
{conventions from CLAUDE.md}

Code to review:
{diff or file contents}

Please review for:
1. **Bugs & Logic Errors**: Identify potential bugs, edge cases, or logic issues
2. **Security**: Flag any security concerns (injection, XSS, sensitive data exposure, etc.)
3. **Performance**: Note any performance concerns or optimization opportunities
4. **Code Quality**: Assess readability, naming, structure, and adherence to conventions
5. **Best Practices**: Suggest improvements based on language/framework best practices

Format your review with severity levels:
- 🔴 Critical: Must fix before merge
- 🟡 Warning: Should fix, potential issues
- 🟢 Suggestion: Nice-to-have improvements
- ℹ️ Note: Informational observations

@{filepath if reviewing a specific file}
```

## Step 4: Present Review Results

Display Gemini's review, organized by severity. Add a footer:

```
---
*Code review by Gemini (gemini-3-pro-preview). Review the suggestions and apply as needed.*
```

## CRITICAL RULES

1. **ALWAYS** pass `model: "gemini-3-pro-preview"` to `mcp__gemini-cli__ask-gemini`. Never omit it.
2. Do NOT use `gemini-2.5-pro` or any other model.
3. Always include project conventions in the review context when available.
4. Use `@filepath` syntax to include file contents for specific file reviews.
