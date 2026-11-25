# .github/

This directory contains GitHub-specific files that control how the repository behaves on GitHub, and this documentation of the template.

## Contents

| Path              | Purpose                                                 |
| :---------------- | :------------------------------------------------------ |
| `ABOUT.md`        | Because README.md would render on the landing page      |
| `CONTRIBUTING.md` | Guidelines for contributors: branching and commit style |

## Project template

This repository is a template for bioinformatics projects. The root `README.md` is the project landing page, describing what is being done in the project, whereas documentation about the template is here. Each directory has a `README.md` describing its intended use.

### Repository structure

| Path            | Purpose                                                                                 |
| :-------------- | :-------------------------------------------------------------------------------------- |
| `bin/`          | Optional executables and scripts for the whole project                                  |
| `data/`         | Input data: collaborator, Crick, public, `private/` and `synthetic/`                    |
| `docs/`         | Documentation about the project and its biology                                         |
| `environments/` | Package environments: conda, renv and uv recipes and lockfiles                          |
| `resources/`    | Computational reference material: repositories, documentation, published genomes        |
| `scratch/`      | Untracked dumping ground; ignored at any depth                                          |
| `share/`        | Links to results in `working/`, organised for sharing with collaborators and GEO        |
| `software/`     | Launchers, container definitions and binaries, linked from `bin/`                       |
| `working/`      | Where analyses are run and all results are stored; `nf-core/` for nf-core pipeline runs |
| `.claude/`      | Claude Code settings (permissions and sandbox) and the rules Claude follows             |
| `.github/`      | GitHub templates, community health files and this file                                  |
| `CLAUDE.md`     | Project context and data access instructions for Claude Code                            |
| `README.md`     | Project landing page: aims, collaborators, data and main analyses                       |

### Where does this file go?

| File                                             | Location                                          |
| :----------------------------------------------- | :------------------------------------------------ |
| FASTQ files from the collaborator or Crick       | `data/primary_data/`                              |
| Sample sheet or cell type classifications        | `data/`                                           |
| Public dataset downloaded from GEO               | `data/external/`                                  |
| Custom genome FASTA or GTF                       | `data/`                                           |
| Index of a custom genome                         | built in `working/`                               |
| Link to a custom index used by another analysis  | the `inputs/` of that analysis                    |
| Data that Claude must not read                   | `data/private/`                                   |
| Made-up stand-in for the data in `data/private/` | `data/synthetic/`                                 |
| Published genome FASTA or GTF (for example mm10) | `resources/references/`                           |
| GitHub repository used by the analysis           | `resources/github/<owner>/<repo>/` as a submodule |
| Manual or vignette for a package                 | `resources/docs/<package>/`                       |
| Paper, protocol or slides about the biology      | `docs/`                                           |
| Conda recipe or environment                      | `environments/conda/`                             |
| renv or uv lockfile                              | `environments/renv/` or `environments/uv/`        |
| Dockerfile or Apptainer/Singularity definition   | `software/<tool>/<version>/`                      |
| Launcher or compiled binary                      | `software/`, with a link in `bin/`                |
| Script reused across analyses                    | `bin/`                                            |
| Code and results of an analysis                  | `working/<topic>/<tool>/`                         |
| Run of an nf-core pipeline                       | `working/nf-core/<pipeline>/`                     |
| Instructions for Claude                          | `.claude/rules/`                                  |
| HTML report or Shiny app for a collaborator      | link in `share/` to the result in `working/`      |
| Files to upload to GEO                           | links in `share/geo/`                             |
| Temporary files                                  | `scratch/`                                        |

### Branches

The main checkout of a project stays on `main`. Analyses run from it, and some run for days.

Switching branches (`git switch`, `git checkout`) changes the tracked files in the working tree. The scripts of any analysis that is not on the new branch are removed. A running Slurm job can then lose its scripts, and its outputs are left beside a directory with no code. Outputs are ignored by git, so they stay. Bash reads a script as it runs, so a change to the `run.sh` of a running analysis can also alter the job.

Make changes in git worktrees instead. A worktree is a second working tree of the same repository, checked out on its own branch. Each one lives in `.worktrees/<topic>/`, which git ignores, on a `<topic>@claude` branch. The user reviews the branch and merges it in the main checkout. Real runs start only from the main checkout, because a worktree's untracked outputs are lost when the worktree is removed. A worktree holds only tracked files, so code tested there reads data, software and scratch from the main checkout by absolute path. `.claude/rules/project-rules.md` gives the rules and the commands.

Claude asks before it runs `git switch`, `git checkout` or `git merge` (see `.claude/settings.json`). Git cannot block a switch made by hand, so do not switch the main checkout.

