# Copilot Instructions

This file provides GitHub Copilot with persistent context about this project. This repository is a bioinformatics project that contains raw data, analysis and results. It should be as self-contained as possible and enable easy reproducibility of results by other users. The repository structure and conventions are described below.

## Repository structure

| Path         | Purpose                                                                          |
| :----------- | :------------------------------------------------------------------------------- |
| `bin/`       | Optional executables and scripts for the whole project (launchers, reused tools) |
| `data/`      | Input data, not committed to version control (only READMEs are tracked)          |
| `docs/`      | Project and biological documentation (papers, collaborator material)             |
| `envs/`      | Conda and container (Apptainer/Singularity) environment definitions              |
| `resources/` | Computational reference material: repositories, software, published references   |
| `scratch/`   | Untracked dumping ground; ignored at any depth                                   |
| `share/`     | Links to results in `working/`, organised for sharing (including GEO)            |
| `working/`   | Where analyses are run and all results are stored                                |
| `.github/`   | GitHub templates, community health files and Copilot instructions                |

Further conventions:

- `data/` holds collaborator, Crick and public (`external/`) data and links to analysis products (`derived/`). Published references (for example mm10) belong in `resources/references/`.
- `share/` contains no output files, only links to results in `working/`. Results are never stored outside `working/`.
- Analyses in `working/` are structured hierarchically (for example `working/<topic>/<tool>`), with `inputs/`, `outputs/`, `logs/` and `renv/` ignored by git.
- `README.md` files are tracked everywhere, including in otherwise-ignored directories.
- `.git-public/` is an ignored second git directory used to publish code with a separate history.

## Data access

Listing file names anywhere is fine; reading files is restricted:

- `data/` holds primary data and is not read, except its `README.md` files.
- The contents of an analysis's `inputs/` are never read.
- Files in an analysis's `outputs/` are read only when the user names them.
- Large data formats are never read, wherever they are: reads and alignments (FASTQ, SAM, BAM, CRAM and their indexes, FAST5, POD5, BCL), sequences (FASTA), variants (VCF, BCF), tracks and contacts (bigWig, bigBed, Hi-C, cool), matrices and objects (MTX, HDF5, h5ad, Seurat, loom, RDS, RData, qs, Feather, Parquet, Arrow, NumPy, pickle, Zarr) and images (TIFF, CZI, ND2, LIF, IMS).
- Paths starting with `_` are inactive and are ignored.

## Conventions

### Naming conventions

- Use `kebab-case` for file and directory names, where possible
  - break with `_` if needed, for example: a-directory_YYYY-MM-DD
- Use `snake_case` for variable names
- Use `YYYY-MM-DD` format for all dates

### Language conventions

- Use British English spelling and grammar (e.g. organise, colour, favourites) rather than American English
- Commit messages should use British English and be written in imperative present tense (e.g. "Initialise analysis pipeline", "Organise sample metadata")

### Code formatting

- Prefer using single quotes in scripts where possible, but do not enforce this if it reduces readability or consistency with existing code
- Double quotes in Markdown files are acceptable

### Markdown formatting

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

### General principles

- Keep pipeline logic and configuration clearly separated
- Document non-obvious decisions in code or workflow files
- Do not commit sensitive data, credentials, or large binary files
