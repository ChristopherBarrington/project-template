# environments/uv/

A shared Python environment managed by [uv](https://docs.astral.sh/uv/). The uv project lives here, not at the project root, and every command is run from the project root with `--project environments/uv`:

```
environments/uv/
├── README.md
├── pyproject.toml     dependencies, tracked
├── uv.lock            lockfile, tracked
├── .python-version    Python version, tracked
└── .venv/             built environment, ignored
```

## Create

```bash
uv init --bare --pin-python environments/uv
uv add --project environments/uv pandas
```

`--bare` writes only `pyproject.toml` (and, with `--pin-python`, `.python-version`), without the example `main.py` and `README.md`.

## Write the lockfile

`uv add` and `uv remove` update `uv.lock` and the environment. After editing `pyproject.toml` by hand:

```bash
uv lock --project environments/uv
```

## Recreate

```bash
uv sync --project environments/uv --locked
```

`--locked` fails if `uv.lock` is out of date with `pyproject.toml`, rather than updating it.

## Use

Run a command in the environment, from the project root or an analysis:

```bash
uv run --project environments/uv python script.py
uv run --project ../../../environments/uv python script.py
```

or activate it:

```bash
source environments/uv/.venv/bin/activate
```
