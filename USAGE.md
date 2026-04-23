# USAGE

## Creating a project from this template

Make sure `git` and `gh` are available.

```bash
conda activate git
```

Optionally set `gh` to use `ssh` protocol rather than https. This modifies `~/.config/gh`.

```bash
gh config set git_protocol ssh
```

Define a name of the new project.

```bash
new_project=new-project
```

Create a new project in the account associated with the `GH_TOKEN` and in the local directory.

```bash
GH_TOKEN=$GH_TOKEN gh repo create $new_project --clone --disable-wiki --private --template babs-project
```

Optionally, remove the remote to make the project local-only and delete the newly-created GitHub repository.

```bash
cd $new_project
git remote rm origin
GH_TOKEN=$GH_TOKEN gh repo delete --yes $new_project
```
