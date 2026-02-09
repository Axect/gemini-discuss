---
description: Compare Claude and Gemini perspectives on a topic
argument-hint: <topic>
allowed-tools: ["Bash", "Read", "Write", "Grep", "Glob"]
---

# Gemini vs Claude Compare

Get both Gemini and Claude perspectives on a topic, then synthesize the comparison. You MUST follow every step below.

## Input

- Topic: `$ARGUMENTS`

If `$ARGUMENTS` is empty, ask the user what they want to compare perspectives on.

## Step 1: Gather Context

Run:
```
sh "${CLAUDE_PLUGIN_ROOT}/scripts/gather-context.sh" .
```

Use Grep and Glob to find files relevant to the topic. Read the most relevant ones (up to 3-5 files).

## Step 2: Get Gemini's Perspective

Write the full prompt to `/tmp/gemini-discuss-prompt.txt` using the Write tool:

```
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
Provide your detailed perspective on this topic. Include:
1. Your assessment and position
2. Key considerations and trade-offs
3. Recommended approach with rationale
4. Potential risks or concerns
5. Specific suggestions for implementation (if applicable)

Be direct and opinionated — I want to compare your view with another AI's perspective.
</instructions>
```

Then run via Bash:

```
cat /tmp/gemini-discuss-prompt.txt | gemini -m gemini-3-pro-preview && rm -f /tmp/gemini-discuss-prompt.txt
```

## Step 3: Formulate Claude's Perspective

Now, provide YOUR OWN (Claude's) perspective on the same topic based on:
- The project context you gathered
- The relevant files you read
- Your own reasoning and knowledge

Structure it the same way:
1. Assessment and position
2. Key considerations and trade-offs
3. Recommended approach with rationale
4. Potential risks or concerns
5. Specific suggestions

## Step 4: Present Comparison

Display the results in a clear comparison format:

```
## 🔵 Gemini's Perspective (gemini-3-pro-preview)

{Gemini's response}

## 🟣 Claude's Perspective

{Your own perspective}

## ⚖️ Synthesis

### Points of Agreement
{Where both perspectives align}

### Points of Divergence
{Where perspectives differ and why}

### Combined Recommendation
{Best approach considering both perspectives}

---
*Dual-perspective analysis: Gemini (gemini-3-pro-preview) + Claude. Use combined insights for a more robust decision.*
```

## CRITICAL RULES

1. **ALWAYS** pass `-m gemini-3-pro-preview` to the gemini CLI. Never omit it.
2. Be genuinely opinionated in Claude's perspective — don't just echo Gemini.
3. The synthesis should add value beyond either individual perspective.
4. Highlight disagreements honestly — that's the whole point of comparing.
5. Always write the prompt to a temp file and pipe it — never embed large prompts in shell arguments.
6. Clean up the temp file after the call.
