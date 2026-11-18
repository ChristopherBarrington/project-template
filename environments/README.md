# environments/

Optional. Package environments that a package manager resolves from a recipe or lockfile, kept in a subdirectory per manager:

| Path     | Contents                                                                    |
| :------- | :-------------------------------------------------------------------------- |
| `conda/` | Conda environment files (`*.yaml`), and the environments built from them    |
| `renv/`  | `renv.lock` for R, and the `.Rprofile` and `renv/` that renv writes from it |
| `uv/`    | `pyproject.toml`, `uv.lock` and `.python-version` for Python                |

Only recipes, lockfiles and their configuration are tracked; built environments and package libraries are ignored.

Containers, launchers and binaries belong in `software/`.

Each subdirectory's `README.md` gives the commands to create its environments, write their lockfiles and recreate them from the lockfiles.

An analysis in `working/` uses a shared environment from its own directory. renv activates from the directory R starts in, so link its `.Rprofile` and `renv/` into the analysis:

```bash
cd working/<topic>/<tool>
ln --symbolic --relative ../../../environments/renv/.Rprofile .Rprofile
ln --symbolic --relative ../../../environments/renv/renv renv
```

conda and uv are found by path instead: `conda activate ../../../environments/conda/<name>` or `uv run --project ../../../environments/uv <command>`.
