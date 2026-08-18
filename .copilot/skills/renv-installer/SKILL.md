---
description: Generate renv::install() commands for R scripts by detecting required packages from library() calls and package::function() patterns. Automatically distinguishes between CRAN and Bioconductor packages.
patterns:
  - "renv"
  - "install packages"
  - "R dependencies"
  - "renv-installer"
---

# R Package Dependency Detection for renv

When invoked, analyze the current R script (or specified file) to detect all required packages and generate a complete `renv::install()` command.

## Detection Strategy

1. **library() and require() calls**: Extract package names from `library(package)` or `require(package)` statements
2. **Package prefix usage**: Detect `package::function()` patterns throughout the code
3. **suppressPackageStartupMessages()**: Check inside these blocks for library calls

## Package Classification

Use URL checking to determine package source:

1. **Check CRAN first**: Test `https://cran.r-project.org/web/packages/<package>/index.html`
   - If returns 200 OK → CRAN package (no prefix needed)
2. **Check Bioconductor**: Test `https://bioconductor.org/packages/<package>/`
   - If returns 200 OK → Bioconductor package (use `bioc::` prefix)
3. **Default to Bioconductor**: If neither URL works → assume Bioconductor (use `bioc::` prefix)

### Implementation
- Use fetch_webpage or HEAD requests to check URLs
- Skip base R packages (base, stats, utils, graphics, grDevices, methods, datasets, tools, grid, parallel, compiler, splines, tcltk)
- Cache results to avoid redundant requests
- Handle packages efficiently in batch if possible

## Output Format

Generate a clean `renv::install()` command:

```r
renv::install(c(
  "cran_package1",
  "cran_package2",
  "bioc::BioconductorPackage1",
  "bioc::BioconductorPackage2",
  "cran_package3"
))
```

## Execution Steps

1. **ONLY process R files that are**:
   - Explicitly attached to the chat by the user
   - Specified as arguments (e.g., `@renv-installer script.R`)
   - Currently open in the editor (if no files attached/specified)
2. **Do NOT** search for, discover, or read additional R files in the workspace
3. Search for all package references in the target file(s):
   - Grep for `library\(` and `require\(`
   - Grep for `[a-zA-Z][a-zA-Z0-9.]*::` patterns
4. Extract unique package names
5. Sort alphabetically, placing CRAN packages first, then Bioconductor packages
6. Output the complete `renv::install()` command
7. Include a note if any packages couldn't be classified

## Example Invocation

User types: `/renv-installer`
- Analyze currently open R file only
- Generate and display the install command
- Copy-ready format

User types: `@renv-installer path/to/script.R`
- Analyze only the specified file
- Generate install command

User attaches R files and types: `/renv-installer`
- Analyze only the attached files
- Generate install command for all packages found

## Additional Notes

- If `renv.lock` exists, mention that the user can also use `renv::restore()`
- For packages with unclear origin, default to CRAN (no prefix) and note them
- Ignore base R packages (stats, utils, graphics, grDevices, methods, base)
