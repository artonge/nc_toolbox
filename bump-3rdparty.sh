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
git remote show origin | grep git@github.com:nextcloud/3rdparty.git

# Update to latest commit
git checkout $branch
git pull --rebase

# Make sure to use the latest version of composer.phar
composer --version
# Edit composer.json and adjust the version of the library to the one to update to
composer require -W $2:^$3
# Run composer update thevendor/thelib (replace accordingly)
COMPOSER_ROOT_VERSION=dev-master composer update $package --no-dev
# Delete all installed dependencies with rm -rf ./*/
rm -r ./*/
# Run composer install --no-dev
composer install --no-dev
# Remove tests and other ignored files
git clean -X -d -f
# Run dump-autoload
composer dump-autoload
# Commit all changes onto a new branch
git checkout -b fix/bump-$package-to-$version-in-$branch
git add .
git commit -s -m "Bump $package to $version in $branch"
git push --set-upstream origin fix/bump-$package-to-$version-in-$branch
