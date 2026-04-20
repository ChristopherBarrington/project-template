
.PHONY: clean clean-babs-stp clean-share-www clean-share-geo clean-share-outputs clean-active-projects-link
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

clean-babs-stp:
	echo "[WARN] removing BABS-STP submodule"
	rm --recursive --force $(babs_stp_submodule_path)

# -- make a shared directory for www outputs: html and shiny
share_www_path = share/www
$(share_www_path):
	echo "[INFO] making shared www directory"
	mkdir --parents $(share_www_path)/{html,shiny} \
	&& ln --symbolic --force --no-dereference $(babs_www_path)/html/internal/users/$(user_short)/dev/$(lab)/$(scientist)/$(project)/       $(share_www_path)/html/dev \
	&& ln --symbolic --force --no-dereference $(babs_www_path)/html/internal/users/$(user_short)/projects/$(lab)/$(scientist)/$(project)/  $(share_www_path)/html/projects \
	&& ln --symbolic --force --no-dereference $(babs_www_path)/shiny/internal/users/$(user_short)/dev/$(lab)/$(scientist)/$(project)/      $(share_www_path)/shiny/dev \
	&& ln --symbolic --force --no-dereference $(babs_www_path)/shiny/internal/users/$(user_short)/projects/$(lab)/$(scientist)/$(project)/ $(share_www_path)/shiny/projects

clean-$(share_www_path):
	echo "[WARN] removing shared www directory"
	rm --recursive --force $(share_www_path)

# -- make a shared directory for geo outputs
share_geo_path = share/geo
$(share_geo_path):
	echo "[INFO] making shared geo directory"
	mkdir --parents $(share_geo_path)

clean-$(share_geo_path):
	echo "[WARN] removing shared geo directory"
	rm --recursive --force $(share_geo_path)

# -- make a link to the babs outputs directory
share_outputs_path = share/outputs
$(share_outputs_path):
	echo "[INFO] linking to babs outputs directory"
	mkdir --parents share \
	&& ln --symbolic --force --no-dereference $(babs_outputs_path)/$(lab)/$(scientist)/$(user_long)/$(project)/ $(share_outputs_path)

clean-$(share_outputs_path):
	echo "[WARN] removing shared outputs link"
	rm --force $(share_outputs_path)

# -- make a link to the active-projects directory
active_projects_link_path = $(active_projects_path)/$(active_project_name)
active-projects-link: $(active_projects_link_path)
$(active_projects_link_path):
	echo "[INFO] linking to $(active_project_name) in active-projects directory"
	mkdir --parents $(dir $(active_projects_link_path)) \
	&& rm --force $(active_projects_link_path) \

clean-active-projects-link:
	echo "[WARN] removing active-projects link"
	rm --force $(active_projects_link_path)

# --- alias to make a (typical) babs/genomics project
babs: \
	share/www \
	share/geo \
	share/outputs \
	active-projects-link \
	babs-stp

# -- alias to clean up after all targets
clean: \
	clean-babs-stp \
	clean-$(share_www_path) \
	clean-$(share_geo_path) \
	clean-$(share_outputs_path) \
	clean-active-projects-link
