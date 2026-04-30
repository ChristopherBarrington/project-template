
##
## DESCRIPTION:
##   Manages data directory symbolic links within the project, including links to
##   external input data on the BABS infrastructure and primary sequencing data
##   from genomics platforms.
##
## USAGE:
##   make <target> [variable=value ...]
##
## CONFIGURABLE VARIABLES:
##   user_long     - User long name for resource paths (default: firstname.lastname)
##   user_short    - User short name for resource paths (default: lastnaf)
##   lab           - Lab name, derived from project path (default: auto-detected)
##   scientist     - Scientist name, derived from project path (default: auto-detected)
##   project       - Project name, derived from project path (default: auto-detected)
##   project_lims  - Project LIMS identifier for sequencing data (required for primary_data link)
##
## TARGETS:
##   default                    - Show error message and usage help
##   help                       - Print this documentation
##   add                        - Create all data directory symbolic links
##   remove                     - Remove all data directory symbolic links
##   (remove-)data/inputs       - add (or remove) the inputs data link
##   (remove-)data/primary_data - add (or remove) the primary_data link
##   status                     - Display data directory status and project configuration
##   print-<var>                - Print the value of any variable
##
## EXAMPLES:
##   make add
##   make add user_short=myuser user_long=my.name
##   make remove
##   make status
##   make print-project-lims
##

## ---- make configuration

.PHONY   : default help remove-data/inputs remove-data/primary_data add remove status print-%
SHELL    := /bin/bash
.ONESHELL:
.SILENT  :

## ---- variables with defaults that can be overridden by cli arguments

user_long  ?= firstname.lastname
user_short ?= lastnaf

project_path ?= $(shell git rev-parse --show-toplevel 2>/dev/null || pwd --physical)
lab          ?= $(shell cut --fields 8 --delimiter / <<< $(project_path))
scientist    ?= $(shell cut --fields 9 --delimiter / <<< $(project_path))
project      ?= $(shell cut --fields 10 --delimiter / <<< $(project_path))

babs_root_path   = /nemo/stp/babs
babs_inputs_path = $(babs_root_path)/inputs

## ---- default target if no target specified

default:
	echo "[ERROR] no target(s) specified. Please specify a target. Use 'make help' for options"
	exit 1

## ---- print documentation

help:
	sed --silent --expression '1,/^$$/p' $(MAKEFILE_LIST)

## ---- make a link to babs inputs

data_inputs_path = data/inputs

$(data_inputs_path):
	echo '[INFO] linking to babs inputs directory'
	mkdir --parents $(dir $@) \
	&& ln --symbolic --force --no-dereference $(babs_inputs_path)/$(lab)/$(user_long)/$(scientist)/$(project)/ $@

remove-$(data_inputs_path):
	echo '[INFO] removing $(data_inputs_path) link'
	rm --force $(data_inputs_path)

## ---- link to genomics' primary_data

data_primary_data_path = data/primary_data
babs_manifest_path = $(babs_stp_submodule_path)/.babs
project_lims ?= $(shell if [[ -f "$(babs_manifest_path)" ]] && command -v yq > /dev/null 2>&1; then yq eval '.[0].Lims' $(babs_manifest_path) | sed 's/asf-//g'; else echo 'undef'; fi)

$(data_primary_data_path):
	if [[ "$(project_lims)" == "undef" ]]; then
		echo '[WARN] project_lims=undef; skipping $@ link'
		echo '[warn] this may be becuase `yq` is not available or that the .babs file is missing'
		exit 0
	fi
	echo '[INFO] linking to babs inputs sequencing data directory ($(project_lims))'
	mkdir --parents $(dir $@) \
	&& ln --symbolic --force --no-dereference $(babs_inputs_path)/sequencing/data/$(lab)/$(scientist)/$(project_lims)/primary_data/ $(data_primary_data_path)

remove-$(data_primary_data_path):
	echo '[INFO] removing $(data_primary_data_path) link'
	rm --force $(data_primary_data_path)

## ---- add all data directories

add: \
	$(data_inputs_path) \
	$(data_primary_data_path)

## ---- remove data from project

remove: \
	remove-$(data_inputs_path) \
	remove-$(data_primary_data_path)

## ---- provide a status of targets

status:
	echo "[INFO] checking data directory status:"
	echo ""
	echo "Project configuration:"
	echo "  lab:              $(lab)"
	echo "  scientist:        $(scientist)"
	echo "  project:          $(project)"
	echo "  project_lims:     $(project_lims)"
	echo "  user_short:       $(user_short)"
	echo "  user_long:        $(user_long)"
	echo ""
	echo "data directory status:"
	for path in $(data_inputs_path) $(data_primary_data_path); do
		if [[ -e "$$path" ]]; then
			if [[ -L "$$path" ]]; then
				target=$$(readlink "$$path")
				echo "  ✓ $$path -> $$target"
			else
				echo "  ✓ $$path (directory)"
			fi
		else
			echo "  ✗ $$path (missing)"
		fi
	done

# -- helper target to print variable values, e.g. `make print-foo`

print-%:
	echo $($*)
