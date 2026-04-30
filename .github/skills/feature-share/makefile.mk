##
## DESCRIPTION:
##   Manages shared resource links within the project, including symbolic links to
##   web servers (HTML and Shiny apps), GEO submission staging directories, and
##   project output directories on the BABS infrastructure.
##
## USAGE:
##   make <target> [variable=value ...]
##
## CONFIGURABLE VARIABLES:
##   user_long  - User long name for resource paths (default: christopher.barrington)
##   user_short - User short name for resource paths (default: barrinc)
##   lab        - Lab name, derived from project path (default: auto-detected)
##   scientist  - Scientist name, derived from project path (default: auto-detected)
##   project    - Project name, derived from project path (default: auto-detected)
##
## TARGETS:
##   default             - Show error message and usage help
##   help                - Print this documentation
##   add                 - Create all share directories and symbolic links
##   remove              - Remove all share directories and symbolic links
##   clean-share/www     - Remove the www share directory and its links
##   clean-share/geo     - Remove the geo share directory
##   clean-share/outputs - Remove the outputs share link
##   status              - Display share directory status and project configuration
##   verify              - Alias for status target
##   print-<var>         - Print the value of any variable
##
## EXAMPLES:
##   make add
##   make add user_short=myuser user_long=my.name
##   make remove
##   make status
##   make print-lab
##

## ---- make configuration

.PHONY   : default help clean-share/www clean-share/geo clean-share/outputs add remove verify status print-%
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

babs_root_path    = /nemo/stp/babs
babs_outputs_path = $(babs_root_path)/outputs
babs_www_path     = $(babs_root_path)/www

## ---- default target if no target specified

default:
	echo "[ERROR] no target(s) specified. Please specify a target. Use 'make help' for options"
	exit 1

## ---- print documentation

help:
	echo "$(shell sed -n '1,/^## ---- /p' $(MAKEFILE_LIST) | grep '^##')"

## ---- make a shared directory for www outputs: html and shiny

share_www_path = share/www

$(share_www_path):
	echo "[INFO] making shared www directory"
	mkdir --parents $@/{html,shiny} \
	&& ln --symbolic --force --no-dereference $(babs_www_path)/html/internal/users/$(user_short)/dev/$(lab)/$(scientist)/$(project)/       $@/html/dev \
	&& ln --symbolic --force --no-dereference $(babs_www_path)/html/internal/users/$(user_short)/projects/$(lab)/$(scientist)/$(project)/  $@/html/projects \
	&& ln --symbolic --force --no-dereference $(babs_www_path)/shiny/internal/users/$(user_short)/dev/$(lab)/$(scientist)/$(project)/      $@/shiny/dev \
	&& ln --symbolic --force --no-dereference $(babs_www_path)/shiny/internal/users/$(user_short)/projects/$(lab)/$(scientist)/$(project)/ $@/shiny/projects

clean-$(share_www_path):
	echo "[INFO] removing $(share_www_path) directory"
	rm --recursive --force $(share_www_path)

## ---- make a shared directory for geo outputs

share_geo_path = share/geo

$(share_geo_path):
	echo "[INFO] making shared geo directory"
	mkdir --parents $@

clean-$(share_geo_path):
	echo "[INFO] removing $(share_geo_path) directory"
	rm --recursive --force $(share_geo_path)

## ---- make a link to the babs outputs directory

share_outputs_path = share/outputs

$(share_outputs_path):
	echo "[INFO] linking to babs outputs directory"
	mkdir --parents $(dir $@) \
	&& ln --symbolic --force --no-dereference $(babs_outputs_path)/$(lab)/$(scientist)/$(user_long)/$(project)/ $@

clean-$(share_outputs_path):
	echo "[INFO] removing $(share_outputs_path) link"
	rm --force $(share_outputs_path)

## ---- add all share directories

add: \
	$(share_outputs_path) \
	$(share_geo_path) \
	$(share_www_path)

## ---- remove share from project

remove: \
	clean-$(share_outputs_path) \
	clean-$(share_geo_path) \
	clean-$(share_www_path)

## ---- provide a status of targets

verify: status

status:
	echo "[INFO] checking share directory status:"
	echo ""
	echo "Project configuration:"
	echo "  lab:              $(lab)"
	echo "  scientist:        $(scientist)"
	echo "  project:          $(project)"
	echo "  user_short:       $(user_short)"
	echo "  user_long:        $(user_long)"
	echo ""
	echo "share directory status:"
	for path in $(share_www_path) $(share_geo_path) $(share_outputs_path); do
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
