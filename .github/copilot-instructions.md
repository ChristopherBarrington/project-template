# Copilot Instructions

<!-- This file provides GitHub Copilot with persistent context about this project. -->
<!-- Docs: https://docs.github.com/en/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot -->

This file provides GitHub Copilot with persistent context about this project.

## Project overview

This is a BABS-STP bioinformatics project. Add a brief description of the project's purpose and scope here.

## Repository structure

| Path         | Purpose                                                        |
| :----------- | :------------------------------------------------------------- |
| `bin/`       | Scripts and Makefiles for project initialisation               |
| `data/`      | Raw and processed data (not committed to version control)      |
| `docs/`      | Project documentation                                          |
| `envs/`      | Conda and Singularity environment definitions                  |
| `resources/` | Clones of GitHub repositories and package documentation (PDFs) |
| `share/`     | Shared outputs (including GEO), e.g. HTML reports, Shiny apps  |
| `working/`   | Working directories for active analysis                        |
| `.github/`   | GitHub templates and community health files                    |
| `.copilot/`  | Copilot configuration: instructions and customizations         |

## Conventions

- Use kebab-case for file and directory names
- Use snake_case for variable names
- Markdown tables should:
  - be formatted for viewing in plain text as well as rendered Markdown
  - use `:` notation
  - have a leading and trailing space in header row delimiters
- Keep pipeline logic and configuration clearly separated
- Document non-obvious decisions in code or workflow files
- Do not commit sensitive data, credentials, or large binary files

## Key commands

```bash
# Add commonly used commands here, e.g.:
# conda activate <env>
# snakemake --cores 4
```

## Notes

Add any project-specific notes, caveats, or context that Copilot should always be aware of here.
