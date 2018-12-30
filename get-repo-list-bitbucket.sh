#!/bin/bash

# Check if needed commands are present
CMDS=( curl jq )
for cmd in ${CMDS[@]}; do
    command -v $cmd >/dev/null 2>&1 || { echo >&2 "Please install $cmd. Aborting."; exit 1; }
done

# Check if the environment variables are set
[ -z "${BB_USER}" ] && { echo >&2 "Please set environment variable BB_USER=bitbucket_username. Aborting."; exit 2; }
[ -z "${ACCESS_TOKEN}" ] && { echo >&2 "Please set environment variable ACCESS_TOKEN=access_token. Aborting."; exit 2; }
[ -z "${ORG_NAME}" ] && { echo >&2 "Please set environment variable ORG_NAME=organisation_name. Aborting."; exit 2; }

# Ok to proceed
CURL="curl --user ${BB_USER}:${ACCESS_TOKEN}"
NEXT='jq -r .next'
OUTPUT='clone-repos.sh'

next="https://api.bitbucket.org/2.0/repositories/${ORG_NAME}?pagelen=100"

>$OUTPUT
while [[ "$next" != "null" ]]; do
    $CURL "$next" > response.json
    jq -r '.values[] | "git clone " + (.links.clone[] | select(.name == "ssh") | .href) + " \"" + .project.name + "/" + .name + "\""' response.json >> clone-repos.sh
    next="$($NEXT response.json)"
done
