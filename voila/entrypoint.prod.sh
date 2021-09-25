#!/bin/sh

voila --no-browser --server_url=/dashboards/ --base_url=/dashboards/ --Voila.tornado_settings="{'allow_origin': '*'}" /usr/share/voila/notebooks

exec "$@"
