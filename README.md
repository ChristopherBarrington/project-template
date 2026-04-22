# 

[babs-stp project]: https://github.com/ChristopherBarrington/
[babs-stp work]:    https://github.com/babs-stp//issues

This is a [BABS-STP project][babs-stp project], the work packages/tasks are described [here][babs-stp work].

__Perhaps include a summary of the project here.__

__Post any (general) notes for the project here.__

```bash
conda activate git
GH_TOKEN=$GH_TOKEN gh repo create public-data-reprocessing --clone --disable-wiki --private --template babs-project
cd public-data-reprocessing
git config url.git@github.com/.insteadOf https://github.com/
git remote rm origin
GH_TOKEN=$GH_TOKEN gh repo delete --yes public-data-reprocessing
```

