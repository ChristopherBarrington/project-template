# working/

All working analyses for the project are kept here, and all results are stored here. An output used by another analysis is linked into that analysis's `inputs/`. An output for the collaborator is linked from `share/`. Each analysis should be in its own sub-directory, with its code tracked via git.

The directory should be structured, not a flat directory of dozens of scripts for every analysis in the project. A convention is `working/<topic>/<tool>`, for example `working/cell-cell-communication/cell-chat` or `working/samtools/merge`, but it is not fixed and should be adapted to the analysis.

Within an analysis, `inputs/` holds links to the data used (from `data/` or the `outputs/` of other analyses) and `outputs/` holds the results. These, `logs/` and `renv/` are excluded from the index by default using `.gitignore`, and this can be added to if necessary. `bin/` (executables used by the analysis) and `scratch/` (untracked) have the same meaning as at the project level.

Each analysis should have a `README.md` at some level; `analysis-readme-template.md` in this directory can be copied as a starting point. A one-line `summary:` in the frontmatter of the README at the root of an analysis lists it in the project README's Analyses table; READMEs without a summary are not listed.

Analyses can have their own environments and documentation and should include a README.md at some level.

The structure in this directory is hierarchical and can be of any depth. A directory can be considered a workflow, which may include multiple tasks or subworkflows. Task-level directories are where an analysis happens and contains inputs, outputs and a `run.sh` (or some other way to run the analysis). For example, the root workflow may be an analysis package within which there are multiple steps (tasks) that need to be run in a specific order. A workflow could include a run script (eg `run.sh`, `run.Rscript`) that can run each task in order.

In the below example, there is a workflow for "analysis-package". The workflow needs two tasks to be completed (`task-1/` and `task2`). It is likely that the output of `task-1/` is an input for `task-2/` and that `task-2/` is the endpoint of the workflow for `analysis-package/`. There is a `run.sh` for the workflow, which is a convenience script that runs each of the tasks for the workflow. Here, the `run.sh` are examples, but could be any type of script - bash, R, Nextflow, etc.

```
analysis-package/
├── task-1
│   └── run.sh
├── task-2
│   └── run.sh
└── run.sh
```
