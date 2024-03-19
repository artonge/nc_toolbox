#!/bin/sh

# Stop at first error
set -e

folder=$1
package=$2
version=$3

if [ -z "$4" ]; then
    branch='master'
else
    branch=$4
fi

cd $folder
pwd

# Make sure that we are in the right folder
git remote show origin|grep git@github.com:nextcloud/server.git

# Update to latest commit
git checkout $branch
git pull --rebase

# Create a new branch
git checkout -b fix/bump-$package-to-$version-in-$branch
# Pull 3rdparty branch
cd 3rdparty
git fetch
git checkout fix/bump-$package-to-$version-in-$branch
cd ..
git add 3rdparty
git commit -s -m "Bump $package to $version in $branch"
git push --set-upstream origin fix/bump-$package-to-$version-in-$branch
