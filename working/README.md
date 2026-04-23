# working/

All working analyses for the project are kept here. Each analysis should be in its own sub-directory, with its code tracked via git. `outputs/` are excluded from the index by default using `.gitignore`, among other non-code-related directories - `logs/` and `renv/`. These can be added to if necessary.

Analyses can have their own environments and documentation and should include a README.md at some level.

The structure in this directory is hierarchical and can be of any depth. A directory can be considered a workflow, which may include multiple tasks or subworkflows. Task-level directories are where an analysis happens and contains inputs, outputs and a `run.sh` (or some other way to run the analysis). For example, the root workflow may be an analysis package within which there are multiple steps (tasks) that need to be run in a specific order. A workflow could include a run script (eg `run.sh`, `run.Rscript`) that can run each task in order.

For a single cell RNA-seq analysis, using Seurat a basic workflow may be broken down into smaller tasks. The below example gives an idea of how a workflow can be structured (the example is not exhaustive for clarity). The top-level `seurat/` workflow contains: a `renv/` environment that each of the tasks can use, a `run.sh` that would run each task, and a collection of task directories. Each task directory has a link to the shared `renv/`, inputs (here from the previous task's `outputs/`), `outputs/` and a `run.sh`.

```
seurat/
├── cell-type-annotation
│   ├── inputs -> ../quality-control/outputs/
│   ├── outputs
│   ├── renv -> ../renv
│   └── run.sh
├── quality-control
│   ├── inputs -> ../read-10x/outputs/
│   ├── outputs
│   ├── renv -> ../renv
│   └── run.sh
├── read-10x
│   ├── inputs
│   ├── outputs
│   ├── renv -> ../renv
│   └── run.sh
├── renv
└── run.sh
```
