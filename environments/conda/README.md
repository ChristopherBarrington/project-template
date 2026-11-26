# environments/conda/

Conda environments, each recorded in two files: an environment file (`<name>.yaml`) listing the packages that were asked for, and a lockfile (`<name>_linux-64.txt`) listing every package that was installed. Each environment is built inside the project, next to its files, so it is found by path rather than by name:

```
environments/conda/
├── README.md
├── <name>.yaml              packages asked for, tracked
├── <name>_linux-64.txt      packages installed, tracked
└── <name>/                  built environment, ignored
```

Every directory here is ignored by `.gitignore`; only the `.yaml` and `.txt` files and this README are tracked.

The commands below take the environment's name from a variable. Set it first:

```bash
env_name=my-environment
```

## Create

Build an environment from packages:

```bash
conda create --prefix environments/conda/${env_name} <package>
```

Add packages to it later with:

```bash
conda install --prefix environments/conda/${env_name} <package>
```

Then record the environment.

## Update

Update a package to the latest version that fits the rest of the environment, or install a specific version:

```bash
conda update --prefix environments/conda/${env_name} <package>
conda install --prefix environments/conda/${env_name} <package>=<version>
```

Then record the environment.

## Record the environment

Write the packages asked for, then the URL and checksum of every package installed:

```bash
conda env export --prefix environments/conda/${env_name} --from-history --file environments/conda/${env_name}.yaml
conda list --prefix environments/conda/${env_name} --explicit --md5 > environments/conda/${env_name}_linux-64.txt
```

Run both commands, together, after every install or update. The `.yaml` file records a version only where one was given at install (`<package>=<version>`).

> [!IMPORTANT]
> Both files record conda packages only. Packages installed with `pip` are left out without a warning, so install packages from conda-forge or bioconda rather than with `pip`. Check for `pip` packages with `conda list --prefix environments/conda/${env_name} | grep pypi`.

## Recreate

Install the exact packages from the lockfile, without solving:

```bash
conda create --prefix environments/conda/${env_name} --file environments/conda/${env_name}_linux-64.txt
```

The lockfile works only on the platform that wrote it, linux-64 on nemo.

## Rebuild with newer versions

Solve the environment again from the packages asked for, then record it:

```bash
conda env create --file environments/conda/${env_name}.yaml --prefix environments/conda/${env_name}
```

`--prefix` overrides the `name:` and `prefix:` that the export writes into the file. Use this to upgrade, or to build on another platform.

## Use

Activate it by path, or run a single command in it:

```bash
conda activate ./environments/conda/${env_name}
conda run --prefix environments/conda/${env_name} <command>
```
