#! /usr/bin/bash

#
# fill the data and analyses tables of the project README from the "summary" in the frontmatter of README.md files
#
# output file: README_PATH, edited in place between the marker pairs
#  <!-- BEGIN data-table --> and <!-- END data-table -->
#  <!-- BEGIN analyses-table --> and <!-- END analyses-table -->
#
# Run from the project root. A README.md in data/ or working/ is listed when its frontmatter has a one-line summary.
# Directories named inputs, outputs, logs, renv or scratch, and any starting with _, are skipped.
# The script stops without changing the README if a marker is missing, repeated or out of order.
#
# environment variables:
#  - DRY_RUN:     (optional) if "true", print the tables and leave the README unchanged (default: false)
#  - README_PATH: (optional) README to update (default: README.md)
#
# positional arguments:
#  - none
#

set -e            # exit immediately if any command returns a non-zero exit status
set -o pipefail   # return the exit status of the last command in the pipeline that failed
set -u            # treat unset variables as an error and exit immediately

cat <<- RUNTIME_INFORMATION
# --- $(basename "$0") ---
# `date`
# `hostname`
RUNTIME_INFORMATION

# handle variables, allowing for a list of new varibles to be printed
get_variables() { compgen -v | tr ' ' '\n' | sort; }
pre_existing_variables=$(get_variables)

## ---- define-variables

# environment variables
dry_run=${DRY_RUN:-false}
readme_path=${README_PATH:-README.md}

# positional arguments
# none

# static variables
work_path=$(mktemp --directory)
trap 'rm --recursive --force "$work_path"' EXIT

## ---- print-runtime-information

comm -13 \
  <(echo "$pre_existing_variables") \
  <(get_variables) \
| grep --invert-match '^pre_existing_variables$' \
| while read var; do echo "$var=${!var}"; done

## ---- define-functions

# print "directory<TAB>summary" for each README.md under a path that has a summary in its frontmatter
list_summaries () {
	find "$1" \
		\( -name inputs -o -name outputs -o -name logs -o -name renv -o -name scratch -o -name '_*' \) -prune \
		-o -type f -name README.md -print \
	| sort \
	| while read -r readme; do
		summary=$(awk '
			NR == 1 && $0 != "---" { exit }
			NR > 1 && $0 == "---" { exit }
			/^summary:/ {
				sub(/^summary:[[:space:]]*/, "")
				gsub(/^["'\'']|["'\'']$/, "")
				print
				exit
			}
		' "$readme")
		if [ -n "$summary" ]; then
			printf '%s\t%s\n' "$(dirname "$readme")/" "$summary"
		fi
	done
}

# read "directory<TAB>summary" lines and print a table with a blank line either side
make_table () {
	awk --field-separator '\t' --assign path_header="$1" --assign summary_header="$2" '
		{
			path[NR] = "`" $1 "`"
			summary[NR] = $2
			gsub(/\|/, "\\|", summary[NR])
		}
		END {
			path_width = length(path_header)
			summary_width = length(summary_header)
			for (i = 1; i <= NR; i++) {
				if (length(path[i]) > path_width) path_width = length(path[i])
				if (length(summary[i]) > summary_width) summary_width = length(summary[i])
			}
			path_rule = ":"
			for (i = 1; i < path_width; i++) path_rule = path_rule "-"
			summary_rule = ":"
			for (i = 1; i < summary_width; i++) summary_rule = summary_rule "-"
			print ""
			printf "| %-*s | %-*s |\n", path_width, path_header, summary_width, summary_header
			printf "| %s | %s |\n", path_rule, summary_rule
			for (i = 1; i <= NR; i++) printf "| %-*s | %-*s |\n", path_width, path[i], summary_width, summary[i]
			print ""
		}
	'
}

# stop unless the README has exactly one BEGIN line followed by exactly one END line for a marker name
check_markers () {
	begin="<!-- BEGIN $1 -->"
	end="<!-- END $1 -->"
	begin_lines=$(grep --line-number --fixed-strings --line-regexp "$begin" "$readme_path" | cut --delimiter : --fields 1 || true)
	end_lines=$(grep --line-number --fixed-strings --line-regexp "$end" "$readme_path" | cut --delimiter : --fields 1 || true)

	if [ "$(grep --count . <<< "$begin_lines")" -ne 1 ] || [ "$(grep --count . <<< "$end_lines")" -ne 1 ]; then
		echo "[ERROR] $readme_path needs exactly one '$begin' line and one '$end' line" >&2
		exit 1
	fi
	if [ "$begin_lines" -ge "$end_lines" ]; then
		echo "[ERROR] '$begin' must come before '$end' in $readme_path" >&2
		exit 1
	fi
}

# replace everything between a marker pair in the README with a table file
replace_block () {
	awk --assign begin="<!-- BEGIN $1 -->" --assign end="<!-- END $1 -->" --assign table_file="$2" '
		$0 == begin {
			print
			while ((getline line < table_file) > 0) print line
			close(table_file)
			skip = 1
			next
		}
		$0 == end { skip = 0 }
		!skip { print }
	' "$readme_path" > "$work_path/readme.new"

	# write into the existing file so that its permissions and any link are kept
	cat "$work_path/readme.new" > "$readme_path"
	echo "[UPDATE] $1 in $readme_path"
}

## ---- update-readme

list_summaries data \
| make_table Data Summary \
> "$work_path/data-table.md"

list_summaries working \
| make_table Analysis Purpose \
> "$work_path/analyses-table.md"

if [ "$dry_run" = true ]; then
	echo "[INFO] DRY_RUN is true: the README is unchanged"
	cat "$work_path/data-table.md" "$work_path/analyses-table.md"
	exit 0
fi

# check both marker pairs before changing anything
check_markers data-table
check_markers analyses-table

replace_block data-table "$work_path/data-table.md"
replace_block analyses-table "$work_path/analyses-table.md"