An analysis's `proposal.md`, `check.md` and `report.html` are ignored, so they stay beside its `plan.md` on any branch. The project proposal in `docs/proposal/` is tracked.

### Publishing code

A second git directory, `.git-public/`, can be kept in the same working tree. Its purpose is to publish the code with a separate history and remote, without the full development history or files (for example READMEs) that record discussion during the analysis. The main repository ignores it.

Use it by pointing git at it, for example with an alias, and choose what to publish with `.git-public/info/exclude`.

```bash
alias git-public='git --git-dir=.git-public --work-tree=.'
```

### Creating a project from this template

Make sure `git` and `gh` are available. For example, using a conda environment.

```bash
conda activate git
```

Define a name of the new project.

```bash
new_project=new-project
```

#### GitHub

Optionally set `gh` to use `ssh` protocol rather than https. This modifies `~/.config/gh`.

```bash
gh config set git_protocol ssh
```

Create a new project in the account associated with the `GH_TOKEN` and in the local directory.

```bash
GH_TOKEN=$GH_TOKEN gh repo create $new_project --clone --disable-wiki --private --template project-template
```

Optionally, remove the remote to make the project local-only and delete the newly-created GitHub repository.

```bash
cd $new_project
git remote rm origin
GH_TOKEN=$GH_TOKEN gh repo delete --yes $new_project
```

#### Git

First, clone the template repository into a new `$new_project` directory, and move into the new project.

```bash
git clone --branch main git@github.com:ChristopherBarrington/project-template.git $new_project && cd $_
```

Optionally, remove permissions tracking and use the user default configuration, if set. This can avoid problems on Nemo when file permissions get changed and are considered a file change by `git`.

```bash
git config --unset core.FileMode
```

Delete the `.git` repository that tracked the development of the template. A new repository can be created that is independent of the template repository.

```bash
rm --recursive --force .git
git init --quiet
```

### Updating the template

#### Git submodules

The template repository can be added to the project as a submodule and template files symlinked.

```bash
git submodule add \
--branch main \
git@github.com:ChristopherBarrington/project-template \
resources/github/ChristopherBarrington/project-template
```

Then, a symlink to each template file or directory can be made. This includes the `.gitignore` files of the directories that have their own, so that changes to the ignore rules follow template updates.

```bash
template=resources/github/ChristopherBarrington/project-template
for target in \
	.gitignore \
	data/.gitignore \
	environments/conda/.gitignore \
	environments/renv/.gitignore \
	environments/uv/.gitignore \
	resources/.gitignore \
	share/.gitignore \
	software/.gitignore \
	working/.gitignore \
	working/nf-core/.gitignore \
	resources/README.md \
	.claude/rules/project-rules.md; do
	rm --recursive --force $target \
	&& ln --symbolic --relative $template/$target $target
done
```

#### Copier

