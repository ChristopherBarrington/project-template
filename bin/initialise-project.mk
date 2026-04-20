
.PHONY: babs-stp
.SILENT:

babs_stp_hash ?= $(notdir $(shell git rev-parse --show-toplevel))

babs-stp:
	echo "[INFO] adding BABS-STP submodule from hash: $(babs_stp_hash)"
	git submodule add --quiet --depth 1 git@github.com:babs-stp/$(babs_stp_hash).git babs-stp \
	&& (cd babs-stp && git sparse-checkout set --no-cone /.babs babs/docs/) \
	&& git commit --quiet --all --message "added BABS-STP submodule from hash: $(babs_stp_hash)"
