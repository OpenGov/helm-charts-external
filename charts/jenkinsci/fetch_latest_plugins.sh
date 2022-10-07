#!/usr/bin/env bash

###
### To use this script, you'll need to install jq and yq:
###
### brew install
###
set -e

if ! type "jq" &> /dev/null; then
cat << EOF
###################
JQ not installed!!

$ brew install jq
###################
EOF
  exit 1;
fi

if ! type "yq" &> /dev/null; then
cat << EOF
###################
YQ not installed!!

$ pip install yq --user
###################
EOF
  exit 1;
fi

set -eo pipefail

versions_json=$(mktemp) || exit 1

cleanAndExit () {
    rm -f "${versions_json}"
    exit "$1"
}

curl -s -o "${versions_json}" 'https://updates.jenkins-ci.org/current/update-center.actual.json'

printf "\nCopy/Paste the following under InstallPlugins: \n\n"

for plugin in $(yq e ".jenkins.Master.InstallPlugins" values.yaml | sed "s/^\- //" | sort); do
    artifact=$(echo "${plugin}" | awk '{ split($0,a,":"); print a[1] }')
    version_avail=$(jq -r ".plugins.\"${artifact}\".gav" "${versions_json}" | awk '{ split($0,a,":"); print a[3] }')

    if [ "$version_avail" == "" ]; then
        printf "#####\n\nERROR: The %s plugin was missing from the Jenkins update server please remove this before proceeding\n\n######" "${artifact}"
        cleanAndExit 1
    fi

    echo "      - ${artifact}:${version_avail}"
done

printf "\n\n"

cleanAndExit 0
