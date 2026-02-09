---
description: Get a Gemini code review of changes or a specific file
argument-hint: "[file_path]"
allowed-tools: ["Bash", "Read", "Write", "Grep", "Glob"]
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

Write the full prompt to `/tmp/gemini-discuss-prompt.txt` using the Write tool:

```
<role>
You are a Senior Principal Engineer conducting a thorough code review.
Your tone is objective, critical yet constructive.
</role>

<project_context>
{paste gather-context.sh output here}
</project_context>

<coding_standards>
{paste conventions from CLAUDE.md if found, otherwise "Follow standard idioms for this language."}
</coding_standards>

<code_to_review>
{paste the diff or file contents here}
</code_to_review>

<instructions>
Review the code above. Focus on:
1. **Correctness**: Bugs, race conditions, edge cases, logic errors
2. **Security**: Injection flaws, auth issues, sensitive data exposure
3. **Performance**: Algorithmic complexity, memory leaks, unnecessary allocations
4. **Code Quality**: Readability, naming, structure, adherence to project conventions
5. **Best Practices**: Language/framework idioms and patterns

Format your review with severity levels:
- 🔴 Critical: Must fix before merge
- 🟡 Warning: Should fix, potential issues
- 🟢 Suggestion: Nice-to-have improvements
- ℹ️ Note: Informational observations

For each finding, provide the specific code location and a corrected code snippet when applicable.
End with a brief overall assessment.
</instructions>
```

Then run via Bash:

```
cat /tmp/gemini-discuss-prompt.txt | gemini -m gemini-3-pro-preview && rm -f /tmp/gemini-discuss-prompt.txt
```

## Step 4: Present Review Results

Display Gemini's review, organized by severity. Add a footer:

```
---
*Code review by Gemini (gemini-3-pro-preview). Review the suggestions and apply as needed.*
```

## CRITICAL RULES

1. **ALWAYS** pass `-m gemini-3-pro-preview` to the gemini CLI. Never omit it.
2. Always include project conventions in the review context when available.
3. Always write the prompt to a temp file and pipe it — never embed large prompts in shell arguments.
4. Clean up the temp file after the call.
