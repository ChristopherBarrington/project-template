
.PHONY:
SHELL  := /bin/bash
.SILENT:

# -- variables with defaults that can be overridden by cli arguments, e.g. `make babs-stp project_hash=abc123`

user_long      ?= christopher.barrington
user_short     ?= barrinc
babs_root_path ?= /nemo/stp/babs

project_path ?= $(shell git rev-parse --show-toplevel)

lab          ?= $(shell cut --fields 8 --delimiter / <<< $(project_path))
scientist    ?= $(shell cut --fields 9 --delimiter / <<< $(project_path))
project      ?= $(shell cut --fields 10 --delimiter / <<< $(project_path))
project_hash ?= $(shell basename $(project_path))

active_project_name  ?= $(project)
active_projects_path ?= $(babs_root_path)/working/$(user_short)/active_projects
babs_outputs_path    ?= $(babs_root_path)/outputs
babs_www_path        ?= $(babs_root_path)/www

# -- default target if no target specified
default:
	echo "[ERROR] no target(s) specified. Please specify a target"

# -- make a submodule from the babs-stp repository
babs_stp_submodule_path = docs/babs-stp
babs-stp: $(babs_stp_submodule_path)
$(babs_stp_submodule_path):
	echo "[INFO] adding BABS-STP submodule from hash: $(project_hash)"
	mkdir --parents $(babs_stp_submodule_path)
# 	git submodule add --quiet --depth 1 git@github.com:babs-stp/$(project_hash).git $(babs_stp_submodule_path) \
# 	&& (cd $_ && git sparse-checkout set --no-cone /.babs babs/docs/) \
# 	&& git commit --quiet --all --message "added BABS-STP submodule from hash: $(project_hash)"

# -- make a shared directory for www outputs: html and shiny
share/www:
	echo "[INFO] making shared www directory"
	mkdir --parents share/www/{html,shiny} \
	&& ln --symbolic --force --no-dereference $(babs_www_path)/html/internal/users/$(user_short)/dev/$(lab)/$(scientist)/$(project)/ share/www/html/dev \
	&& ln --symbolic --force --no-dereference $(babs_www_path)/html/internal/users/$(user_short)/projects/$(lab)/$(scientist)/$(project)/ share/www/html/projects \
	&& ln --symbolic --force --no-dereference $(babs_www_path)/shiny/internal/users/$(user_short)/dev/$(lab)/$(scientist)/$(project)/ share/www/shiny/dev \
	&& ln --symbolic --force --no-dereference $(babs_www_path)/shiny/internal/users/$(user_short)/projects/$(lab)/$(scientist)/$(project)/ share/www/shiny/projects

# -- make a shared directory for geo outputs
share/geo:
	echo "[INFO] making shared geo directory"
	mkdir --parents share/geo

# -- make a link to the babs outputs directory
share/outputs:
	echo "[INFO] linking to babs outputs directory"
	mkdir --parents share \
	&& ln --symbolic --force --no-dereference $(babs_outputs_path)/$(lab)/$(scientist)/$(user_long)/$(project)/ share/outputs

# -- make a link to the active-projects directory
active_projects_link_path = $(active_projects_path)/$(active_project_name)
active-projects-link: $(active_projects_link_path)
$(active_projects_link_path):
	echo "[INFO] linking to $(active_project_name) in active-projects directory"
	mkdir --parents $(dir $(active_projects_link_path)) \
	&& rm --force $(active_projects_link_path) \
	&& ln --symbolic $(project_path) $(active_projects_link_path)

# --- alias to make a (typical) babs/genomics project
babs: share/www share/geo share/outputs active-projects-link babs-stp
