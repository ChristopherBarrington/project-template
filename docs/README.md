# project template repository

## Creating a project from this template

Make sure `git` and `gh` are available. For example, using a conda environment.

```bash
conda activate git
```

Define a name of the new project.

```bash
new_project=new-project
```

### GitHub

Optionally set `gh` to use `ssh` protocol rather than https. This modifies `~/.config/gh`.

```bash
gh config set git_protocol ssh
```

Create a new project in the account associated with the `GH_TOKEN` and in the local directory.

```bash
GH_TOKEN=$GH_TOKEN gh repo create $new_project --clone --disable-wiki --private --template project-template
```

Optionally, remove the remote to make the project local-only and delete the newly-created GitHub repository.

```bash
cd $new_project
git remote rm origin
GH_TOKEN=$GH_TOKEN gh repo delete --yes $new_project
```

### Git

First, clone the template repository into a new `$new_project` directory, and move into the new project.

```bash
git clone --branch main git@github.com:ChristopherBarrington/project-template.git $new_project && cd $_
```

Optionally, remove permissions tracking and use the user default configuration, if set. This can avoid problems on Nemo when file permissions get changed and are considered a file change by `git`.

```bash
git config --unset core.FileMode
```

Delete the `.git` repository that tracked the development of the template. A new repository can be created that is independent of the template repository.

```bash
rm --recursive --force .git
git init --quiet
```

## Updating the template

### Git submodules

The template repository can be added to the project as a submodule and template files symlinked.

```bash
git submodule add \
--branch main \
git@github.com:ChristopherBarrington/project-template \
resources/github/ChristopherBarrington/project-template
```

Then, a symlink to a template file or directory can be made.

```bash
rm --recursive --force .copilot \
&& ln --symbolic resources/github/ChristopherBarrington/project-template/$_ $_
```

```bash
for target_file in .copilotignore .gitignore resources/README.md; do
	rm --force $target_file \
	&& ln --symbolic --relative resources/github/ChristopherBarrington/project-template/$target_file $target_file
done
```

### Copier

[Copier](https://github.com/copier-org/copier) is a possible option.

## Copilot

[GitHub Copilot Custom Instructions](https://docs.github.com/en/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot)
