#!/bin/bash -e

bump_type=$1

# ensure local tags are current
git fetch --tags origin

curr_tag="`git describe --abbrev=0 --tags 2>/dev/null`"

if [[ $curr_tag == '' ]]
    then
    curr_tag='0.1.0'
fi
echo "Current tag:"
echo $curr_tag

curr_version=${curr_tag/v/}

curr_version_bits=(${curr_version//./ })

curr_major=$((${curr_version_bits[0]}))
curr_minor=$((${curr_version_bits[1]}))
curr_patch=$((${curr_version_bits[2]}))

if [ "$bump_type" == "chore" ]; then 
    echo "Chore bump, skipping"
    exit 0
elif [ "$bump_type" == "major" ] || ([ "$curr_minor" == 999 ] && [ "$curr_patch" == 999 ]); then
    ((curr_major++))
    curr_minor=0
    curr_patch=0
elif [ "$bump_type" == "minor" ] || [ "$curr_patch" == 999 ]; then
    ((curr_minor++))
    curr_patch=0
else
    ((curr_patch++))
fi

new_tag="v${curr_major}.${curr_minor}.${curr_patch}"

GIT_COMMIT=`git rev-parse HEAD`
NEEDS_TAG=`git describe --contains $GIT_COMMIT 2>/dev/null`

echo "Tagged with:"
echo $new_tag
#git tag $new_tag
#git push --tags