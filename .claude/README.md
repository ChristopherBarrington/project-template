# .claude

This directory contains configuration files for [Claude](https://www.anthropic.com/claude), Anthropic's AI assistant, used via GitHub Copilot Business.

## Contents

| Path                                    | Purpose                                                    |
|-----------------------------------------|------------------------------------------------------------|
| `agents/groundskeeper-willy.agent.md`   | Sub-agent for initialising and cleaning project structure  |

A `CLAUDE.md` file in the **project root** provides Claude with persistent baseline context loaded at the start of every session.

## Directory structure

The `.claude` directory can contain the following subdirectories. Only those relevant to the project need to be present.

| Location          | Purpose                                                                                       |
|-------------------|-----------------------------------------------------------------------------------------------|
| `../CLAUDE.md`    | Always-loaded baseline context: project overview, conventions, and key commands               |
| `agents/`         | Custom sub-agents with specific personas, tool access, and instructions for focused tasks     |
| `skills/`         | Packages of domain knowledge and instructions that Claude loads when relevant to a task       |
| `commands/`       | Reusable slash commands that can be invoked in chat to run predefined prompts or workflows    |
| `memory/`         | Persistent facts about the repository that Claude can refer to across sessions                |

Each subdirectory contains Markdown files. Claude discovers and uses them automatically based on the task context.
See the [Claude configuration overview](https://docs.anthropic.com/en/docs/claude-code/memory) for full details.

## Claude model tiers

Anthropic's Claude models come in three tiers, each suited to different tasks.

### [Haiku](https://www.anthropic.com/claude/haiku) — fast and lightweight

Best for: quick, repetitive, or straightforward tasks where speed matters more than depth.

- Very fast response times
- Good for summarisation, simple Q&A, autocomplete, and boilerplate generation
- Lower reasoning depth than larger models
- Less reliable on complex multi-step problems or nuanced instructions

### [Sonnet](https://www.anthropic.com/claude/sonnet) — balanced

Best for: general coding assistance, code review, explanation, documentation, and most day-to-day tasks.

- Strong reasoning and instruction-following
- Good balance of speed and capability
- Handles multi-step problems, refactoring, and debugging well
- The default choice for most tasks in this project

### [Opus](https://www.anthropic.com/claude/opus) — most capable

Best for: difficult, high-stakes, or deeply reasoned tasks where quality matters most.

- Highest reasoning capability across the Claude family
- Best at long-context understanding, complex analysis, and nuanced writing
- Slower and more resource-intensive than Haiku or Sonnet
- Worth using for architecture decisions, complex debugging, or thorough code review; overkill for routine tasks

## References

- [Supported models in GitHub Copilot](https://docs.github.com/en/copilot/reference/ai-models/supported-models)
- [Claude agents documentation](https://docs.anthropic.com/en/docs/claude-code/sub-agents)
- [Claude configuration overview](https://docs.anthropic.com/en/docs/claude-code/memory)
