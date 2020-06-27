#!/bin/sh
set -eu

if [ ! -f "$GITHUB_WORKSPACE/$DIST_IGNORE" ]; then
  echo "⚠️ Dist Ignore File Not Found !"
  DIST_IGNORE="envato_distignore.txt"
  DIST_IGNORE_PATH="${GITHUB_WORKSPACE}/$DIST_IGNORE"
  touch $DIST_IGNORE_PATH
elif [ -f "$DIST_IGNORE" ]; then
  DIST_IGNORE_PATH="$GITHUB_WORKSPACE/$DIST_IGNORE"
fi

if [ ! -f "$GITHUB_WORKSPACE/$ASSETS_IGNORE" ]; then
  echo "⚠️ Assets Ignore File Not Found !"
  ASSETS_IGNORE="envato_assets_distignore.txt"
  ASSETS_IGNORE_PATH="${GITHUB_WORKSPACE}/$ASSETS_IGNORE"
  touch $ASSETS_IGNORE_PATH
elif [ -f "$ASSETS_IGNORE" ]; then
  ASSETS_IGNORE_PATH="$GITHUB_WORKSPACE/$ASSETS_IGNORE"
fi

if [ ! -z "$DIST_IGNORE_PATH" ]; then
  echo "###[group] $DIST_IGNORE_PATH Contents"
  echo "$ASSETS_IGNORE $DIST_IGNORE $ASSETS_PATH .git .github node_modules .gitattributes .gitignore .DS_Store" | tr " " "\n" >>"$DIST_IGNORE_PATH"
  cat $DIST_IGNORE_PATH
  echo "###[endgroup]"
fi

if [ ! -z "$ASSETS_IGNORE_PATH" ]; then
  echo "###[group] $ASSETS_IGNORE_PATH Contents"
  echo "screenshots/ *.psd .DS_Store *.db .git .github .gitignore .gitattributes node_modules" | tr " " "\n" >>"$ASSETS_IGNORE_PATH"
  cat $ASSETS_IGNORE_PATH
  echo "###[endgroup]"
fi
