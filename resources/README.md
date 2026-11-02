# resources/

Computational reference material: things the analysis _uses_ rather than _analyses_. Biological context belongs in `docs/`.

| Path                        | Contents                                                        |
| :-------------------------- | :-------------------------------------------------------------- |
| `github/<owner>/<repo>/`    | Git repositories, preferably as submodules (likewise `gitlab/`) |
| `src/<software>/`           | Software distributed as a source directory                      |
| `docs/<software>/`          | Software documentation: manuals, guides, vignettes              |
| `references/<source>/<id>/` | Published reference data: genome FASTA, GTF, annotation         |

If it exists without this project, it belongs here. If it exists because of this project (for example a genome with a gene added by a collaborator), it is data: see `data/`.

For Git(Hub) repositories, the directory should be structured by host, owner and repository: `github/owner/repository`. Similarly, for GitLab it would be a `gitlab` subdirectory.

Software that is distributed as a source directory should be kept in suitably-named subdirectory of `src/`.

Documentation for packages, such as PDF manuals, guides or vignettes, should be kept in a suitably-named subdirectory of `docs/`, for example `docs/<package name>`.

Published reference data is kept in `references/`. These files are not tracked, but the README and `*.sh` scripts (for example convenience downloaders) are. See `references/README.md`.

Prefer using Git submodules to track external repositories. This avoids mixing commit histories and keeps the project index clean. Only clone repositories directly if absolutely necessary - if you do, be cautious about what is committed to the project to avoid mixing package source code and analysis project code. In such cases, consider expanding the local `.gitignore` to exclude them, leaving files untracked, and deleting the `.git/` directory to avoid these files being tracked by the project.
