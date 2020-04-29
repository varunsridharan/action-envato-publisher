#!/bin/sh
set -eu

ENVATO_USERNAME="${INPUT_ENVATO_USERNAME}"
ENVATO_PERSONAL_TOKEN="${INPUT_ENVATO_PERSONAL_TOKEN}"
CUSTOM_COMMAND="${INPUT_CUSTOM_COMMAND}"
EXCLUDE_LIST="${INPUT_EXCLUDE_LIST}"
ASSETS_PATH="${INPUT_ASSETS_PATH}"
ASSETS_EXCLUDE_LIST="${INPUT_ASSETS_EXCLUDE_LIST}"

# Allow some ENV variables to be customized
SLUG=${GITHUB_REPOSITORY#*/}

# Set VERSION value according to tag value.
VERSION=${GITHUB_REF#refs/tags/}

if [[ $VERSION == $GITHUB_REF ]]; then
  VERSION=${GITHUB_REF#refs/heads/}
fi

# Custom Command Option
if [[ ! -z "$CUSTOM_COMMAND" ]]; then
  echo " "
  echo "##[group] Running Custom Command"
  eval "$CUSTOM_COMMAND"
  echo "##[endgroup]"
  echo " "
fi

# Files That Are Needed To Be Excluded
if [[ ! -z "$EXCLUDE_LIST" ]]; then
  echo "➤ Saving Excluded File List"
  echo $EXCLUDE_LIST | tr " " "\n" >>envato_exclude_list.txt
fi
# Files That Are Needed To Be Excluded
if [[ ! -z "$ASSETS_EXCLUDE_LIST" ]]; then
  echo "➤ Saving Assets Excluded File List"
  echo $ASSETS_EXCLUDE_LIST | tr " " "\n" >>envato_assets_exclude_list.txt
fi

echo ".git .github exclude.txt node_modules envato_exclude_list.txt envato_assets_exclude_list.txt .gitattributes .gitignore .DS_Store" | tr " " "\n" >>envato_exclude_list.txt
echo "screenshots/ *.psd .DS_Store Thumbs.db ehthumbs.db ehthumbs_vista.db .git .github .gitignore .gitattributes node_modules" | tr " " "\n" >>envato_assets_exclude_list.txt

if [ -d "$GITHUB_WORKSPACE/$ASSETS_PATH" ]; then
  echo "$ASSETS_PATH" | tr " " "\n" >>envato_exclude_list.txt
fi

echo "➤ Creating Required Temp Directories"
mkdir ../envato-draft-source/
mkdir ../envato-draft-source/"$SLUG"
mkdir ../envato-draft-source-assets
mkdir ../envato-draft-source-screenshots
mkdir ../envato-final-source/
echo "ASSETS DIR : $GITHUB_WORKSPACE/$ASSETS_PATH"

echo "➤ Removing Excluded Files"
rsync -r --delete --exclude-from="./envato_exclude_list.txt" "./" ../envato-draft-source/"$SLUG"

echo " "
echo "##[group] Generating Final Zip File"
cd ../envato-draft-source/
zip -r9 "../envato-final-source/$SLUG-$VERSION.zip" ./
echo "##[endgroup]"
echo " "

if [ -d "$GITHUB_WORKSPACE/$ASSETS_PATH" ]; then
  echo "➤ Copying Banner, Icon & Screenshots"
  rsync -r --delete --exclude-from="$GITHUB_WORKSPACE/envato_assets_exclude_list.txt" "$GITHUB_WORKSPACE/$ASSETS_PATH/" ../envato-draft-source-assets
  rsync -r --delete --exclude-from="$GITHUB_WORKSPACE/envato_assets_exclude_list.txt" "$GITHUB_WORKSPACE/$ASSETS_PATH/screenshots/" ../envato-draft-source-screenshots

  echo "➤ Copying Banner & Icons if exists."
  cd ../envato-draft-source-assets
  mv ./* ../envato-final-source/

  echo " "
  echo "##[group] ➤ Packing Screenshots"
  cd ../envato-draft-source-screenshots
  zip -r9 "../envato-final-source/$SLUG-$VERSION-screenshots.zip" ./
  echo "##[endgroup]"
  echo " "
else
  echo " ℹ︎ Assets Folder Not Found"
fi

echo "➤ Zip Filename : $SLUG-$VERSION.zip"
echo "➤ Envato Upload Started"
lftp "ftp.marketplace.envato.com" -u $ENVATO_USERNAME,$ENVATO_PERSONAL_TOKEN -e "set ftp:ssl-allow yes; mirror -R ../envato-final-source/ ./; quit"
echo "➤ FTP Deploy Complete"

rm -r ../envato-draft-source/
rm -r ../envato-draft-source-assets
rm -r ../envato-draft-source-screenshots
rm -r ../envato-final-source/

cd $HOME
