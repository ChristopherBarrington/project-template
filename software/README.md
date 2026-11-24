# software/

Optional. Software the project runs, and how to run it:

- launchers, for example a script that runs a specific version of R from an Apptainer/Singularity image
- container definitions: Dockerfiles and Apptainer/Singularity definition files
- compiled binaries and the images themselves, which are not tracked

Executables are made available by symlinks from `bin/` (or an analysis's `bin/`) to the launcher or binary here. Package environments that a package manager resolves, such as conda, renv and uv, belong in `environments/`.

A layout by tool, version and backend keeps several versions side by side, for example:

```
software/
├── r/
│   ├── 4.5.2/
│   │   └── babs-environments/
│   │       ├── launcher -> R-4.5.2
│   │       ├── python3 -> R-4.5.2
│   │       ├── R -> R-4.5.2
│   │       └── R-4.5.2
│   └── 4.6.1/
│       └── apptainer/
│           └── launcher.sh
└── samtools/
    └── 1.27.1/
        └── singularity/
            └── launcher.sh
```

```bash
ln --symbolic --relative software/r/4.6.1/apptainer/launcher.sh bin/R
```

Image files (`*.sif`) are ignored. Add large binaries to `.gitignore` here so that only launchers, definitions and READMEs are tracked.

Launchers that wrap a container need entries in `.claude/settings.json` before Claude can run them: see `bin/README.md`.
