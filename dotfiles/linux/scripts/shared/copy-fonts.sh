#! /usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

copyFrom="$SCRIPT_DIR/../../../shared/fonts"
copyTo="/home/$USER/.local/share/fonts"

if [[ ! "$1" ]]; then
    read -r -p "You didn't specified copyFrom directory.\nWrite a full path to font directory to copy from OR stay with a default path: $copyFrom: [empty for default]" response
    response=${response,,}
    if [[ $response ]]; then
        copyFrom=$response
    fi
else
    copyFrom=$1
fi

if [[ ! "$2" ]]; then
    read -r -p "You didn't specified copyTo directory.\nWrite a full path to a fonts destination directory OR stay with a default path: $copyTo: [empty for default]" response
    response=${response,,}
    if [[ $response ]]; then
        copyTo=$response
    fi
else
    copyTo=$2
fi

fontFilesCount=$(find $copyFrom -type f \( -iname "*.otf" -o -iname "*.ttf" \) | wc -l)
echo "Copying $fontFilesCount files from $copyFrom to $copyTo."

read -r -p "Shall we proceed: [Y/n]" response
response=${response,,}

if [[ $response =~ ^(y| ) ]] || [[ -z $response ]]; then
    mkdir -p $copyTo;
    find "$copyFrom" -type f \( -iname "*.otf" -o -iname "*.ttf" \) -exec cp -n {} "$copyTo" \;
    installedFontsCount=$(find $copyTo -type f \( -iname "*.otf" -o -iname "*.ttf" \) | wc -l)
    echo "Copying done. You now have $installedFontsCount installed fonts in $copyTo directory."
else
    echo "Aborted copying of $fontFilesCount font files."
fi

 exit 0