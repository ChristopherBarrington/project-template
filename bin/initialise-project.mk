
#
# makefile to initialise a project directory
#

# TODO: make clean- targets more generic, using clean-% perhaps
# TODO: creating targets should depend on clean- targets
# TODO: stop tracking REAMDME (etc) once created to avoid updating the template project repository
# TODO: add remotes for push and pull to different repositories (template and analysis)

## ---- make configuration

.PHONY   : clean clean-babs-stp clean-share-www clean-share-geo clean-share-outputs clean-active-projects-link
SHELL    := /bin/bash
.ONESHELL:
.SILENT  :

## ---- variables with defaults that can be overridden by cli arguments, e.g. `make babs-stp project_hash=abc123`

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
babs_inputs_path     ?= $(babs_root_path)/inputs
babs_outputs_path    ?= $(babs_root_path)/outputs
babs_www_path        ?= $(babs_root_path)/www

## ---- default target if no target specified

default:
	echo "[ERROR] no target(s) specified. Please specify a target"

## ---- babs-stp repository submodule

babs_stp_submodule_path = docs/babs-stp
babs-stp: $(babs_stp_submodule_path)

$(babs_stp_submodule_path):
	echo "[INFO] adding BABS-STP submodule from hash: $(project_hash)"
	git submodule add --quiet --depth 1 git@github.com:babs-stp/$(project_hash).git $@ \
	&& (cd $_ && git sparse-checkout set --no-cone /.babs babs/docs/) \
	&& git commit --quiet --all --message "added BABS-STP submodule from hash: $(project_hash)"

clean-babs-stp:
	if [[ -d "$(babs_stp_submodule_path)" ]]; then
		echo "[INFO] removing BABS-STP submodule";
		git submodule deinit --quiet --force $(babs_stp_submodule_path)
		git rm --quiet --force $(babs_stp_submodule_path)
		git commit --quiet --all --message "removed BABS-STP submodule";
	else
		echo "[WARN] BABS-STP submodule does not exist, skipping removal";
	fi

## ---- resources directory

# -- ChristopherBarrington/babs-project repository submodule

babs_project_submodule_path = resources/github/ChristopherBarrington/babs-project
babs-project: $(babs_project_submodule_path)

$(babs_project_submodule_path):
	echo "[INFO] adding ChristopherBarrington/babs-project submodule"
	git submodule add --quiet --depth 1 git@github.com:ChristopherBarrington/babs-project.git $@ \
	&& (cd $@ && git sparse-checkout set --no-cone /.github) \
	&& git commit --quiet --all --message "added $@"
# 	&& rm --recursive --force .github \
# 	&& ln --symbolic resources/github/ChristopherBarrington/babs-project/.github

clean-babs-project:
	echo "[INFO] removing ChristopherBarrington/babs-project submodule"
	git submodule deinit --quiet --force $(babs_project_submodule_path) \
	&& git rm --quiet --force $(babs_project_submodule_path) \
	&& git commit --quiet --all --message "removed ChristopherBarrington/babs-project submodule"


## ---- share directory 

# -- make a shared directory for www outputs: html and shiny

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

# -- make a shared directory for geo outputs

share_geo_path = share/geo

$(share_geo_path):
	echo "[INFO] making shared geo directory"
	mkdir --parents $@

clean-$(share_geo_path):
	echo "[INFO] removing $(share_geo_path) directory"
	rm --recursive --force $(share_geo_path)

# -- make a link to the babs outputs directory

share_outputs_path = share/outputs

$(share_outputs_path):
	echo "[INFO] linking to babs outputs directory"
	mkdir --parents $(dir $@) \
	&& ln --symbolic --force --no-dereference $(babs_outputs_path)/$(lab)/$(scientist)/$(user_long)/$(project)/ $@

clean-$(share_outputs_path):
	echo "[INFO] removing $(share_outputs_path) link"
	rm --force $(share_outputs_path)

## ---- make a link to the active-projects directory

active_projects_link_path = $(active_projects_path)/$(active_project_name)
active-projects-link: $(active_projects_link_path)

$(active_projects_link_path):
	echo "[INFO] linking to $(active_project_name) in active-projects directory"
	mkdir --parents $(dir $@) \
	&& ln --symbolic --force --no-dereference $(project_path) $@

clean-active-projects-link:
	echo "[INFO] removing active-projects link"
	rm --force $(active_projects_link_path)

## ---- data directory

# -- make a link to babs inputs

data_inputs_path = data/inputs

$(data_inputs_path):
	echo "[INFO] linking to babs inputs directory"
	mkdir --parents data \
	&& ln --symbolic --force --no-dereference $(babs_inputs_path)/$(lab)/$(user_long)/$(scientist)/$(project)/ $@

clean-$(data_inputs_path):
	echo "[INFO] removing $(data_inputs_path) link"
	rm --force $(data_inputs_path)

# -- link to genomics' primary_data

data_primary_data_path = data/primary_data
babs_manifest_path = $(babs_stp_submodule_path)/.babs

$(data_primary_data_path):
	if [[ -f "$(babs_manifest_path)" ]]; then
		project_lims="$$(yq eval '.[0].Lims' "$(babs_manifest_path)" | sed 's/asf-//g')"
	else
		project_lims=undef
	fi
	if [[ "$$project_lims" == "undef" ]]; then
		echo "[WARN] project_lims=undef; skipping $@ link"
		exit 0
	fi
	echo "[INFO] linking to babs inputs sequencing data directory ($$project_lims)"
	mkdir --parents data
	ln --symbolic --force --no-dereference "$(babs_inputs_path)/sequencing/data/$(lab)/$(scientist)/$$project_lims/primary_data/" "$(data_primary_data_path)"

clean-$(data_primary_data_path):
	echo "[INFO] removing $(data_primary_data_path) link"
	rm --force $(data_primary_data_path)

## ---- configure git repository

# -- add remotes
#    allow updates via pull from project template repository
#    allow push/pull from analysis repository

## --- define aliases/helpers for typical use cases

# -- alias to make a (typical) babs/genomics project

babs: \
	babs-stp \
	data/inputs \
	data/primary_data \
	share/geo \
	share/outputs \
	active-projects-link

non-genomics: \
	data/inputs \
	share/outputs \
	active-projects-link

# -- aliases to clean up after all targets

clean-data: \
	clean-$(data_inputs_path) \
	clean-$(data_primary_data_path)

clean-share: \
	clean-$(share_www_path) \
	clean-$(share_geo_path) \
	clean-$(share_outputs_path)

clean: \
	clean-babs-stp \
	clean-data \
	clean-share \
	clean-active-projects-link

# -- helper target to print variable values, e.g. `make print-project_hash`

print-%:
	echo "$($*)"
