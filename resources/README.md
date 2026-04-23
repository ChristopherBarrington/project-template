# resources/

Local clones of GitHub repositories (preferably kept as submodules), software source code and documentation are kept here, for example package repositories used in this project.

For Git(Hub) repositories, the directory should be structured by host, owner and repository: `github/owner/repository`. Similarly, for GitLab it would be a `gitlab` subdirectory.

Software that is distributed as a source directory should be kept in suitably-named subdirectory of `src/`.

This directory may also contain package documentation, such as PDF manuals, guides or vignettes. Documentation for packages should be kept in a suitably-named subdirectory of `docs`, for example `docs/<package name>`.

Prefer using Git submodules to track external repositories. This avoids mixing commit histories and keeps the project index clean. Only clone repositories directly if absolutely necessary - if you do, be cautious about what is committed to the project to avoid mixing package source code and analysis project code. In such cases, consider expanding the local `.gitignore` to exclude them, leaving files untracked, and deleting the `.git/` directory to avoid these files being tracked by the project.
