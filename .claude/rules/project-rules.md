# Rules for this project

What Claude must and must not do in a project made from this template. Project-specific context is in `CLAUDE.md`. What goes where is described in each directory's `README.md`, and the template as a whole in `.github/ABOUT.md`; read those rather than assuming a layout.

## Data access

Listing file names anywhere is fine; reading files is restricted:

- Directories named `private/`, at any depth (for example `data/private/`), hold restricted data and are not read, except their `README.md` files.
- The contents of an analysis's `inputs/` are never read.
- Files in an analysis's `outputs/` are read only when the user names them.
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
- Write scripts for the user to run. Do not run them on the project's data.
- Do not commit data, credentials or large binary files; only READMEs and small text files such as sample sheets or manifests are tracked from `data/`.
