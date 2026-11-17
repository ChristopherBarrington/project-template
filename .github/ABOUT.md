# .github/

This directory contains GitHub-specific files that control how the repository behaves on GitHub, and this documentation of the template.

## Contents

| Path                                | Purpose                                                          |
| :---------------------------------- | :--------------------------------------------------------------- |
| `ABOUT.md`                          | Because README.md would render on the landing page               |
| `CONTRIBUTING.md`                   | Guidelines for contributors: branching, commit style, PR process |
| `ISSUE_TEMPLATE/bug_report.md`      | Template for reporting bugs                                      |
| `ISSUE_TEMPLATE/feature_request.md` | Template for requesting new features or enhancements             |
| `PULL_REQUEST_TEMPLATE.md`          | Default template pre-filled when opening a pull request          |

## Project template

This repository is a template for bioinformatics projects. The root `README.md` is the project landing page, describing what is being done in the project, whereas documentation about the template is here. Each directory has a `README.md` describing its intended use.

### Repository structure

| Path            | Purpose                                                                                 |
| :-------------- | :-------------------------------------------------------------------------------------- |
| `bin/`          | Optional executables and scripts for the whole project                                  |
| `data/`         | Input data: collaborator, Crick, public, derived, `private/` and `synthetic/`           |
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
| Genome with a gene added by a collaborator       | `data/`, with the index built in `working/`       |
| Link to the index of a custom genome             | `data/derived/`                                   |
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
	environments/.gitignore \
	environments/conda/.gitignore \
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

Claude Code is kept away from the project's data by `.claude/settings.json`. Its permission rules govern Claude's file tools and its sandbox governs every command Claude runs in Bash. These are enforced by Claude Code, not left to Claude's judgement. `CLAUDE.md` gives Claude the project's context, and `.claude/rules/project-rules.md` gives it the same rules as instructions.

### What the sandbox is, and why

The sandbox is an operating-system feature (on Linux, `bwrap`, bubblewrap) that Claude Code wraps around each Bash command Claude runs. The kernel limits which files the command, and every program it starts, can read or write, so Python, `grep` and `xargs` are covered as well as `cat`.

The permission rules in `.claude/settings.json` govern only Claude's own file tools. Bash reaches the same files by other routes (`cat`, `python -c`, `grep -r`), so without the sandbox a deny rule on `private/` would cover one tool and leave Bash open. The sandbox applies the same rules to Bash and enforces them in the operating system, not through Claude's willingness to follow instructions. Parsing Bash commands to guess which files they touch is fragile (`env cat` defeats it), so the template does not try. This matters because anything Claude reads is sent to the model provider.

What it does not do:

