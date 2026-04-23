# working/

All working analyses for the project are kept here. Each analysis should be in its own sub-directory, with its code tracked via git. `outputs/` are excluded from the index by default using `.gitignore`, among other non-code-related directories - `logs/` and `renv/`. These can be added to if necessary.

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
