#!/bin/sh
# gather-context.sh - Collect git and project context for Gemini discussions
# Usage: sh gather-context.sh [project_root]

PROJECT_ROOT="${1:-.}"
cd "$PROJECT_ROOT" 2>/dev/null || exit 1

echo "=== Project Context ==="

# Project type detection
if [ -f "package.json" ]; then
    echo "Type: Node.js"
    echo "Name: $(grep -m1 '"name"' package.json | sed 's/.*: *"\(.*\)".*/\1/')"
elif [ -f "pyproject.toml" ]; then
    echo "Type: Python (pyproject.toml)"
    echo "Name: $(grep -m1 'name' pyproject.toml | sed 's/.*= *"\(.*\)".*/\1/')"
elif [ -f "Cargo.toml" ]; then
    echo "Type: Rust"
    echo "Name: $(grep -m1 'name' Cargo.toml | sed 's/.*= *"\(.*\)".*/\1/')"
elif [ -f "go.mod" ]; then
    echo "Type: Go"
    echo "Module: $(head -1 go.mod | awk '{print $2}')"
elif [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
    echo "Type: Java/Kotlin (Gradle)"
elif [ -f "pom.xml" ]; then
    echo "Type: Java (Maven)"
else
    echo "Type: Unknown"
fi

# Git context
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo ""
    echo "=== Git Context ==="
    echo "Branch: $(git branch --show-current 2>/dev/null)"
    echo "Status: $(git status --short 2>/dev/null | wc -l | tr -d ' ') changed files"
    echo ""
    echo "--- Recent Commits (last 5) ---"
    git log --oneline -5 2>/dev/null
    echo ""
    echo "--- Staged Changes Summary ---"
    git diff --cached --stat 2>/dev/null || echo "(no staged changes)"
    echo ""
    echo "--- Unstaged Changes Summary ---"
    git diff --stat 2>/dev/null || echo "(no unstaged changes)"
else
    echo ""
    echo "(Not a git repository)"
fi

# Directory structure (top-level only)
echo ""
echo "=== Top-Level Structure ==="
ls -1 "$PROJECT_ROOT" 2>/dev/null | head -20
