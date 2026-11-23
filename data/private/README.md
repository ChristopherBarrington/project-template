# data/private/

Data that Claude must not read, for example unpublished data from the collaborator, sample sheets with identifiable information, or anything under a data access agreement.

Claude Code is denied reading the files in any directory named `private/`, at any depth, except `README.md` files; it can still list their names. The rules are in `.claude/settings.json` and are described in the "Claude Code" section of `.github/ABOUT.md`.

For code to be written and tested against data like this without reading it, keep a small stand-in with the same structure in `data/synthetic/`.

Record the source, date received and a checksum manifest for each set of files, as described in `data/README.md`.
