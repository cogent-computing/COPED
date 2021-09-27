# Voila Service

Provides Jupyter notebook rendering for dashboards and interactive data analysis: [voila.readthedocs.io](https://voila.readthedocs.io/en/stable/index.html)

### `Dockerfile`

Standard Python `pip install` for the dependencies.

### `requirements.txt`

Note the fixed versions for `voila` and `notebook`. Other combinations can be incompatible.

Another _gotcha_ is that `notebook` is not a formal dependency of `voila` so it must be included to get a Python kernel.

### `entrypoint.sh`

This script is used as the entry point because of the mixed single and double quotes needed in the `--Voila.tornado_settings` option. Escaping these is messy when done in `Dockerfile` directly.

> Important: this script configures Voila to serve notebooks from `${NOTEBOOK_DIR}`. So `docker-compose.yml` (or overrides) should map this path to a bind mount or volume that is __shared__ with the `web` service, to allow Django to manage the dashboards/notebooks server by Voila.

## ToDo

- Restyle the folder navigation page templates
- Decide on a sensible way to allow users to upload templates and make them public as a dashboard:
    - Where to store uploaded notebooks
    - Ability to turn on/off notebook visibility
    - Tagging/naming conventions for organising the notebook navigation
- Look at changing the `allow_origin` setting on the server to be more specific.
