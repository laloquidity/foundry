#!/usr/bin/env python3
"""
Universal Section Extractor — Header-Anchored

Generalized extraction script for splitting any interview/spec document
into task-scoped section files. Adapt the SECTIONS list for your project.

Usage: python3 -u extract_sections.py

Requires: PROJECT_INTERVIEW.md in the parent directory.
Output: sections/ directory with one file per section.
"""
import os, sys, re

# === CONFIGURATION — ADAPT THESE FOR YOUR PROJECT ===

TOKEN_WARNING = 3000  # Warn if a section exceeds this token estimate

# Source document (the canonical interview)
SRC = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "PROJECT_INTERVIEW.md")

# Output directory for section files
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "sections")

# === HELPER FUNCTIONS ===

print(f"Source: {SRC}", flush=True)

if not os.path.exists(SRC):
    print(f"ERROR: Source file not found: {SRC}", file=sys.stderr)
    print("Make sure PROJECT_INTERVIEW.md exists in the project root.", file=sys.stderr)
    sys.exit(1)

with open(SRC, "r") as f:
    lines = f.readlines()
total_lines = len(lines)
print(f"Loaded: {total_lines} lines", flush=True)

os.makedirs(OUT, exist_ok=True)


def find(pattern, after=0):
    """Find the first line number (1-indexed) matching pattern, starting after a given line."""
    for i in range(after, total_lines):
        if re.search(pattern, lines[i]):
            return i + 1
    raise ValueError(f"Pattern not found: {pattern} (after line {after})")


def extract(fname, start, end, title, specs, xrefs):
    """Extract and write one section file."""
    content = "".join(lines[start-1:end])
    header = (
        f"# {title}\n\n"
        f"> **Source:** `PROJECT_INTERVIEW.md` Lines {start}–{end}\n"
        f"> **Spec IDs:** {specs}\n"
        f"> **Cross-references:** {xrefs}\n"
        f"> ⚠️ **READ-ONLY** — this file is auto-generated. Edit the interview, then re-extract.\n\n"
        f"---\n\n"
    )
    path = os.path.join(OUT, fname)
    with open(path, "w") as f:
        f.write(header + content)
    # Verify write
    with open(path, "r") as f:
        back = "".join(f.readlines()[9:])  # Skip header lines
    words = len(content.split())
    tokens = words * 4 // 3
    ok = content == back
    warn = f" ⚠️  >{TOKEN_WARNING} tokens" if tokens > TOKEN_WARNING else ""
    return ok, tokens, warn


# === SECTION DEFINITIONS ===
# Adapt these for your project. Each entry is:
#   (filename, start_line, end_line, title, spec_ids, cross_references)
#
# Use find() with regex patterns to locate headers dynamically.
# This makes the script survive content additions without line number updates.
#
# Example:
#   A["s1"] = find(r"^## 1\. Project Overview")
#   A["s2"] = find(r"^## 2\. Requirements")
#   ...
#   SECTIONS = [
#       ("01_project_overview.md", A["s1"], A["s2"]-2,
#        "Section 1: Project Overview",
#        "SPEC-001, SPEC-002",
#        "02 (requirements), 05 (architecture)"),
#   ]

A = {}  # anchor dict

# --- ADAPT BELOW: Add your document's ## headers ---
# A["s1"] = find(r"^## 1\. First Section")
# A["s2"] = find(r"^## 2\. Second Section")
# ...

# Find doc end (skip trailing blank lines)
doc_end = total_lines
while doc_end > 0 and lines[doc_end - 1].strip() == "":
    doc_end -= 1

# --- ADAPT BELOW: Define your sections ---
SECTIONS = [
    # ("01_first_section.md", A["s1"], A["s2"]-2,
    #  "Section 1: First Section Title",
    #  "SPEC-001, SPEC-002",
    #  "02 (second section), 05 (architecture)"),
]

if not SECTIONS:
    print("\n⚠️  No sections defined yet!", flush=True)
    print("Edit this script's SECTIONS list to define your extraction targets.", flush=True)
    print("See the comments above SECTIONS for examples.", flush=True)
    sys.exit(0)

# === EXTRACT ALL ===
passed = failed = warnings = 0
for i, (fname, start, end, title, specs, xrefs) in enumerate(SECTIONS, 1):
    ok, tokens, warn = extract(fname, start, end, title, specs, xrefs)
    status = "PASS" if ok else "FAIL"
    print(f"[{i:2d}/{len(SECTIONS)}] {status} {fname:<45s} ~{tokens:>5d} tokens{warn}", flush=True)
    if ok: passed += 1
    else: failed += 1
    if warn: warnings += 1

print(f"\n{'='*60}", flush=True)
print(f"RESULT: {passed}/{len(SECTIONS)} passed, {failed} failed, {warnings} warnings", flush=True)
if failed == 0: print("ALL SECTIONS EXTRACTED AND VERIFIED", flush=True)
if warnings: print(f"NOTE: {warnings} section(s) exceed {TOKEN_WARNING} token threshold", flush=True)
print("DONE", flush=True)
