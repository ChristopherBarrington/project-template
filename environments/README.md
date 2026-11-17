# environments/

Optional. Package environments that a package manager resolves from a recipe or lockfile, kept in a subdirectory per manager:

| Path     | Contents                                                                    |
| :------- | :-------------------------------------------------------------------------- |
| `conda/` | Conda environment files (`*.yaml`), and the environments built from them    |
| `renv/`  | `renv.lock` and the `renv/` directory (`activate.R`, `settings.json`) for R |
| `uv/`    | `pyproject.toml`, `uv.lock` and `.python-version` for Python                |

Only recipes, lockfiles and their configuration are tracked; built environments and package libraries are ignored.

Containers, launchers and binaries belong in `software/`.

renv and uv expect their files in the directory they are run from. An analysis in `working/` uses a shared environment by symlinking to it, for example:

```bash
cd working/<topic>/<tool>
ln --symbolic --relative ../../../environments/renv/renv.lock renv.lock
ln --symbolic --relative ../../../environments/renv/renv renv
```
