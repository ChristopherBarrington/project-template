# environments/conda/

Conda environment files (`<name>.yaml`), and the environments built from them. Each environment is built inside the project, next to its file, so it is found by path rather than by name:

```
environments/conda/
├── README.md
├── samtools.yaml      environment file, tracked
└── samtools/          built environment, ignored
```

Every directory here is ignored by `.gitignore`; only the `.yaml` files and this README are tracked.

## Create

Build an environment from packages:

```bash
conda create --prefix environments/conda/samtools samtools
```

Add packages to it later with:

```bash
conda install --prefix environments/conda/samtools bcftools
```

## Update

Update a package to the latest version that fits the rest of the environment, or install a specific version:

```bash
conda update --prefix environments/conda/samtools samtools
conda install --prefix environments/conda/samtools samtools=1.21
```

Then write the lockfile again.

## Write the lockfile

Export an environment, recording the exact version and build of every package:

```bash
conda env export --prefix environments/conda/samtools --file environments/conda/samtools.yaml
```

Run this again after installing or updating packages in the environment. Add `--no-builds` if the environment must be rebuilt on another platform.

## Recreate

```bash
conda env create --file environments/conda/samtools.yaml --prefix environments/conda/samtools
```

`--prefix` overrides the `name:` and `prefix:` that the export writes into the file.

## Use

Activate it by path, or run a single command in it:

```bash
conda activate ./environments/conda/samtools
conda run --prefix environments/conda/samtools samtools --version
```
