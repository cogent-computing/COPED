# Elasticsearch service

Plugins are defined in the `Dockerfile` image definition.

Configuration files in the `./config/` directory are loaded at runtime by Docker compose.

## TODOs

- As per the [ELK stack template repository](https://github.com/deviantony/docker-elk) Elasticsearch's [bootstrap checks](https://www.elastic.co/guide/en/elasticsearch/reference/current/bootstrap-checks.html) were purposely disabled to facilitate the setup of the Elastic stack in development environments. For production setups, set up host according to the instructions from the Elasticsearch documentation: [Important System Configuration](https://www.elastic.co/guide/en/elasticsearch/reference/current/system-config.html).

