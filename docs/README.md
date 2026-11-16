# docs/

Documentation about the project and its biology: material that helps a reader understand _why_ the analysis is done, not _how_ it is run.

For example: papers, protocols, experimental design summaries, slides and PDFs shared by collaborators, and notes on the biological system.

Documentation for software or packages does not belong here; see `resources/`.

## Proposals and literature reviews

This is also a good place for the documents written before the project starts: the project proposal and a review of the literature. These can be produced as reports with Claude Science, and kept here they give agents working later in the project, for example in `working/`, the background, aims and prior work to build on.

Keep them as Markdown so that agents can read them, and record the date and the sources each one was written from.

| Path                             | Contents                                                    |
| :------------------------------- | :---------------------------------------------------------- |
| `proposal/proposal.md`           | The project proposal: the idea, before any data is analysed |
| `proposal/review.md`             | Its review, from `/ai-me:review-proposal`                   |
| `literature-review/<topic>.md`   | Reviews of the literature, with their sources               |

A proposal for an analysis of existing data is not kept here: it lives with the analysis in `working/`, and `/ai-me:plan-analysis` writes its `plan.md` beside it. ai-me is a Claude Code plugin in the compendium (`library/ai-me/`).

The project `README.md` gives a brief summary of the background and objectives, which is a preview of what is kept here.

The template documentation (creating and updating a project from the template) is in `.github/ABOUT.md`.
