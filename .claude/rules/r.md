# R deliverable scripts

Applies to deliverable scripts only (see `r.md`), in addition to the rules there.

Before writing a deliverable script, read the matching template in the compendium, then write the script from it, keeping its structure and boilerplate. The template takes precedence over this file. Look first at `resources/github/christopherbarrington/compendium/templates/` (ignoring case). Only if that is missing, search for a `compendium/templates` directory at most five levels below `resources/`, without descending further. If none is found, tell the user and continue with the rules in `r.md` rather than writing the structure from memory. State which template was used.

- Match the template's conventions in any code you add.
- Use the tidyverse (`dplyr`, `readr`, `fs`) for data handling and I/O, and `qs2` for serialisation.
