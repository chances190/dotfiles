#!/usr/bin/env bash
set -euo pipefail

echo "Syncing dotfiles with local machine..."

cd ./dotfiles

read -r -p "Do you wish to stow new files from local? [y/N] " response
if [[ "$response" =~ ^[Yy]$ ]]; then
    while read -r -p "Enter the module name (or press Enter to finish): " module_name; do
        [[ -z "$module_name" ]] &&  break
        
        read -e -r -p "Enter files to stow: " files_to_stow
        [[ -z "$files_to_stow" ]] && continue

        shopt -s globstar nullglob
        for pattern in $files_to_stow; do

            expanded_pattern="${pattern/#\~/$HOME}"
            matches=( $expanded_pattern )
            
            for file_path in "${matches[@]}"; do
                file_path=$(realpath -m "$file_path")
                relative_path="${file_path#$HOME/}"
                target_path="./$module_name/$relative_path"
                
                mkdir -p "$(dirname "$target_path")"
                touch "$target_path"
            done
        done
        shopt -u globstar nullglob
    done
fi

# Apply GNU Stow to your dotfiles
stow --target="$HOME" --ignore '.*encrypted/.*' --dotfiles --no-folding --adopt --restow *

# Check for modifications wit Git
modified_files=$(git status --porcelain -- dotfiles | awk '{print $2}')
if [[ -z "$modified_files" ]]; then
    exit 0
fi
echo
echo "The following dotfiles have local changes:"
echo "$modified_files"
echo

read -r -p "Overwrite local changes? [y/N] " reply
if [[ "$reply" =~ ^[Yy]$ ]]; then
    echo "Restoring remote versions..."
    echo "$modified_files" | xargs git checkout --
else
    echo "Keeping local versions. Review changes with 'git diff' and commit if desired."
fi

