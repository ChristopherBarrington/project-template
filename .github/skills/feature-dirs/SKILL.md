---
name: feature-dirs
description: Manage template directories of a project, including creating and removing links to external resources for input data and results.
argument-hint: "<create|remove> <[data/[inputs|primary_data]]|[share/[geo|outputs|www]]>"
user-invocable: true
disable-model-invocation: false
---

# Managing template directories in a project

## Required inputs

- Template resource to link or remove (required): the specific template resource to link or remove. These are defined from the [dir-data](dir-data.mk) and [dir-share](dir-share.mk) makefile targets and include, for example, `data/inputs` and `share/outputs`.

## When to use this skill

Use this skill when you need to:

- Populate template directories with the necessary files and structure.
- Remove an existing template directory feature.

## Process

1. Review documentation in the [dir-data](dir-data.mk) and [dir-share](dir-share.mk) makefiles to understand available targets and required variables.
2. Verify the user has provided all required information. There are defaults in the makefiles for these variables, but they should be overridden by the user to ensure links are created to the correct locations.
3. Ask the user for any missing required information, or to confirm the defaults are correct before proceeding.
4. Execute the appropriate make command(s) using the information provided by the user or agent, and perform a `status` check at the same time

## Best practices

- Always confirm the exact commands that will be run before executing any operations, especially those that modify the project structure.
- Use only the provided [dir-data](dir-data.mk) and [dir-share](dir-share.mk) makefile targets to manage template directories, as this contains necessary documentation.
- Use the `status` target to report the current state of the template directories after any other targets are run.

## Guidance during execution

- Consult the makefiles' targets and variable documentation for specific operations.
- If a `make` command returns errors, relay them to the user with suggestions for fixes but do not offer to execute them yourself.
  - Errors are handled in the makefiles with descriptive messages and non-zero exit codes, so they should be clear to the user when relayed back to them.

## Examples

Below are some example prompts that may be used with this skill. The inputs are provided to the makefiles as variables, and the operations are performed by invoking the appropriate targets. Users should consult the documentation in the makefiles for details on the available targets and required variables.

> Add all shares to the project

```bash
make --dry-run -f .github/skills/feature-dirs/dir-share.mk user_short=lastnaf user_long=firstname.lastname add status
```

> Add the data/inputs link to the project my username is lastnaf and my id is firstname.lastname

```bash
make --dry-run \
-f .github/skills/feature-dirs/dir-data.mk \
user_short=lastnaf \
user_long=firstname.lastname \
data/inputs status
```

> Add the share/outputs link to the project my username is lastnaf and my id is firstname.lastname

```bash
make --dry-run \
-f .github/skills/feature-dirs/dir-share.mk \
user_short=lastnaf \
user_long=firstname.lastname \
share/outputs status
```

> Remove share/www from the project

```bash
make --dry-run \
-f .github/skills/feature-dirs/dir-share.mk \
remove-share/www status
```
