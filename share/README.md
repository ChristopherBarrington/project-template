# share/

Contains no output files. Results are produced and kept in `working/`; this directory organises them for collaborators using symlinks, arranged by what the collaborator wants to see rather than by how it was produced. Make links relative so that they survive the project being moved.

Where the collaborator reads from a shared location on Nemo, `share/` can instead link to that location, so the contents are not assumed to always be links.

The `geo/` directory is a staging area for data to be uploaded to GEO. Links must be dereferenced on upload (for example `rsync --copy-links`).

Everything in `share/` is ignored by git except READMEs.
