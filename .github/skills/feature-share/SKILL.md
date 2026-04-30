---
name: feature-share
description: Manage the share directory of a project, including creating and removing links to external resources such as the Apache and Shiny servers, the outputs directory and a GEO staging directory.
argument-hint: "<create|remove> <share/[geo|outputs|www]>"
user-invocable: true
disable-model-invocation: false
---

# Managing results sharing directories in a project

## Required inputs

- Share resource to link or remove (required): the specific share resource to link or remove. These are defined from the [makefile](makefile.mk) targets and include, for example, `share/www` and `share/outputs`.

## When to use this skill

Use this skill when you need to:

- Create a link to an external resource in the share directory of the project, such as the Apache server, Shiny server, outputs directory or GEO staging directory.
- Remove an existing link to an external resource in the share directory of the project

## Process

1. Review documentation in the [makefile](makefile.mk) to understand available targets and required variables.
2. Verify the user has provided all required information. There are defaults in the [makefile](makefile.mk) for these variables, but they should be overridden by the user to ensure links are created to the correct locations.
3. Ask the user for any missing required information, or to confirm the defaults are correct before proceeding.
4. Execute the appropriate make command(s) using the information provided by the user or agent, and perform a `status` check at the same time

## Best practices

- Always confirm the exact commands that will be run before executing any operations, especially those that modify the project structure.
- Use only the provided [makefile](makefile.mk) targets to manage share links, as this contains necessary documentation.
- Use the `status` target to report the current state of the share directory after any other targets are run.

## Guidance during execution

- Consult the [makefile](makefile.mk) targets and variable documentation for specific operations.
- If a `make` command returns errors, relay them to the user with suggestions for fixes but do not offer to execute them yourself.
  - Errors are handled in the [makefile](makefile.mk) with descriptive messages and non-zero exit codes, so they should be clear to the user when relayed back to them.

## Examples

Below are some example prompts that may be used with this skill. The inputs are provided to the [makefile](makefile.mk) as variables, and the operations are performed by invoking the appropriate targets. Users should consult the documentation in the [makefile](makefile.mk) for details on the available targets and required variables.

> Add all shares to the project

```bash
make --dry-run -f .github/skills/feature-share/makefile.mk user_short=lastnaf user_long=firstname.lastname add status
```

> Add the share/outputs link to the project my username is lastnaf and my id is firstname.lastname

```bash
make --dry-run \
-f .github/skills/feature-share/makefile.mk \
user_short=lastnaf \
user_long=firstname.lastname \
share/outputs status
```

> Remove share/www from the project

```bash
make --dry-run \
-f .github/skills/feature-share/makefile.mk \
clean-share/www status
```
