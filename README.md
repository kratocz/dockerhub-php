# PHP Docker Images with Extensions

Docker images based on official PHP images, extended with commonly used extensions and packages.

## Download

Pre-built images are available on Docker Hub: https://hub.docker.com/r/krato/php

## Supported PHP Versions

- **7.2** (CLI & Apache)
- **7.4** (CLI & Apache)
- **8.1** (CLI & Apache)
- **8.2** (CLI & Apache)
- **8.3** (CLI & Apache)
- **8.4** (CLI & Apache)
- **latest** (currently PHP 8.2 CLI)

## Tag Format

```
<PHP_VERSION>[-apache][-<VERSION_SUFFIX>][-<OS_VERSION>]
```

### Examples

- `8.2` - PHP 8.2 CLI with latest features
- `8.1-apache` - PHP 8.1 with Apache
- `8.3-apache-1` - PHP 8.3 Apache with v1.3 feature set (fixed)
- `7.4-bookworm` - PHP 7.4 CLI on Debian Bookworm
- `8.2-apache-2-bullseye` - PHP 8.2 Apache with v2.0 features on Debian Bullseye

### Version Suffixes (Feature Sets)

Use version suffixes to lock to a specific feature set. Without a suffix, you get the latest features.

- **-1** (v1.3): Base extensions + GD, mysqli, xdebug
- **-2** (v2.1): v1.3 + memcached, redis, opcache, Apache remoteip (recommended)

See [Dockerfile](https://github.com/kratocz/dockerhub-php/blob/main/Dockerfile) for detailed extension list per version.

### OS Versions

- `` (default) - Latest Debian version for the PHP version
- `-bullseye` - Debian 11 (not available for PHP 7.2)
- `-bookworm` - Debian 12 (not available for PHP 7.2, 7.4)

## Included Extensions & Packages

### Version 1.2
- **Packages**: mariadb-client, openssh-client, zip, zlib, libpng
- **Extensions**: pdo_mysql, zip
- **Apache**: rewrite module enabled

### Version 1.3 (Tag suffix: -1)
All from v1.2 plus:
- **Packages**: sendmail, libjpeg, libfreetype
- **Extensions**: mysqli, gd (with JPEG/PNG/FreeType), xdebug (version-specific)

### Version 2.0
All from v1.3 except sendmail, plus:
- **Extensions**: memcached (PHP 7+), redis (PHP 7+), opcache
- **Configuration**: GD, mysqli enabled by default

### Version 2.1 (Tag suffix: -2, recommended)
All from v2.0 plus:
- **Apache**: remoteip module for proxy support (X-Forwarded-For)

## Usage

Pull and run:
```bash
docker pull krato/php:8.2-apache
docker run -d -p 80:80 krato/php:8.2-apache
```

Use in Dockerfile:
```dockerfile
FROM krato/php:8.3-apache-2
COPY . /var/www/html/
```

For more usage examples, see the official PHP image documentation: https://hub.docker.com/_/php

## Build Locally

```bash
docker build --build-arg PHP_IMAGE=php:8.2 --target v2_1 --tag myphp:8.2 .
```
