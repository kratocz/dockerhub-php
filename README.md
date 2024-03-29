# General info

Docker image based on the official PHP image. Extended with a few favorite extensions and packages.

# Download

The result of these files are Docker images.

## Built Docker Images

Download one of the auto-built Docker images here: https://hub.docker.com/r/krato/php

# Docker Image Tags

## Format

```
<PHP_VERSION>[-apache][-<major>[.<minor>]]
```

or: `latest`

Note: `major` and `minor` determines the additional set of features, see:

https://github.com/kratocz/dockerhub-php/blob/main/Dockerfile

## Current Tags

- 5.6
- 5.6-apache
- 7.2
- 7.2-apache
- 7.4
- 7.4-apache
- 8.1
- 8.1-apache
- *-1, *-2, *-3, ... (e.g. 8.1-apache-1) has fixed set of additional packages (recommended).
- latest

Note: You can use a tag containing in its name '-bullseye' or '-bookworm' for a specific Linux version.

# Installation and usage

Use the origin image documentation: https://hub.docker.com/_/php
