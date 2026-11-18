# environments/renv/

A shared R package library managed by [renv](https://rstudio.github.io/renv/):

```
environments/renv/
├── README.md
├── renv.lock          lockfile, tracked
├── .Rprofile          sources renv/activate.R, ignored
└── renv/              ignored
    ├── activate.R
    ├── settings.json
    └── library/       installed packages
```

Only `renv.lock` is tracked: renv writes the rest again when the environment is recreated.

> [!TIP]
> To track one of the other files anyway, for example after changing a setting in `settings.json`, add it with `git add --force environments/renv/renv/settings.json`.

## Create

```r
renv::init(project = 'environments/renv', bare = TRUE)
renv::install('Seurat', project = 'environments/renv')
```

`bare = TRUE` stops `init()` from scanning for R code to find dependencies.

## Write the lockfile

```r
renv::snapshot(project = 'environments/renv', type = 'all')
```

`type = 'all'` records every package in the library, which is useful here to create a complete record of the entire library. The default, `'implicit'`, records only packages used by R code in the directory and should be used from analysis directories.

## Recreate

```r
renv::activate(project = 'environments/renv')
renv::restore(project = 'environments/renv')
```

`activate()` writes `.Rprofile` and `renv/activate.R`, which are not tracked; `restore()` installs the packages in `renv.lock`.

## Use in an analysis

renv activates when R starts in a directory with its `.Rprofile`. An analysis can use the shared library by linking `.Rprofile` and `renv/` into its own directory:

```bash
cd working/<topic>/<tool>
ln --symbolic --relative ../../../environments/renv/.Rprofile .Rprofile
ln --symbolic --relative ../../../environments/renv/renv renv
```

The analysis can keep its own `renv.lock`, as a real file rather than a link, listing only the packages it uses. Started in the analysis directory, R writes it from the analysis's code:

```r
renv::snapshot()
```

The shared `environments/renv/renv.lock` records the whole library; the analysis's records what the analysis needs.
