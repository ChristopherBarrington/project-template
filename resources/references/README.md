# resources/references/

Published reference data used by the analyses: genome sequences, annotation (GTF/GFF), pre-built indices and similar, for example the mm10 FASTA.

Organise by source and identifier, `references/<source>/<identifier>/`. These files are not tracked, but this README and any `*.sh` scripts (for example convenience downloaders) are.

Record the source URL, version and checksum for each reference, in a README alongside it or in the download script.

A custom genome, including one from a collaborator, is not a reference resource; it is data and belongs in `data/`. Build anything derived from it, such as an index, in `working/` and link it into the `inputs/` of the analyses that use it.
