---
paths:
  - '**/*.bash'
  - '**/*.sbatch'
  - '**/*.sh'
  - '**/*.srun'
---

# Bash deliverable scripts

Applies to deliverable scripts only, in addition to the user-level Bash style rules (`~/.claude/rules/bash.md`).

Before writing a deliverable script, read the matching template in the compendium, then write the script from it, keeping its structure and boilerplate. The template takes precedence over this file. Look first at `resources/github/christopherbarrington/compendium/templates/` (ignoring case). Only if that is missing, search for a `compendium/templates` directory at most five levels below `resources/`, without descending further. If none is found, tell the user and continue with the user-level Bash style rules rather than writing the structure from memory. State which template was used.

- Environment variables are UPPER_CASE and are copied into lower_snake_case locals with `${VAR:-default}`, or `${VAR:?message}` when required. Positional arguments are copied into named locals in the same way.
- Introduce any section you add with a `## ---- section-name` marker (lowercase, hyphenated).
