#!/bin/sh

if [[ $(git status -s) ]]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

if [ "$#" -ne 1 ]; then
    echo "Usage: $) \"release-name\""
    exit 1;
fi

# TODO: add logic to update the component git submodules

echo "Deleting old generated files"
rm -rf html
mkdir html
git worktree prune
rm -rm .git/worktrees/gh-pages

echo "Checking out gh-pages branch"
git worktree add -B gh-pages html origin/gh-pages

echo "Removing existing files"
rm -rf html/*

echo "Generating Files"
doxygen Doxyfile

echo "Updating gh-pages branch"
cd html && git add --all && git commit -m "$1"
cd ..

# TODO: automatically push changes
echo "DONE"
echo "Generated files are commited on 'gh-pages' branch"
echo "DON'T FORGET TO PUSH THESE CHANGES TO 'origin'"
