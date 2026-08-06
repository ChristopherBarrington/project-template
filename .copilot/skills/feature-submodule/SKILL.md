---
name: feature-submodule
description: Manage GitHub repositories as project submodules, including adding repositories, creating symlinks to repository files or directories, and removing submodules while migrating linked resources. Use when you need to integrate external repositories, reuse code across projects, or maintain clean dependencies.
argument-hint: user/repo, path/to/submodule, "<file> <dir/> ..."
user-invocable: true
disable-model-invocation: false
---

# Managing submodules in a project

## Required inputs

- Repository (required): a Git(Hub) repository to be added as a submodule. If this is provided as `<user>/<repo>`, assume it is hosted on GitHub. Otherwise a complete URL should be provided.
- Submodule path (required): path within the project where the submodule will be added.
- Files or directories to symlink (optional): specific files or directories in the submodule that will be symlinked to the project. Pass as a space-separated string enclosed in quotes: `"file1 dir1/ file2"`.

## When to use this skill

Use this skill when you need to:

- Integrate external repositories into your project as submodules.
- Reuse code across multiple projects while maintaining a clean dependency structure.
- Manage project dependencies without directly copying files, allowing for easier updates and maintenance.
- Use a supplementary repository but need to maintain independent version control for that repository. Submodules can be updated using `git pull` or `git submodule update` to fetch the latest changes from the linked repository.
- Remove submodules while migrating symlinked resources, ensuring that the project remains functional even after the submodule is removed.

## Process

1. Review documentation in the [makefile](makefile.mk) to understand available targets and required variables.
2. Verify the user has provided all required information (for example repository URL and submodule path).
3. Ask the user for any missing required information.
4. Execute the appropriate make command(s) using the information provided by the user or agent.

## Best practices

- Always confirm the exact commands that will be run before executing any operations, especially those that modify the project structure.
- Use only the provided [makefile](makefile.mk) targets to manage submodules, as this contains necessary documentation.
- Use ssh remotes for submodules, do not use https, for improved security and easier authentication. This requires the user to have their ssh keys set up correctly with the git provider (e.g., GitHub).

## Guidance during execution

- Consult the [makefile](makefile.mk) targets and variable documentation for specific operations.
- If a `make` command returns errors, relay them to the user with suggestions for fixes but do not offer to execute them yourself.
  - Errors are handled in the [makefile](makefile.mk) with descriptive messages and non-zero exit codes, so they should be clear to the user when relayed back to them.

## Examples

Below are some example prompts that may be used with this skill. The inputs are provided to the [makefile](makefile.mk) as variables, and the operations are performed by invoking the appropriate targets. Users should consult the documentation in the [makefile](makefile.mk) for details on the available targets and required variables.

> Add the ChristopherBarrington/babs-project resource to the project at `resources/github/ChristopherBarrington/babs-project` and link the data directory and .gitignore file

```bash
make --dry-run \
-f .github/skills/feature-submodule/makefile.mk \
submodule_path_root=resources/github \
repository=ChristopherBarrington/babs-project \
targets="data/ .gitignore" \
add add-symlinks status
```

> Remove the resources/github/ChristopherBarrington/babs-project resource from the project

```bash
make --dry-run \
-f .github/skills/feature-submodule/makefile.mk \
submodule_path_root=resources/github \
repository=ChristopherBarrington/babs-project \
remove status
```