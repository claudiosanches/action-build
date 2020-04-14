#!/bin/sh

# Set variables
GENERATE_ZIP=false
BUILD_PATH="$(pwd)/build"
zip_path=""

# Set options based on user input
if [ -z $1 ]; then
  GENERATE_ZIP=$1;
fi

# If not configured defaults to repository name
if [ -z "$PLUGIN_SLUG" ]; then
	PLUGIN_SLUG=${GITHUB_REPOSITORY#*/}
fi

# Set GitHub "path" output
path="$BUILD_PATH/$PLUGIN_SLUG"

echo "Installing PHP and JS dependencies..."
npm install
composer install || exit "$?"
echo "Running JS Build..."
npm run build || exit "$?"
echo "Cleaning up PHP dependencies..."
composer install --no-dev || exit "$?"

echo "Generating build directory..."
rm -rf "$BUILD_PATH"
mkdir -p "$path"
rsync -rc --exclude-from="$GITHUB_WORKSPACE/.distignore" "$GITHUB_WORKSPACE/" "$path/" --delete --delete-excluded

if ! $GENERATE_ZIP; then
  echo "Generating zip file..."
  cd "$BUILD_PATH" || exit
  zip -r "${PLUGIN_SLUG}.zip" "$PLUGIN_SLUG/"
  # Set GitHub "path" output
  zip_path="$BUILD_PATH/${PLUGIN_SLUG}.zip"
  echo "Zip file generated!"
fi

echo "Build done!"