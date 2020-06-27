#!/bin/sh
set -eu

ENVATO_USERNAME="${INPUT_ENVATO_USERNAME}"
ENVATO_PERSONAL_TOKEN="${INPUT_ENVATO_PERSONAL_TOKEN}"
DIST_IGNORE="${INPUT_DIST_IGNORE}"
ASSETS_PATH="${INPUT_ASSETS_PATH}"
ASSETS_IGNORE="${INPUT_ASSETS_IGNORE}"
DIST_LOCATION="${INPUT_DIST_LOCATION}"
SLUG=${GITHUB_REPOSITORY#*/}
VERSION=${GITHUB_REF#refs/tags/}
DIST_IGNORE_PATH=""
ASSETS_IGNORE_PATH=""

if [ $VERSION == $GITHUB_REF ]; then
  VERSION=${GITHUB_REF#refs/heads/}
fi

if [ -z "$DIST_LOCATION" ]; then
  DIST_LOCATION="dist/"
fi

sh /envato-action-scripts/dist-ignore-handler.sh

echo "✅ Creating Required Temp Directories"
mkdir ../envato-draft-source/
mkdir ../envato-draft-source/"$SLUG"
mkdir ../envato-draft-source-assets
mkdir ../envato-draft-source-screenshots
mkdir ../envato-final-source/

echo "🚨 Removing Excluded Files"
rsync -r --delete --exclude-from="$DIST_IGNORE_PATH" "./" ../envato-draft-source/"$SLUG"

if [ -d "$GITHUB_WORKSPACE/$ASSETS_PATH" ]; then
  echo "✅ Copying Banner, Icon & Screenshots"
  rsync -r --delete --exclude-from="$ASSETS_IGNORE_PATH" "$GITHUB_WORKSPACE/$ASSETS_PATH/" ../envato-draft-source-assets
  rsync -r --delete --exclude-from="$ASSETS_IGNORE_PATH" "$GITHUB_WORKSPACE/$ASSETS_PATH/screenshots/" ../envato-draft-source-screenshots

  echo "✅ Copying Banner & Icons if exists."
  cd ../envato-draft-source-assets
  mv ./* ../envato-final-source/
else
  echo "🚨︎ Assets Folder Not Found"
fi

echo " "
echo "##[group] 📦 Generating Final Zip File"
cd ../envato-draft-source/
zip -r9 "../envato-final-source/$SLUG-$VERSION.zip" ./
echo "##[endgroup]"
echo " "

if [ -d "$GITHUB_WORKSPACE/$ASSETS_PATH" ]; then
  echo "##[group] 📦 Packing Screenshots"
  cd ../envato-draft-source-screenshots
  zip -r9 "../envato-final-source/$SLUG-$VERSION-screenshots.zip" ./
  echo "##[endgroup]"
  echo " "
fi

echo "📦 Source Zip Filename : $SLUG-$VERSION.zip"
echo "📦 Screenshots Zip Filename : $SLUG-$VERSION-screenshots.zip"
echo " "
echo "🗃 Envato Upload Started"
lftp "ftp.marketplace.envato.com" -u $ENVATO_USERNAME,$ENVATO_PERSONAL_TOKEN -e "set ftp:ssl-allow yes; mirror -R ../envato-final-source/ ./; quit"
echo "##[group]⬆️Uploaded Files"
cd ../envato-final-source && ls -lah
echo "##[endgroup]"
echo "👌 FTP Deploy Complete"

echo "##[group] 📦 Copying To Dist Folder"
mkdir "$GITHUB_WORKSPACE/$DIST_LOCATION"
cp -r ../envato-final-source/* "$GITHUB_WORKSPACE/$DIST_LOCATION"
echo "Dist Location : $GITHUB_WORKSPACE/$DIST_LOCATION"
echo "##[endgroup]"

rm -r ../envato-draft-source/
rm -r ../envato-draft-source-assets
rm -r ../envato-draft-source-screenshots
rm -r ../envato-final-source/

cd $HOME
