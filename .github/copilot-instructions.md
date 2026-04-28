# Copilot Instructions

This file provides GitHub Copilot with persistent context about this project.

## Repository structure

| Path         | Purpose                                                            |
| :----------- | :----------------------------------------------------------------- |
| `bin/`       | Scripts and Makefiles for project initialisation *deprecated*      |
| `data/`      | Raw and processed data (not committed to version control)          |
| `envs/`      | Conda and Singularity environments and definitions                 |
| `resources/` | Software repositories (eg GitHub) and package documentation (PDFs) |
| `share/`     | Shared outputs (including GEO), e.g. HTML reports, Shiny apps      |
| `working/`   | Working directories for active analysis                            |
| `.github/`   | GitHub templates, community health files, and copilot instructions |

## Conventions

### Naming conventions

- Use `kebab-case` for file and directory names, where possible
  - break with `_` if needed, for example: a-directory_YYYY-MM-DD
- Use `snake_case` for variable names
- Use `YYYY-MM-DD` format for all dates

### Language conventions

- Use British English spelling and grammar (e.g. organise, colour, favourites) rather than American English
- Commit messages should use British English and be written in imperative present tense (e.g. "Initialise analysis pipeline", "Organise sample metadata")

## Code formatting

- Prefer using single quotes in scripts where possible, but do not enforce this if it reduces readability or consistency with existing code
- Double quotes in Markdown files are acceptable

## Markdown formatting

- Prefer GitHub Flavored Markdown (GFM) syntax and conventions, including for tables, links, and code blocks
- Tables should be formatted for viewing in plain text as well as rendered Markdown
- Use `:` notation for alignment (`: --- :` for centred, `: ---` for left, `--- :` for right)
- Have a leading and trailing space in header row delimiters
- Pad all cells (header, separator, and data rows) with trailing spaces so all pipes align vertically
- Ensure separator dashes match the width of the header cell including spaces
- Example structure where column data are 10 and 17 characters wide:
  ```
  | Column One | Column Two        |
  | :--------- | :---------------- |
  | Value one  | Some content here |
  | Value two  | More content      |
  ```

## General principles

- Keep pipeline logic and configuration clearly separated
- Document non-obvious decisions in code or workflow files
- Do not commit sensitive data, credentials, or large binary files
- Do not sugar-coat or hide important information in comments or documentation; be clear, direct and critical

**When making or planning any changes to the project structure, you must *always* read the README.md in target directories to understand and adhere to the conventions for that directory!**

## Notes

Add any project-specific notes, caveats, or context that Copilot should always be aware of here.
