# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository builds extended PHP Docker images based on official PHP images. Images are published to Docker Hub at `krato/php` with multiple PHP versions (7.2, 7.4, 8.1, 8.2) and configurations (CLI, Apache, Bullseye, Bookworm).

## Architecture

### Multi-stage Dockerfile Structure

The Dockerfile uses multi-stage builds with versioned targets (`v1_2`, `v1_3`, `v2_0`, `v2_1`, `latest`):

- **v1_2** (Dockerfile:4): Base layer - MySQL client, SSH, zip, PNG support, pdo_mysql extension
- **v1_3** (Dockerfile:14): Adds sendmail, GD library (with JPEG/PNG/FreeType), mysqli, xdebug (version-specific)
- **v2_0** (Dockerfile:27): Removes sendmail, adds memcached and redis (PHP 7+), opcache
- **v2_1** (Dockerfile:36): Apache configuration - enables remoteip module with X-Forwarded-For header support for proxies
- **latest** (Dockerfile:42): Alias to v2_1

Each stage builds on the previous, allowing users to select feature sets via tag suffixes (e.g., `8.1-apache-1` uses v1_3).

### GitHub Actions Workflow

The publish workflow (.github/workflows/publish.yml) runs daily at 17:45 UTC and on every push:

- Builds matrix of PHP versions × web servers × OS versions
- Only pushes to Docker Hub on `main` branch
- Uses `lucacome/docker-image-update-checker` to rebuild only when base images update (on scheduled runs)
- Builds all version stages (1.2, 1.3, 2.0, 2.1) with appropriate tags
- The `latest` tag points to PHP 8.2 CLI (currently set in workflow:43)

## Common Commands

### Build Locally

Test a specific configuration:
```bash
docker build --build-arg PHP_IMAGE=php:8.2 --target v2_1 --tag test:8.2 .
```

Build different stages:
```bash
docker build --build-arg PHP_IMAGE=php:8.1-apache --target v1_3 --tag test:8.1-apache-1 .
docker build --build-arg PHP_IMAGE=php:7.4-bullseye --target v2_0 --tag test:7.4-2.0 .
```

### Test Locally

Run built image:
```bash
docker run -it test:8.2 php -v
```

### Workflow Testing

The workflow only pushes on `main` branch. To test workflow changes without publishing, push to a non-main branch.

## Key Configuration

- **Latest PHP version**: Set in .github/workflows/publish.yml:43 (`latest_php_version`)
- **Supported PHP versions**: Matrix in .github/workflows/publish.yml:24
- **OS versions**: PHP 7.2 excludes Bullseye/Bookworm (see excludes in workflow:27-33)
- **Docker Hub credentials**: Stored in GitHub secrets (`DOCKER_USERNAME`, `DOCKER_PASSWORD`)
