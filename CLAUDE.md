<!--
Note for the editor; Claude Code removes this comment before Claude reads the file.

Write here what Claude cannot find out for itself: the project's aim, the collaborators and any terms they set, where the main analyses are and the decisions taken along the way. Keep the file under 200 lines.

Do not write here:
- rules that must be enforced: they belong in .claude/settings.json, which Claude cannot override;
- personal preferences: they belong in ~/.claude/CLAUDE.md, or in a git-ignored CLAUDE.local.md beside this file.

An analysis can add its own CLAUDE.md in working/<analysis>/, which Claude reads when it first works with a file there.
-->

# This project

## Aim

<!-- What the project is trying to find out. -->

## Collaborators

<!-- Who the project is for, and any terms they set on the data or results. -->

## Data

<!-- What is in data/ and where it came from. -->

## Main analyses

<!-- Where the main analyses are in working/ and what each one does. -->

# Conventions and data access

@.github/copilot-instructions.md

# Claude only

- Start at the project root, and `cd` to an analysis from there rather than starting Claude in it.
- Reads are denied deliberately by `.claude/settings.json`. If a read is denied, stop and tell the user; do not work round it.
- Write scripts for the user to run. Do not run them on the project's data.
- List `private/`, `inputs/` and `outputs/` directories freely to learn file names, but read files in `outputs/` only when the user names them.
- Do not read files with no extension in `private/` directories or `inputs/`.
- How the settings work, and their known gaps, are described in the "Claude Code" section of `.github/ABOUT.md`.