- It does not stop data leaving over the network: `allowedDomains` is `*`, so that Claude can read websites. It guards against mistakes and against Claude working round a rule, not against a determined attacker.
- It has the [known gaps](#known-gaps) below.
- It can be switched off. The `/sandbox` menu offers a "No Sandbox" mode, and `failIfUnavailable` covers only a missing dependency, so check that `/sandbox` shows it on before relying on it.

What it costs:

- A one-off setup of the [dependencies](#dependencies).
- A session inside the sandbox cannot start another Claude session, so scripts that do (such as test runners) must be run from an ordinary terminal.
- Inside a Claude session, files the sandbox protects or hides appear as empty character devices, so `ls -l` and `git status` can look odd there. Outside Claude they are normal.
- Switching git branches inside Claude fails when `.claude/settings.json` differs between them. Switch from an ordinary terminal.
- Commands that need your home directory, or setuid programs, can fail (see [running R in a container](#running-r-in-a-container)).
- The per-command overhead on a large `private/` tree has not been measured.

### Getting started

1. Install Claude Code and the sandbox's dependencies (see [Dependencies](#dependencies)).
2. Start `claude` at the project root.
3. Type `/status` to check that the project's settings are loaded, and `/sandbox` to check that the sandbox is on.
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
│   ├── settings.json             permissions and sandbox; enforced, not advice
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

`permissions` governs the Read tool and `sandbox.filesystem` governs Bash. Every `permissions.deny` rule is also copied into the sandbox, but ask rules and `!` carve-outs are not. So a path denied to both tools needs one rule, and a path that asks in the Read tool needs a second rule for Bash.

#### Per directory

| Path                                         | Read tool | Bash: names                                 | Bash: contents                                    | Set by                                           |
| :------------------------------------------- | :-------- | :------------------------------------------ | :------------------------------------------------ | :----------------------------------------------- |
| `private/`, files with an extension          | Denied    | Listed                                      | Denied                                            | `permissions.deny` (copied to the sandbox)       |
| `private/`, files with no extension          | Ask       | Listed                                      | Readable (known gap)                              | `permissions.ask`                                |
| `private/` READMEs, at any depth             | Read; ask | Listed                                      | Readable                                          | `!` carve-outs; `sandbox.filesystem.allowRead`   |
| `private/` `.gitignore` files                | Read; ask | Listed                                      | Readable, so git can apply them                   | `!` carve-outs; `sandbox.filesystem.allowRead`   |
| `inputs/`, files with an extension           | Denied    | Listed, including inside linked directories | Denied                                            | `permissions.deny` (copied to the sandbox)       |
| `inputs/`, files and links with no extension | Ask       | Listed                                      | Readable, unless the target is denied (known gap) | `permissions.ask`                                |
| `outputs/`                                   | Ask       | Listed                                      | Denied, except files with no extension            | `permissions.ask`; `sandbox.filesystem.denyRead` |
| Listed formats, anywhere                     | Denied    | Listed                                      | Denied                                            | `permissions.deny` (copied to the sandbox)       |

"Ask" means Claude asks each time; "Yes, and don't ask again" does not stop it. Commands in the sandbox can write only inside the start directory and the temporary directory, and never to `.claude/` settings. Claude Code always asks before its Write or Edit tool changes a settings file.

When something is denied, the Read tool returns an error naming the setting and Bash prints `Permission denied`. A subagent receives the denial itself, so it reaches you only if the subagent's summary mentions it.

#### Settings explained

JSON has no comments, so this table explains the keys and rules used in `.claude/settings.json`.

| Key or rule                                       | What it does                                                                                                                                                                                                                                                 |
| :------------------------------------------------ | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `permissions.deny`                                | Never allowed. A deny in any settings file wins over any allow or ask                                                                                                                                                                                        |
| `permissions.ask`                                 | Claude asks each time. "Yes, and don't ask again" does not override it                                                                                                                                                                                       |
| `permissions.allow`                               | Allowed without asking                                                                                                                                                                                                                                       |
| `permissions.blockReadsOutsideWorkingDirectories` | The file tools refuse anything outside the start directory, including `~/.claude`. Bash cannot read your home directory, except the parts of `~/.claude` that Claude Code needs, or `/home`, `/mnt` and the like; the rest of the file system stays readable |
| `Read(<path>)`                                    | The Read tool, `@`-mentions and the editor's open file. Deny rules, but not ask rules, are also passed to the sandbox, which blocks the file for Bash                                                                                                        |
| `Edit(<path>)`                                    | The Edit and Write tools                                                                                                                                                                                                                                     |
| `Bash(<command> *)`                               | Bash commands by prefix. Easy to get round (`env cat`), so not used for data                                                                                                                                                                                 |
| `WebFetch(domain:<host>)`                         | Web pages Claude fetches                                                                                                                                                                                                                                     |
| `!<pattern>`                                      | Carves paths out of the rules listed before it, in the same list. Write it without `./`                                                                                                                                                                      |
| Path forms in `Read(...)`                         | `data/x` or `./data/x`: from the start directory; `/x`: from the project root; `//x`: absolute; `~/x`: home; `*.x`: any depth. `*` stays within one directory, `**` crosses them                                                                             |
| `sandbox.filesystem.denyRead` / `allowRead`       | What Bash, and every program it starts, can read. Paths: `data/x` or `./data/x` from the project root; `/x` absolute (not project-relative, unlike `Read`); `~/x` home                                                                                       |
| `sandbox.filesystem.allowWrite`                   | Extra places Bash may write. Not used                                                                                                                                                                                                                        |
| `sandbox.network.allowedDomains`                  | Where Bash may connect. `*` is everywhere                                                                                                                                                                                                                    |

#### File types

The data formats denied everywhere are a hand-curated list of extensions, in lowercase, sorted by extension in `deny`. Formats that are often compressed are denied with any further suffix too (`Read(**/*.fastq.*)` covers `x.fastq.gz` and its indexes), without denying compressed files in general. It is not binary detection: a format missing from the list is readable outside `private/` and `inputs/`, so add new formats by hand.

Matching is case-sensitive. Add each case variant you need (`Read(**/*.RDS)`) as its own line beside the lowercase rule; brace lists such as `*.{rds,RDS}` do not work.

#### Known gaps

- Files with no extension in `private/`, `inputs/` and `outputs/` are readable from Bash.
- A link in `inputs/` whose own name has no extension is readable from Bash if its target is outside a `private/` directory. Keep the extension when making a link.
- A directory in `private/` with a dot in its name is hidden whole from Bash, names included.
- Claude sees Claude Code's own denial text, not a custom message.

### Analysis-specific settings

#### Adding a stricter rule for one analysis

An extra deny or ask for one analysis goes in the root `.claude/settings.json`, written with the analysis's path. An analysis's `CLAUDE.md`, rules, skills and subagents add instructions, not permissions.

#### An analysis's own settings file

To loosen a rule for one analysis, for example to let Claude read one file type there, write `working/<analysis>/.claude/settings.json` and start Claude there (or `/cd` there). It replaces the project's file rather than extending it, so it is written for the analysis alone:

- **Nothing above the analysis is visible.** `blockReadsOutsideWorkingDirectories` makes the Read tool refuse any path outside the analysis. `denyRead: ["../.."]` hides the project root, and everything in it but the analysis, from Bash.
- **Outputs are asked for by type.** List the extensions the analysis writes that Claude should not read unasked, once in `ask` and once in `denyRead`. Other outputs are read freely.
- **The format list is copied** from the project's `.claude/settings.json`, in the same order. It goes stale when that changes, so diff the two after a template update.

```json
{
	"$schema": "https://json.schemastore.org/claude-code-settings.json",
	"permissions": {
		"blockReadsOutsideWorkingDirectories": true,
		"deny": [
			"Read(inputs/**/*.*)",
			"Read(**/*.bam)",
			"Read(**/*.fastq)",
			"Read(**/*.fastq.*)"
		],
		"ask": [
			"Read(inputs/**/*)",
			"Read(outputs/**/*.csv)",
			"Read(outputs/**/*.tsv)"
		]
	},
	"sandbox": {
		"enabled": true,
		"failIfUnavailable": true,
		"allowUnsandboxedCommands": false,
		"filesystem": {
			"denyRead": [
				"../..",
				"outputs/**/*.csv",
				"outputs/**/*.tsv"
			]
		},
		"network": {
			"allowedDomains": ["*"]
		}
	}
}
```

The format rules are shortened here: paste the full list from the project's file in place of the three format lines.

Sorry, there is a manual step. The `denyRead` path is relative and depends on the analysis's depth: `../..` for `working/<analysis>`, `../../..` one level deeper. No setting means "the project root", and an absolute path breaks when the project is moved or cloned. Too short, the path fails open; too long, it also hides the directory holding the project. Any of these, run from inside the analysis, prints it:

```bash
realpath --relative-to=. "$(git rev-parse --show-toplevel)"
pwd -P | cut --fields <n>- --delim / | awk --assign RS=/ --assign ORS=/ '{print ".."}' | sed 's/.$//'
realpath --relative-to=. /path/to/project
```

- The first needs the project to be a git repository, and the analysis not to be a repository of its own (it would print `.`).
- The second needs no git. `<n>` is the number of `/` in the project root's physical path plus two. Bash's `pwd` takes no long options, hence `-P`.
- The third needs only the project's path.

Update the path if the analysis moves to another depth. To check it, start Claude in the analysis and ask it to `cat` the project's root `README.md` in Bash: it should report no such file.

What an analysis session can see: your `CLAUDE.md`, rules, skills and plugins load as in the project. The block changes two things:

- **Bash** cannot see your home directory, except the parts of `~/.claude` that Claude Code exposes, read-only. So `~/.bashrc`, `~/bin`, `~/R` and a conda under `~` are invisible to Bash there; `/nemo` is visible.
- **The Read tool** refuses files under `~/.claude`, which matters when a skill tells Claude to read one of its supporting files.

`additionalDirectories` in the analysis's settings is ignored until you have accepted the trust prompt there once.

### Parallel sessions

All of these use the project's settings when started at the root:

- **CLI:** `claude agents` opens agent view, listing every background session across projects and showing which need input. Type a prompt to start a session in that directory, or `@<repo>` for a repository one level below. `claude --bg "<prompt>"` starts one from a shell; `/bg` moves a running session into agent view. Agent view is a research preview.
- **Extension:** Command Palette, "Claude Code: Open in New Tab", once per conversation.

> [!WARNING]
> Many sessions at once in one project occasionally fail a Bash command with `bwrap: Can't find source path …/.claude/settings.local.json`. It fails closed: the command does not run. Run it again.

### Dependencies

- Claude Code 2.1.295 or later.
- `bwrap` and `socat` on `PATH`, from the system or from `environments/conda/claude-sandbox.yaml`. With the conda environment, activate it before starting `claude`.

```bash
conda env create --file environments/conda/claude-sandbox.yaml
conda activate claude-sandbox
```

Check with `/sandbox` in a session. Without them, Claude Code refuses to start in the project (`failIfUnavailable`).

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
