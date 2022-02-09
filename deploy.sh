#!/bin/sh

# Check prerequisites
if [ ! -d ".git/modules" ]; then
    echo "Looks like the submodules have not been initialized."
    echo "Run `git submodule init` before continuing."
    exit 1;
fi

if [[ $(git status -s) ]]
then
    if [ "$1" != "-f" ]; then
        echo "The working directory is dirty. Please commit any pending changes."
        exit 1;
    else
        shift
    fi
fi

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 \"release-name\""
    exit 1;
fi

if ! command -v doxygen &> /dev/null
then
    echo "Error: doxygen required"
    exit 1;
fi

# TODO: add logic to update the component git submodules

echo "Deleting old generated files"
rm -rf html
mkdir html
git worktree prune
rm -rf .git/worktrees/gh-pages

echo "Checking out gh-pages branch"
git worktree add -B gh-pages html origin/gh-pages

echo "Removing existing files"
rm -rf html/*

echo "Generating Files"
doxygen Doxyfile

echo "Updating gh-pages branch"
cd html && git add --all && git commit -m "$@"
cd ..

# TODO: automatically push changes
echo ""
echo ""
echo "** DONE **"
echo "Generated files are commited in 'html' directory (on 'gh-pages' branch)"
echo "DON'T FORGET TO PUSH THESE CHANGES TO 'origin'"
