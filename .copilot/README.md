# .copilot/

The GitHub Copilot configuration directory can contain the following subdirectories to organise Copilot customisations:

| Location                  | Purpose                                                                                    |
| :------------------------ | :----------------------------------------------------------------------------------------- |
| `agents/`                 | Custom sub-agents with specific personas, tool access, and instructions for focused tasks  |
| `skills/`                 | Packages of domain knowledge and instructions that Copilot loads when relevant to a task   |
| `commands/`               | Reusable slash commands that can be invoked in chat to run predefined prompts or workflows |
| `memory/`                 | Persistent facts about the repository that Copilot can refer to across sessions            |
| `copilot-instructions.md` | Custom instructions for GitHub Copilot with project context                                |

Each subdirectory contains Markdown files that Copilot discovers and uses automatically based on context.

## AI Model Tiers

This project supports multiple AI models through GitHub Copilot, each suited to different tasks and workloads.

### Quick Comparison

| Model         | Best For                                        |
| :------------ | :---------------------------------------------- |
| Claude Haiku  | Quick tasks, autocomplete, simple Q&A           |
| Claude Sonnet | Day-to-day coding, code review, documentation   |
| Claude Opus   | Complex reasoning, architecture, high-stakes    |
| GPT           | Complex reasoning, multi-step problems          |
| GPT Mini      | Routine tasks, quick iterations, cost-effective |
| GPT Codex     | Code generation, legacy code, specialised tasks |

### Claude Models (Anthropic)

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

#### [Opus](https://www.anthropic.com/claude/opus) — most capable

Best for: difficult, high-stakes, or deeply reasoned tasks where quality matters most.

- Highest reasoning capability across the Claude family
- Best at long-context understanding, complex analysis, and nuanced writing
- Slower and more resource-intensive than Haiku or Sonnet
- Worth using for architecture decisions, complex debugging, or thorough code review; overkill for routine tasks

### OpenAI Models

#### GPT — most capable

Best for: complex reasoning, multi-step problem-solving, and highest quality outputs.

- Advanced reasoning and problem-solving capabilities
- Excellent for sophisticated code generation and architectural decisions
- Higher latency and resource usage

#### GPT Mini — fast and efficient

Best for: quick iterations, routine tasks, and cost-effective inference.

- Faster response times than larger models
- Good balance of capability and speed
- Suitable for autocomplete, simple queries, and boilerplate generation

#### GPT Codex — specialised code generation

Best for: code-specific tasks including generation, completion, and documentation.

- Optimised for code understanding and generation
- Useful for legacy code maintenance and specialised programming tasks
- Good for generating code snippets and documentation

## References

- [Supported models in GitHub Copilot](https://docs.github.com/en/copilot/reference/ai-models/supported-models)
