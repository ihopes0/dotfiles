#! /usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

copyFrom="$SCRIPT_DIR/../../../shared/fonts"
copyTo="/home/$USER/.local/share/fonts"

if [[ ! "$1" ]]; then
    echo "You didn't specified copyFrom directory. Write a full path to font directory to copy from OR stay with a default path:"
    echo "$copyFrom"
    read -r -p "[Empty for default]: " response
    response=${response,,}
    if [[ $response ]]; then
        copyFrom=$response
    fi
else
    copyFrom=$1
fi

if [[ ! "$2" ]]; then
    echo "You didn't specified copyTo directory.\nWrite a full path to a fonts destination directory OR stay with a default path:"
    echo "$copyTo"
    read -r -p "[Empty for default] " response
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
    if [[ ! -d $copyTo ]]; then
        mkdir -p $copyTo;
    fi
    parent_font_dir="${copyFrom##*/}"
    installedFontsCount=0
    fontTypes=()
    while IFS= read -r dir; do
        # skip root itself
        [[ "$dir" == "$copyFrom" ]] && continue

        rel="${dir#$copyFrom/}"
        fullCopyFrom="$copyFrom/$rel"
        fullCopyTo="$copyTo/$rel"

        if ls -ld "$fullCopyTo" > /dev/null; then
            echo "Directory $fullCopyTo already exists. Delete it first. Skipping these fonts."
        else
            echo "Copy from $fullCopyFrom to $fullCopyTo"
            find "$fullCopyFrom" -type f \( -iname "*.otf" -o -iname "*.ttf" \) -exec cp -n {} "$fullCopyTo" \;
            count=$(find "$fullCopyFrom" -type f \( -iname "*.otf" -o -iname "*.ttf" \) | wc -l)
            (( installedFontsCount += count ))

            fontTypes+=("$rel")
            echo "Copying of $rel is done."
        fi
        unset fullCopyFrom
        unset fullCopyTo

        unset rel
        unset dir
    done < <(find "$copyFrom" -type d)

    echo "Successfully copied $installedFontsCount fonts of: ${fontTypes[@]}"
else
    echo "Aborted copying of $fontFilesCount font files."
fi

unset copyFrom
unset copyTo
unset response
unset fontFilesCount

exit 0