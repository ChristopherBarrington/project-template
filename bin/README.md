# bin/

Optional. Executables and scripts for the whole project, such as:

- launchers for project-wide software, for example an Apptainer/Singularity wrapper for a specific version of R or a downloaded tool
- scripts written by the analyst that are reused across analyses

Container and environment definitions are kept in `envs/`; `bin/` holds the executables that use them. Large downloaded software belongs in `resources/src/`, with only a launcher kept here.

Analyses in `working/` can have their own `bin/` with the same meaning.

## Launchers and Claude Code

Claude Code runs Bash commands in a sandbox, and Apptainer/Singularity cannot start inside it. A launcher that wraps a container therefore needs two entries in [`.claude/settings.json`](../.claude/settings.json), using the name the launcher is invoked by (for example `R`, not `./R`):

- an `ask` permission, so that each run prompts: `"Bash(R:*)"`
- an `excludedCommands` entry, so that it runs outside the sandbox: `"R"`

```json
{
	"permissions": {
		"ask": ["Bash(R:*)", "Bash(Rscript:*)", "Bash(python:*)"]
	},
	"sandbox": {
		"excludedCommands": ["R", "Rscript", "python"]
	}
}
```

Add a pair for every container-backed tool launched by name, such as a Python environment with specific packages.

> [!WARNING]
> An excluded command runs unsandboxed with your full access, and the launchers bind `/camp` and `/nemo` whole, so the container does not protect `data/` or `inputs/`. The `ask` prompt is the only guard: read what is being run before approving it.
