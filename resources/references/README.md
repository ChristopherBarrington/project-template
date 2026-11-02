# resources/references/

Published reference data used by the analyses: genome sequences, annotation (GTF/GFF), pre-built indices and similar, for example the mm10 FASTA.

Organise by source and identifier, `references/<source>/<identifier>/`. These files are not tracked, but this README and any `*.sh` scripts (for example convenience downloaders) are.

Record the source URL, version and checksum for each reference, in a README alongside it or in the download script.

A reference modified by a collaborator or for this project (for example a genome with an added gene) is not a reference resource; it is project data. Build it in `working/` and link it from `data/derived/`.
