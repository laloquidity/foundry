---
description: Resume an in-progress Foundry session from where it left off
---

# /foundry-resume — Resume Foundry Session

Resume an existing Foundry session. This is a convenience alias for `/foundry-start` — both commands auto-detect whether a session is in progress and handle it the same way.

## Steps

1. **Check for existing checkpoint:**
   ```
   Check if .foundry/checkpoint.md exists in the workspace root.
   ```

2. **If checkpoint exists:**
   - Follow the `/foundry-start` resume path (Step 0.5: Workspace Drift Scan, then resume from checkpoint)
   - See `.agents/workflows/foundry-start.md` for full details

3. **If checkpoint does NOT exist:**
   - Report to the user:
     ```
     No Foundry session found in this workspace. Run /foundry-start to begin a new project.
     ```
   - Ask: "Would you like to start a new Foundry session now? (y/n)"
   - If yes → delegate to `/foundry-start` fresh start path

## When to Use This

- You stepped away from a Foundry session and want to pick up where you left off
- You're returning to a project after doing other work (competitive analysis, investor prep, research) and want Foundry to catch up on what changed
- You want to check the current state of a Foundry session without necessarily continuing

## Important

- **This is the same as `/foundry-start`** when a session is already in progress. Both commands detect state automatically.
- **The workspace drift scan runs automatically** on resume. It will find any new or modified files and ask if they should be ingested into Foundry's artifacts.
- **If you want to start completely fresh** (discard the current session), delete `.foundry/checkpoint.md` first, then run `/foundry-start`.
