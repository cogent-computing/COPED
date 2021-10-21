# Logstash service

Plugins are defined in the `Dockerfile` image definition.

All data pipelines defined in the `./pipeline/` directory are loaded at runtime by Docker compose.

The configuration file in the `./config/` directory is loaded at runtime by Docker compose.