[Copier](https://github.com/copier-org/copier) is a possible option.

## Claude Code

Claude Code is kept away from the project's data by `.claude/settings.json`. Its permission rules govern Claude's file tools, and are enforced by Claude Code, not left to Claude's judgement. `CLAUDE.md` gives Claude the project's context, and `.claude/rules/project-rules.md` gives it the same rules as instructions.

> [!WARNING]
> The permission rules do not cover Bash. Bash can read any file in the project, including `private/` and `inputs/`, through `cat`, `python -c` or `grep -r`. Only the rules in `.claude/rules/project-rules.md`, which Claude follows by instruction, keep Bash away from the data.

### The sandbox

Claude Code has a sandbox: an operating-system feature (on Linux, `bwrap`, bubblewrap) that it wraps around each Bash command Claude runs. The kernel limits which files the command, and every program it starts, can read or write, so the sandbox could apply the data rules to Bash as well as to the file tools.

The sandbox is off in this template: `.claude/settings.json` sets `"enabled": false`. It has not yet worked reliably here. It needs `bwrap` and `socat` on `PATH`, and Apptainer/Singularity cannot start inside it. Type `/sandbox` in a session to see whether it is on, and read the [Claude Code sandboxing documentation](https://code.claude.com/docs/en/sandboxing) before turning it on.

### Getting started

1. Install Claude Code (see [Dependencies](#dependencies)).
2. Start `claude` at the project root.
3. Type `/status` to check that the project's settings are loaded.
4. To work on an analysis, ask Claude to `cd working/<analysis>` rather than starting Claude there.

### Where to start Claude

Claude Code reads `.claude/settings.json` from one directory only: the session's primary working directory, where it started or where `/cd` last moved it. User settings (`~/.claude/settings.json`) and `settings.local.json` at the git root always apply. Lists such as `deny` are combined across files, and a deny from any file wins.

| How you start                                                  | Settings used                                                                       | Data rules                           | Recommended                                 |
| :------------------------------------------------------------- | :---------------------------------------------------------------------------------- | :----------------------------------- | :------------------------------------------ |
| `claude` at the project root                                   | The project's                                                                       | Apply                                | Yes                                         |
| At the root, then ask Claude to `cd working/<analysis>` (Bash) | The project's. Commands run in the analysis; the session's directory stays the root | Apply, anchored at the root          | Yes                                         |
| At the root, then type `/cd working/<analysis>`                | The analysis's `.claude/settings.json`, or none. The project's are dropped          | The analysis's own; none without one | Only into an analysis with its own settings |
| `cd working/<analysis> && claude`                              | The analysis's `.claude/settings.json` only                                         | The analysis's own; none without one | Only into an analysis with its own settings |

Files Claude uses:

```text
project/
├── CLAUDE.md                     instructions; loaded at start
├── .claude/
│   ├── settings.json             permissions; enforced, not advice
│   ├── settings.local.json       your "don't ask again" approvals; git-ignored
│   └── rules/*.md                instructions; loaded at start, or with paths: when matching files are used
├── data/
│   └── private/                  any directory named private, at any depth
│       └── **/README.md          readable; every other file in private/ is not
└── working/<analysis>/
    ├── CLAUDE.md                 loaded when Claude first reads or edits a file here
    ├── .claude/rules/*.md        loaded on demand, the same way
    ├── .claude/skills/, agents/  loaded after /add-dir working/<analysis>
    └── .claude/settings.json     used only when Claude starts or /cd's here

~/.claude/
├── CLAUDE.md, rules/*.md         your instructions; every project
└── settings.json                 your settings; every project, combined with the project's
```

#### Using /cd

`/cd` changes the session's primary working directory, and with it the settings file: the project's `.claude/settings.json` is dropped and the target's is used instead. Into an analysis without its own settings file, `/cd` drops the data rules altogether. Use it only into an analysis that has its own settings (see [Analysis-specific settings](#analysis-specific-settings)); otherwise ask Claude to `cd` in Bash.

### What the settings enforce

`permissions` governs the Read tool, `@`-mentions and the editor's open file. It does not govern Bash (see [The sandbox](#the-sandbox)).

#### Per directory

| Path                                         | Read tool | Set by             |
| :------------------------------------------- | :-------- | :----------------- |
| `private/`, anywhere in the project          | Denied    | `permissions.deny` |
| `private/` READMEs, at any depth             | Read      | `!` carve-out      |
| `inputs/`, files with an extension           | Denied    | `permissions.deny` |
| `inputs/`, files and links with no extension | Ask       | `permissions.ask`  |
| `outputs/`                                   | Ask       | `permissions.ask`  |

"Ask" means Claude asks each time; "Yes, and don't ask again" does not stop it. Claude Code always asks before its Write or Edit tool changes a settings file.

When something is denied, the Read tool returns an error naming the setting. A subagent receives the denial itself, so it reaches you only if the subagent's summary mentions it.

#### Settings explained

JSON has no comments, so this table explains the keys and rules used in `.claude/settings.json`.

| Key or rule                                       | What it does                                                                                                                                                                                                                                                 |
| :------------------------------------------------ | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `permissions.deny`                                | Never allowed. A deny in any settings file wins over any allow or ask                                                                                                                                                                                        |
| `permissions.ask`                                 | Claude asks each time. "Yes, and don't ask again" does not override it                                                                                                                                                                                       |
| `permissions.allow`                               | Allowed without asking                                                                                                                                                                                                                                       |
| `permissions.blockReadsOutsideWorkingDirectories` | The file tools refuse anything outside the start directory, including `~/.claude`                                                                                                                                                                            |
| `Read(<path>)`                                    | The Read tool, `@`-mentions and the editor's open file. Deny rules, but not ask rules, are also passed to the sandbox when it is on                                                                                                                          |
| `Edit(<path>)`                                    | The Edit and Write tools                                                                                                                                                                                                                                     |
| `Bash(<command> *)`                               | Bash commands by prefix. Easy to get round (`env cat`), so not used for data                                                                                                                                                                                 |
| `WebFetch(domain:<host>)`                         | Web pages Claude fetches                                                                                                                                                                                                                                     |
| `!<pattern>`                                      | Carves paths out of the rules listed before it, in the same list. Write it without `./`                                                                                                                                                                      |
| Path forms in `Read(...)`                         | `data/x` or `./data/x`: from the start directory; `/x`: from the project root; `//x`: absolute; `~/x`: home; `*.x`: any depth. `*` stays within one directory, `**` crosses them                                                                             |
| `sandbox.enabled`                                 | Runs Bash commands in the sandbox. `false` (see [The sandbox](#the-sandbox))                                                                                                                                                                                 |

#### Known gaps

- Bash can read every file in the project (see [The sandbox](#the-sandbox)).
- Claude sees Claude Code's own denial text, not a custom message.

### Analysis-specific settings

#### Adding a stricter rule for one analysis

An extra deny or ask for one analysis goes in the root `.claude/settings.json`, written with the analysis's path. An analysis's `CLAUDE.md`, rules, skills and subagents add instructions, not permissions.

#### An analysis's own settings file

To loosen a rule for one analysis, for example to let Claude read one file type there, write `working/<analysis>/.claude/settings.json` and start Claude there (or `/cd` there). It replaces the project's file rather than extending it, so it is written for the analysis alone. In the example:

- **Nothing above the analysis is visible to the Read tool.** `blockReadsOutsideWorkingDirectories` makes it refuse any path outside the analysis.
- **Outputs are asked for by type.** List the extensions the analysis writes that Claude should not read unasked. Other outputs are read freely.

```json
{
	"$schema": "https://json.schemastore.org/claude-code-settings.json",
	"permissions": {
		"blockReadsOutsideWorkingDirectories": true,
		"deny": [
			"Read(inputs/**/*.*)"
		],
		"ask": [
			"Read(inputs/**/*)",
			"Read(outputs/**/*.csv)",
			"Read(outputs/**/*.tsv)"
		]
	},
	"sandbox": {
		"enabled": false
	}
}
```

What an analysis session can see: your `CLAUDE.md`, rules, skills and plugins load as in the project. The Read tool refuses files under `~/.claude`, which matters when a skill tells Claude to read one of its supporting files.

`additionalDirectories` in the analysis's settings is ignored until you have accepted the trust prompt there once.

### Parallel sessions

All of these use the project's settings when started at the root:

- **CLI:** `claude agents` opens agent view, listing every background session across projects and showing which need input. Type a prompt to start a session in that directory, or `@<repo>` for a repository one level below. `claude --bg "<prompt>"` starts one from a shell; `/bg` moves a running session into agent view. Agent view is a research preview.
- **Extension:** Command Palette, "Claude Code: Open in New Tab", once per conversation.

### Dependencies

- Claude Code 2.1.295 or later.

## AI Model Tiers

Claude Code can use any of the Claude models, each suited to different tasks and workloads. Choose one with `/model`.

### Quick Comparison

| Model         | Best For                                         |
| :------------ | :----------------------------------------------- |
| Claude Haiku  | Quick tasks, autocomplete, simple Q&A            |
| Claude Sonnet | Day-to-day coding, code review, documentation    |
| Claude Fable  | Creative ideation, exploratory drafts, tone work |
| Claude Opus   | Complex reasoning, architecture, high-stakes     |

### Anthropic Models

#### [Haiku](https://www.anthropic.com/claude/haiku) — fast and lightweight

Best for: quick, repetitive, or straightforward tasks where speed matters more than depth.

- Very fast response times
- Good for summarisation, simple Q&A, autocomplete, and boilerplate generation
- Lower reasoning depth than larger models
- Less reliable on complex multi-step problems or nuanced instructions

#### [Sonnet](https://www.anthropic.com/claude/sonnet) — balanced

Best for: general coding assistance, code review, explanation, documentation, and most day-to-day tasks.

- Strong reasoning and instruction-following
- Good balance of speed and capability
- Handles multi-step problems, refactoring, and debugging well
- The default choice for most tasks in this project

#### [Fable](https://www.anthropic.com/claude/fable) — creative and exploratory

Best for: brainstorming, narrative framing, naming, and early-draft content where tone and originality matter.

- Strong at idea generation and alternative phrasings
- Useful for drafting docs intros, release notes framing, and design narratives
- Better for exploration than strict deterministic implementation work
- Pair with Sonnet or Opus when moving from ideation to production-quality code changes

#### [Opus](https://www.anthropic.com/claude/opus) — most capable

Best for: difficult, high-stakes, or deeply reasoned tasks where quality matters most.

- Highest reasoning capability across the Claude family
- Best at long-context understanding, complex analysis, and nuanced writing
- Slower and more resource-intensive than Haiku or Sonnet
- Worth using for architecture decisions, complex debugging, or thorough code review; overkill for routine tasks

## References

- [GitHub community health files](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file)
- [Issue and PR templates](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests)
- [Claude models overview](https://docs.claude.com/en/docs/about-claude/models/overview)
