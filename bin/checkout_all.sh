#!/bin/bash

# Save the current branch name
current_branch=$(git rev-parse --abbrev-ref HEAD)

# Fetch any updates from the origin
git fetch origin

# Loop through all remote branches
for branch in $(git branch -r | grep -v '\->'); do
    # Checkout each branch
    if [[ $branch == *origin* ]]; then
        branch_name="${branch#origin/}"
        echo "Checking out $branch_name branch..."
        git checkout $branch_name
    else
        echo "$branch is not from the origin"
    fi
done

# Switch back to the original branch
git checkout $current_branch

echo "Operation complete, returned to $current_branch"
