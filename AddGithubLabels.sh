#!/usr/bin/env bash
# 
# Usage: ./AddGithubLabels.sh

############ Configuration ############
ACCESS_TOKEN="${PAT}"
ORG="${ORG}"

TOPIC="${TOPIC:-archive}"
THRESHOLD=${THRESHOLD:-5}

count=0


############ Codebase ############

function main() {
    echo "[+] Starting process"

    # Validate the required input
    validate

    total_pages=$(curl -s -I "https://api.github.com/orgs/${ORG}/repos" -H "Authorization: token ${ACCESS_TOKEN}" | grep -i '^Link:' | sed -e 's/^Link:.*page=//g' -e 's/>.*$//g')

    if [[ -z "${total_pages}" ]]; then
        # If only one page is there
        total_pages="1"
    fi

    # Fetching repos by pagination
    for page in $(seq 1 "${total_pages}"); do
        local repos=$(fetch_paginated_repos "${page}")

        for repo in ${repos}; do
            repo=$(echo "${repo}" | base64 --decode)
            # echo ${repo} | jq
            
            local repo_name=$(echo ${repo} | jq -r '.name')
            local repo_full_name=$(echo ${repo} | jq -r '.full_name')
            local repo_url=$(echo ${repo} | jq -r '.html_url')
            
            local topics=$(fetch_topics "${repo_name}")
            local archive_label=$(echo "${topics}" | jq ".[] | select (. == \"${TOPIC}\") | . ")
            
            # Checking if repo is archived or not
            if [[ "${archive_label}" = "\"${TOPIC}\"" ]]; then
                # Already archived repo
                echo "[!] already archived repo: ${repo_name} (${repo_url}) - topics: ${topics}"
                continue
            fi

            count=$(($count + 1))
            echo "[${count}] Processing repo: ${repo_name} (${repo_url})"

            # Add topic
            add_topic "${repo_name}" "${topics}"

            local command_exit_code="$?"

            if [[ "${command_exit_code}" -ne 0 ]]; then
                # Has leaks, create issue
                echo "[-] Not able to add topic to repo"
            fi

            if [[ -n "${SCAN_THRESHOLD}" ]] && [[ "${count}" -ge "${SCAN_THRESHOLD}" ]]; then
                echo "[*] Threshold reached, exiting the scan"
                exit 0
            fi
        done

        echo "[#] Page: ${page} processed"
    done

    echo "[+] Total ${count} repo. scanned in org ${ORG}"
}

function validate() {
    local required_dependencies="jq curl"

    for tool in ${required_dependencies}; do
        if [[ $(command -v "${tool}") == "" ]]; then
            echo "[-] ${tool} is not installed"
            exit 2
        fi
    done

    if [[ "${ACCESS_TOKEN}" == "" ]]; then
        echo "[-] No access token provided"
        exit 3
    fi
    
    if [[ "${ORG}" == "" ]]; then
        echo "[-] No organization provided"
        exit 3
    fi
}

function fetch_paginated_repos() {
    local page="$1"
    
    curl -s "https://api.github.com/orgs/${ORG}/repos?page=${page}" -H "Authorization: token ${ACCESS_TOKEN}" | jq -r '.[] | @base64'
}

function fetch_topics() {
    local repo="$1"
    local topics=$(curl -s -H "Authorization: token ${ACCESS_TOKEN}" \
                           -H "Accept: application/vnd.github.mercy-preview+json" \
                           "https://api.github.com/repos/${ORG}/${repo}/topics" | jq -c '.[]')
    echo "${topics}"
}

function add_topic() {
    local repo_name="$1"
    local existing_topics="$2"

    local topics=$(echo ${existing_topics} | jq ". + [ \"${TOPIC}\" ]")

    echo "[+] Adding topics: ${topics}"

	curl -s -X PUT "https://api.github.com/repos/${ORG}/${repo_name}/topics" \
	-H "Authorization: token ${ACCESS_TOKEN}" \
    -H "Accept: application/vnd.github.mercy-preview+json" \
	--data "{\"names\": $(echo ${topics})}"
}

main
