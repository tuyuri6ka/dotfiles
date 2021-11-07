## Makefile command details are below:
## https://qiita.com/chibi929/items/b8c5f36434d5d3fbfa4a
DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES := $(wildcard .??*) ##bin
EXCLUSIONS := .DS_Store .git .gitmodules .travis.yml
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

list: ## Show dot files in this repo
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(val);)

deploy: ## Create symlink to home directory 
	@echo 'Copyright (c) tuyuri6ka All Rights Reserved.'
	@echo '--> Start to deploy dotfiles to home directory.'
	@echo ''
	@$(foreach val, $(DOTFILES)/dotfiles, ln -sfnv $(abspath $(val)) $(HOME)/$(val);)

init: ## Setup environment settings. ex) sudo apt install hoge
	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/bundles/install.sh

clean: ## Remove the dot files and this repo
	@echo 'Remove dot files in your home directory...'
	@-$(foreach val, $(DOTFILES), rm -vrf $(HOME)/$(val);)
	-rm -rf $(DOTPATH)

help: ## Self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo $(DOPATH)
