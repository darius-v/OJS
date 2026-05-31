#!/usr/bin/env bash
set -e

cd /var/www/html

mkdir -p files public cache cache/t_cache cache/t_compile cache/_db

chown -R www-data:www-data \
  files \
  public \
  cache

chmod -R ug+rwX \
  files \
  public \
  cache

if [ ! -f config.inc.php ] && [ -f config.TEMPLATE.inc.php ]; then
  cp config.TEMPLATE.inc.php config.inc.php

  sed -i 's|base_url = "https://pkp.sfu.ca/ojs"|base_url = "http://localhost:8080"|' config.inc.php

  sed -i 's|host = localhost|host = mysql|' config.inc.php
  sed -i 's|username = ojs|username = ojs|' config.inc.php
  sed -i 's|password = ojs|password = ojs|' config.inc.php
  sed -i 's|name = ojs|name = ojs|' config.inc.php

  sed -i 's|files_dir = files|files_dir = /var/www/html/files|' config.inc.php
  sed -i 's|public_files_dir = public|public_files_dir = public|' config.inc.php

  sed -i 's|display_errors = Off|display_errors = On|' config.inc.php
  sed -i 's|deprecation_warnings = Off|deprecation_warnings = Off|' config.inc.php

  chown www-data:www-data config.inc.php
fi

# Set safe directory for git to avoid ownership issues
git config --global --add safe.directory /var/www/html

# Initialize submodules if .git exists and lib/pkp is empty
if [ -d .git ] && [ ! -f lib/pkp/includes/bootstrap.php ]; then
  git submodule update --init --recursive
fi

# Find all composer.json files and install dependencies
find . -name "composer.json" -not -path "*/vendor/*" -exec bash -c '
  dir=$(dirname "{}")
  echo "Installing dependencies in $dir..."
  composer install --working-dir="$dir" --no-interaction --prefer-dist --no-dev || true
' \;

# Install NPM dependencies and build assets if package.json exists
if [ -f package.json ]; then
  # Remove circular symlinks that break Vite/PostCSS (common in some opensearch-php versions)
  find lib/pkp/lib/vendor -type l -name "opensearch-php" -delete 2>/dev/null || true

  echo "Installing NPM dependencies..."
  npm install
  echo "Building assets..."
  npm run build

  # Ensure built assets are owned by www-data
  chown -R www-data:www-data js styles 2>/dev/null || true
fi

exec "$@"
