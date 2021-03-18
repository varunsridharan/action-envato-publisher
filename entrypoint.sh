#!/bin/sh
set -e

source /gh-toolkit/shell.sh

## Validate Input Values ##
gh_validate_input "ENVATO_USERNAME" "ENVATO USERNAME is required to upload files to ENVATO FTP"
gh_validate_input "ENVATO_PERSONAL_TOKEN" "ENVATO_PERSONAL_TOKEN is required to upload files to ENVATO FTP"

## Fetch Input Values ##
ENVATO_USERNAME=$(gh_input "ENVATO_USERNAME")
ENVATO_PERSONAL_TOKEN=$(gh_input "ENVATO_PERSONAL_TOKEN")
DIST_IGNORE=$(gh_input "DIST_IGNORE")
ASSETS_PATH=$(gh_input "ASSETS_PATH")
ASSETS_IGNORE=$(gh_input "ASSETS_IGNORE")
DIST_LOCATION=$(gh_input "DIST_LOCATION" "dist/")

## Custom Values ##
SLUG=${GITHUB_REPOSITORY#*/}
VERSION=${GITHUB_REF#refs/tags/}
DIST_IGNORE_PATH=""
ASSETS_IGNORE_PATH=""
DIST_LOCATION=$(is_empty_var "${DIST_LOCATION}" "dist/")

if [ $VERSION == $GITHUB_REF ]; then
  VERSION=${GITHUB_REF#refs/heads/}
fi

gh_log

##### Check if Dist Ignore File Exists Or Not ####
if [ ! -f "$GITHUB_WORKSPACE/$DIST_IGNORE" ]; then
  gh_log "⚠️ Dist Ignore File Not Found !"
  DIST_IGNORE="envato_distignore.txt"
  DIST_IGNORE_PATH="${GITHUB_WORKSPACE}/$DIST_IGNORE"
  touch $DIST_IGNORE_PATH
elif [ -f "$DIST_IGNORE" ]; then
  DIST_IGNORE_PATH="$GITHUB_WORKSPACE/$DIST_IGNORE"
fi

##### Create Default Dist Ignore ####
if [ ! -z "$DIST_IGNORE_PATH" ]; then
  gh_log_group_start "📝 Dist Ignore File Contents"
  echo "File Location : $DIST_IGNORE_PATH"
  gh_log
  echo "$ASSETS_IGNORE $DIST_IGNORE $ASSETS_PATH .git .github node_modules .gitattributes .gitignore .DS_Store" | tr " " "\n" >>"$DIST_IGNORE_PATH"
  cat $DIST_IGNORE_PATH
  gh_log_group_end
fi

#### Check if Assets Ignore File Exists Or Not ####
if [ ! -f "$GITHUB_WORKSPACE/$ASSETS_IGNORE" ]; then
  gh_log "⚠️ Assets Ignore File Not Found !"
  ASSETS_IGNORE="envato_assets_distignore.txt"
  ASSETS_IGNORE_PATH="${GITHUB_WORKSPACE}/$ASSETS_IGNORE"
  touch $ASSETS_IGNORE_PATH
elif [ -f "$ASSETS_IGNORE" ]; then
  ASSETS_IGNORE_PATH="$GITHUB_WORKSPACE/$ASSETS_IGNORE"
fi

if [ ! -z "$ASSETS_IGNORE_PATH" ]; then
  gh_log_group_start "📝 Assets Ignore File Contents"
  gh_log "File Location : $ASSETS_IGNORE_PATH"
  gh_log
  echo "screenshots/ *.psd .DS_Store *.db .git .github .gitignore .gitattributes node_modules" | tr " " "\n" >>"$ASSETS_IGNORE_PATH"
  cat $ASSETS_IGNORE_PATH
  gh_log_group_end
fi

gh_log
gh_log "✅ Creating Required Temp Directories"
mkdir ../envato-draft-source/
mkdir ../envato-draft-source/"$SLUG"
mkdir ../envato-draft-source-assets
mkdir ../envato-draft-source-screenshots
mkdir ../envato-final-source/

gh_log "🚨 Removing Excluded Files"
rsync -r --delete --exclude-from="$DIST_IGNORE_PATH" "./" ../envato-draft-source/"$SLUG"

if [ -d "$GITHUB_WORKSPACE/$ASSETS_PATH" ]; then
  gh_log "✅ Copying Banner, Icon & Screenshots"
  rsync -r --delete --exclude-from="$ASSETS_IGNORE_PATH" "$GITHUB_WORKSPACE/$ASSETS_PATH/" ../envato-draft-source-assets
  rsync -r --delete --exclude-from="$ASSETS_IGNORE_PATH" "$GITHUB_WORKSPACE/$ASSETS_PATH/screenshots/" ../envato-draft-source-screenshots

  gh_log "✅ Copying Banner & Icons if exists."
  cd ../envato-draft-source-assets
  mv ./* ../envato-final-source/
else
  gh_log "🚨︎ Assets Folder Not Found"
fi

gh_log
gh_log_group_start "📦 Generating Final Zip File"
cd ../envato-draft-source/
zip -r9 "../envato-final-source/$SLUG-$VERSION.zip" ./
gh_log_group_end
gh_log

if [ -d "$GITHUB_WORKSPACE/$ASSETS_PATH" ]; then
  gh_log_group_start "📦 Packing Screenshots"
  cd ../envato-draft-source-screenshots
  zip -r9 "../envato-final-source/$SLUG-$VERSION-screenshots.zip" ./
  gh_log_group_end
  gh_log
fi

gh_log_group_start "⬆️ List Of Files To Be Uploaded"
cd ../envato-final-source
tree -a -C -h --filelimit 100
gh_log_group_end

gh_log

gh_log "📦 Source Zip Filename : $SLUG-$VERSION.zip"
gh_log "📦 Screenshots Zip Filename : $SLUG-$VERSION-screenshots.zip"
gh_log "🗃 Envato Upload Started"
lftp "ftp.marketplace.envato.com" -u $ENVATO_USERNAME,$ENVATO_PERSONAL_TOKEN -e "set ftp:ssl-allow yes; mirror -R ../envato-final-source/ ./; quit"
gh_log "👌 FTP Deploy Complete"

gh_log_group_start "📦 Copying To Dist Folder"
mkdir "$GITHUB_WORKSPACE/$DIST_LOCATION"
cp -r ../envato-final-source/* "$GITHUB_WORKSPACE/$DIST_LOCATION"
gh_log "Dist Location : $GITHUB_WORKSPACE/$DIST_LOCATION"
gh_log_group_end

rm -r ../envato-draft-source/
rm -r ../envato-draft-source-assets
rm -r ../envato-draft-source-screenshots
rm -r ../envato-final-source/

gh_set_output "source_zip" "${SLUG}-${VERSION}.zip"
gh_set_output "screenshots_zip" "${SLUG}-${VERSION}-screenshots.zip"

gh_set_output "source_zip_location" "${GITHUB_WORKSPACE}/${DIST_LOCATION}/${SLUG}-${VERSION}.zip"
gh_set_output "screenshots_zip_location" "${GITHUB_WORKSPACE}/${DIST_LOCATION}/${SLUG}-${VERSION}-screenshots.zip"

cd $HOME
