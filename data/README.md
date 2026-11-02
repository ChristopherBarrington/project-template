# data/

All input data for the project is stored here. This includes raw data, sample sheets, and any external data used in analyses. Scientist-provided data, such as cell type classifications (etc) are kept here.

Files or directories in this directory will be symlinked from the working analyses where appropriate.

| Path            | Contents                                                                                       |
| :-------------- | :--------------------------------------------------------------------------------------------- |
| `primary_data/` | Symlink to the Genomics STP per-project output                                                 |
| `inputs/`       | Symlink to BABS' inputs for the project                                                        |
| `external/`     | Public data downloaded for the analysis, provided by neither the Crick nor the collaborator    |
| `derived/`      | Links to products of `working/` analyses, for example the index of a custom genome             |

Published reference data (for example genome FASTA and annotation) is not kept here; it belongs in `resources/references/`. Data that has been modified by a collaborator or for this project (for example a genome with an added gene) is data and is kept here; the analysis that combines it with the reference is run in `working/`.

The contents of `data/` are not tracked by git because the files are large; only READMEs are. Use `git add --force` for anything else that should be tracked, for example a setup script.

## Sample sheet

The canonical sample sheet (for example `data/samples.csv`) lives here. Analyses link to it through their `inputs/` rather than keeping their own copies, so there is a single source of truth. It is small, so it is a good candidate for `git add --force`.

## Provenance

Record where each set of files came from: the source (for example the Genomics STP project ID, the collaborator or an accession), the date received or downloaded, and a checksum manifest (for example `md5sum` or `sha256sum` output kept alongside the files, as `checksums.md5`). Checksums let transfers be verified and show if a file changes later. Keep this in a README or manifest in the same directory; use `git add --force` to track a manifest.
