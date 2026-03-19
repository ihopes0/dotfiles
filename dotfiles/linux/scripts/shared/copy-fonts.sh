#! /usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

USER_LOCAL_FONTS_DIR="$HOME/.local/share/fonts"
USER_FONTS_DIR="$HOME/.fonts"
GLOBAL_FONTS_DIR="/usr/share/fonts"

fontDirectories=("$USER_LOCAL_FONTS_DIR" "$USER_FONTS_DIR" "$GLOBAL_FONTS_DIR")

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
    echo "You didn't specified copyTo directory. Write a full path to a fonts destination directory OR stay with a default path:"
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

        relInstalledFontsCount=0

        echo "Copy from $fullCopyFrom to $fullCopyTo"

        while IFS= read -r fontFilePath; do
            skipping=0
            fontFileName="${fontFilePath##*/}"

            for fontDir in "${fontDirectories[@]}"; do
                [[ ! -d "$fontDir" ]] && continue
                if find "$fontDir" -type f -iname "$fontFileName" | grep -q .; then
                    echo "Font file $fontFileName exists in $fontDir. Skipping copying it..."
                    skipping=1
                fi
            done

            [[ $skipping == 1 ]] && continue

            [[ ! -d "$fullCopyTo" ]] && mkdir -p "$fullCopyTo"

            cp -n "$fontFilePath" "$fullCopyTo"
            (( installedFontsCount += 1 ))
            (( relInstalledFontsCount += 1 ))

            unset fontFileName
            unset fontFilePath
            unset skipping
        done < <(find "$fullCopyFrom" -type f \( -iname "*.otf" -o -iname "*.ttf" \))

        [[ $relInstalledFontsCount != 0 ]] && fontTypes+=("$rel")

        echo "Copying of $rel is done. Copied $relInstalledFontsCount fonts."

        unset relInstalledFontsCount
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