#!/bin/bash
set -e
rm -rf docs/autogen
# generate docs
# forge 1.8+ parses the sources itself, so no `forge build` is needed first, and it writes a
# vocs site (MDX pages under src/pages) instead of an mdbook: the `-b` flag is gone.
forge doc -o docs/autogen

# index.mdx is the README with its links pinned to the current commit, which would change on
# every commit. Pin them to `main` so the committed tree depends only on the sources.
perl -pi -e 's#(/blob/)[0-9a-f]{40}/#${1}main/#g' docs/autogen/src/pages/index.mdx

# Unstage all docs where only the commit hash changed
# Get a list of all unstaged files in the directory
files=$(git diff --name-only -- 'docs/autogen/*')

# Loop over each file
for file in $files; do
    # Check if the file exists
    if [[ -f $file ]]; then
        # Get the diff for the file, strip metadata and only keep lines that start with - or +
        diff=$(git diff $file | sed '/^diff --git/d; /^index /d; /^--- /d; /^\+\+\+ /d; /^@@ /d' | grep '^[+-]')
        
        # Filter lines that start with -[Git Source] or +[Git Source]
        filtered_diff=$(echo "$diff" | grep '^\-\[Git Source\]\|^\+\[Git Source\]' || true)

        # Compare the original diff with the filtered diff
        if [[ "$diff" == "$filtered_diff" ]]; then
            # If they are equal, discard the changes for the file
            git reset HEAD $file
            git checkout -- $file
        fi
    fi
done