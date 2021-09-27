#!/bin/sh

voila --no-browser --server_url=${DASHBOARDS_ROOT} --base_url=${DASHBOARDS_ROOT} --Voila.tornado_settings="{'allow_origin': '*'}" ${NOTEBOOK_DIR}

exec "$@"
