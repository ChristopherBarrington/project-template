##
## DESCRIPTION:
##   Manages git submodules as resources within the project, including adding,
##   removing, and symlinking submodule contents to the project root.
##
## USAGE:
##   make <target> [variable=value ...]
##
## CONFIGURABLE VARIABLES:
##   submodule_path_root - Base directory for submodule, for example resources/github (required)
##   repository          - Git(Hub) repository path, for example org/repo (required)
##   submodule_path      - Full submodule path (default: $(submodule_path_root)/$(repository))
##   targets             - Space-separated list of directories/files to symlink (required for add-symlinks)
##
## TARGETS:
##   add                    - Add the specified repository as a git submodule with depth 1
##   add-symlinks           - Create symbolic links for specified targets from submodule to project root
##   remove-symlinked-dirs  - Remove symlinked directories and restore from submodule
##   remove-symlinked-files - Remove symlinked files and restore from submodule
##   remove-submodule       - Deinitialize and remove the git submodule
##   remove-symlinks        - Remove all symlinked directories and files
##   remove                 - Complete cleanup: remove symlinks and submodule
##   status                 - Show status of submodules in the project
##   print-<var>            - Print the value of any variable
##
## EXAMPLES:
##   make add repository=org/repo submodule_path=path/to/submodule
##   make add-symlinks targets="dir1 dir2 file1" submodule_path=path/to/submodule
##   make remove repository=org/repo submodule_path=path/to/submodule
##   make print-submodule_path
##

## ---- make configuration

.PHONY   : default check-submodule-path-exists print-% add add-symlinks status remove-symlinked-dirs remove-symlinked-files remove-submodule remove-symlinks remove
SHELL    := /bin/bash
.ONESHELL:
.SILENT  :

## ---- variables with defaults that should be overridden by cli arguments

# helper function to check required variables
check-var = $(if $(value $(1)),,$(error $(1) must be set, for example: $(2)))

$(call check-var,submodule_path_root,path/to/directory)
$(call check-var,repository,org/repo)
repository_url ?= git@github.com:$(repository).git
submodule_path ?= $(submodule_path_root)/$(repository)

## ---- default target if no target specified

default:
	echo '[ERROR] no target(s) specified. Please specify a target'
	exit 1

## ---- print documentation

help:
	sed --silent --expression '1,/^$$/p' $(MAKEFILE_LIST)

## ---- check submodule path is set and exists

check-submodule-path-exists:
	[ -d $(submodule_path) ] || { echo '[ERROR] $(submodule_path) does not exist'; exit 1; }

## ---- add submodule to project

add: $(submodule_path)
$(submodule_path):
	echo '[INFO] adding $(repository) submodule'
	git submodule add --quiet --depth 1  --force $(repository_url) $(submodule_path)

## ---- add symlinks for submodule contents to project root

add-symlinks: $(submodule_path)
	[ -n "$(targets)" ] || { echo '[ERROR] targets variable not set'; exit 1; }
	for target in $(targets); do \
		echo '[INFO] adding symlink for $$target'
	 	rm --recursive --force $$target \
	 	&& ln --symbolic $(submodule_path)/$$target $$target
	done

## ---- show status of submodules in the project

status:
	echo '[INFO] submodule status:'
	git submodule status

## ---- remove submodule from project

# preserve directories in the project that are links to directories in the submodule
remove-symlinked-dirs: check-submodule-path-exists
	echo '[INFO] cleaning directories symlinked to $(submodule_path)'
	find $(submodule_path) -mindepth 1 -type d -not \( -name .git -prune \) -printf '%P\n' \
	| xargs --max-args 1 -I @ sh -c 'readlink @ > /dev/null && echo @' \
	| xargs --max-args 1 -I @ sh -c 'rm -f @ || { echo "[ERROR] failed to remove @"; exit 1; }; mv $(submodule_path)/@ . || exit 1;'

# preserve files in the project that are links to files in the submodule
remove-symlinked-files: remove-symlinked-dirs
	echo '[INFO] cleaning files symlinked to $(submodule_path)'
	find $(submodule_path) -mindepth 0 -type f -not -name .git -printf '%P\n' \
	| xargs --max-args 1 -I @ sh -c 'readlink @ > /dev/null && echo @' \
 	| xargs --max-args 1 -I @ sh -c 'rm -f @ || { echo "[ERROR] failed to remove @"; exit 1; }; mv $(submodule_path)/@ . || exit 1;'

remove-submodule: check-submodule-path-exists remove-symlinks
	echo '[INFO] removing $(repository) submodule'
	git submodule deinit --quiet --force $(submodule_path) \
	&& git rm --quiet --force $(submodule_path) \
	&& echo '[INFO] submodule removed successfully'

remove-symlinks: remove-symlinked-files
remove: remove-submodule

## ---- helper target to print variable values, e.g. `make print-foo`

print-%:
	echo $($*)
