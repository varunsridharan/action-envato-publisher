#!/bin/sh
# $1 - Envato Username
# $2 - Envato Personal Token
# $3 - Custom Command
# $4 - Exclude Files
set -eu

# Allow some ENV variables to be customized
SLUG=${GITHUB_REPOSITORY#*/}

# Set VERSION value according to tag value.
VERSION=${GITHUB_REF#refs/tags/}

if [[ $VERSION = $GITHUB_REF ]]; then
  VERSION=${GITHUB_REF#refs/heads/}
fi

# Custom Command Option
if [[ ! -z "$3" ]]; then
  echo "Running Custom Command"
  eval "$3"
fi

# Files That Are Needed To Be Excluded
if [[ ! -z "$4" ]]; then
  echo "Saving Excluded File List"
  echo $4 | tr " " "\n" >> envato_exclude_list.txt
fi

echo ".git .github exclude.txt node_modules envato_exclude_list.txt .gitattributes .gitignore .DS_Store" | tr " " "\n" >> envato_exclude_list.txt

echo "Creating Required Temp Dirs"
mkdir ../envato-draft-source/
mkdir ../envato-draft-source/"$SLUG"
mkdir ../envato-final-source/

echo "Removing Excluded Files"
rsync -r --delete --exclude-from="./envato_exclude_list.txt" "./" ../envato-draft-source/"$SLUG"

echo "Generating Final Zip File"
cd ../envato-draft-source/
zip -r9 "../envato-final-source/$SLUG-$VERSION.zip" ./


echo "Zip Filename : $SLUG-$VERSION.zip"
echo "Envato Upload Started"
lftp "ftp.marketplace.envato.com" -u $1,$2 -e "set ftp:ssl-allow yes; mirror -R ../envato-final-source/ ./; quit"
echo "FTP Deploy Complete"

rm -r ../envato-draft-source/
rm -r ../envato-final-source/

cd $HOME