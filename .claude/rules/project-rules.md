# Rules for this project

What Claude must and must not do in a project made from this template. Project-specific context is in `CLAUDE.md`. What goes where is described in each directory's `README.md`, and the template as a whole in `.github/ABOUT.md`; read those rather than assuming a layout.

## Data access

Listing file names anywhere is fine; reading files is restricted:

- Directories named `private/`, at any depth (for example `data/private/`), hold restricted data and are not read, except their `README.md` files.
- The contents of an analysis's `inputs/` are never read.
- Files in an analysis's `outputs/` are read only when the user names them or approves the read.
- Large data formats are not read outside `data/synthetic/`: reads and alignments (FASTQ, SAM, BAM, CRAM and their indexes, FAST5, POD5, BCL), sequences (FASTA), variants (VCF, BCF), tracks and contacts (bigWig, bigBed, Hi-C, cool), matrices and objects (MTX, HDF5, h5ad, Seurat, loom, RDS, RData, qs, Feather, Parquet, Arrow, NumPy, pickle, Zarr) and images (TIFF, CZI, ND2, LIF, IMS).
- Files with no extension in `inputs/` are not read.
- Paths starting with `_` are inactive and are ignored.

Reads are denied deliberately by `.claude/settings.json`. If a read is denied, stop and tell the user; do not work round it. How the settings work, and their known gaps, are described in the "Claude Code" section of `.github/ABOUT.md`.

## Where things go

- Analyses are run, and all their results kept, in `working/`. Results are never stored anywhere else; `share/` and other analyses' `inputs/` hold only links to them.
- Published references (for example Ensembl genome FASTA and GTF) go in `resources/references/`. A custom genome, including one from a collaborator, is data and goes in `data/`.
- Restricted data goes in a `private/` directory. To write or test code against it, use the stand-in with the same structure in `data/synthetic/`.

## Working in the project

- Start at the project root, and `cd` to an analysis from there rather than starting Claude in it.
- Write scripts for the user to run. Run a script on the project's data, or submit it to the cluster, only when the user approves that run. Approval for one run does not cover the next.
- Do not commit data, credentials or large binary files; only READMEs and small text files such as sample sheets or manifests are tracked from `data/`.

## Branches and worktrees

- The main checkout stays on `main` and is never switched to another branch.
- Analyses run from the main checkout, some for days. Switching branches removes the tracked scripts of any analysis that is not on the new branch, so a running job can lose its scripts and its outputs are left beside a directory with no code. Bash reads a script as it runs, so a change to the `run.sh` of a running analysis can also alter the job.
- Make every change, including a plan, in a worktree on a `<topic>@claude` branch. A worktree is a second working tree of the same repository, checked out on its own branch.
- Worktrees live in `.worktrees/<topic>/` at the project root, which git ignores. Create one from the project root with `git worktree add -b <topic>@claude .worktrees/<topic> main`.
- The user merges the branch in the main checkout. Never merge a change into the directory of an analysis that is running.
- Remove a worktree with `git worktree remove .worktrees/<topic>` only after its branch is merged. Its untracked files, including test outputs, are deleted with it.
- Start a real run (a run on the project's data, not a test) only from the main checkout, never from a worktree. A worktree's untracked outputs are lost when the worktree is removed.
- A worktree holds only tracked files. Code run in a worktree reads data, software and scratch from the main checkout by absolute path.
- Run records may be committed on `main` in the main checkout. A run record is the parameters file that a real run writes in its analysis directory, by convention `etc/parameters.tsv`. Commit nothing else on `main`.
- `git switch`, `git checkout` and `git merge` ask for approval in `.claude/settings.json`.
