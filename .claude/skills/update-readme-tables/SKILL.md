---
name: update-readme-tables
description: Refresh the Data and Analyses tables in the project README.md from the summary in the frontmatter of READMEs in data/ and working/. Use when asked to update, refresh or fill the README tables, or after adding or renaming an analysis or a data directory.
---

# Update the README tables

The tables in the project `README.md` sit between `<!-- BEGIN data-table -->` and `<!-- END data-table -->`, and between `<!-- BEGIN analyses-table -->` and `<!-- END analyses-table -->`. `.claude/skills/update-readme-tables/scripts/update-readme-tables.sh` is the only thing that writes between them. Never edit between the markers by hand.

A `README.md` under `data/` or `working/` is listed when its frontmatter has a one-line `summary:`. The summary is the user's choice of what to list: do not add one to a README on your own judgement. Directories named `inputs`, `outputs`, `logs`, `renv` or `scratch`, and any starting with `_`, are skipped and not searched recursively.

## Steps

1. Only when the user names READMEs to list, or asks for candidates: find `README.md` files under `data/` and `working/` with no `summary:` in their frontmatter, ignoring the skipped directories above, and show the list without changing anything. For each README the user confirms, add frontmatter with a one-sentence `summary:` written from the README's own text. Do not overwrite an existing summary unless asked.
2. Run the script from the project root: `bash .claude/skills/update-readme-tables/scripts/update-readme-tables.sh`. Use `DRY_RUN=true` first to preview the tables without changing the README. If it reports a missing, repeated or misordered marker, tell the user which one and stop; it has not changed the README.
3. Show `git diff README.md` and say which rows were added or changed.

## Limits

- Read only README files. Never read data files to write a summary.
- A summary is one line of plain text; the script reads no further than that line.
- Writing or refreshing the project's opening summary from `docs/` is a separate task: do it only when asked, and show the draft first.
