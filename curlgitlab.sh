#!/bin/bash

# looking up all /runners results in a list of a bunch of unused runners, so
# hardcode this for now as we only ever use this one for portal work
# caasd-portal-automation portal-ci-runner-threaded
#readonly RUNNER_ID="${RUNNER_ID:-146}"
# pd-ci ciman-ci-runner
readonly RUNNER_ID="${RUNNER_ID:-6345}"

set -e

function curl_gitlab {
  local endpoint=$1
  local curl_args=("${@:2}")

  curl \
    --header "Authorization: Bearer $(grep token ~/.config/lab/lab.toml | sed 's/.*"\(.*\)"/\1/g')" \
    --silent \
    "https://gitlab.mitre.org/api/v4${endpoint}" \
    "${curl_args[@]}"
}

function job_log {
  local project_name_with_namespace="${1/\//%2f}"
  local job_id=$2
  local curl_args=("${@:3}")

  curl_gitlab "/projects/${project_name_with_namespace}/jobs/${job_id}/trace" "${curl_args[@]}"
}

function projects {
  local project_name_with_namespace="${1/\//%2f}"
  local curl_args=("${@:2}")

  curl_gitlab "/projects/${project_name_with_namespace}"
}

function running_job {
  local curl_args=("$@")

  curl_gitlab "/runners/${RUNNER_ID}/jobs?status=running" "${curl_args[@]}"
}

function trigger {
  local project_name_with_namespace="${1/\//%2f}"
  local ref="${2:-master}"
  local curl_args=("${@:2}")

  local trigger_token
  trigger_token="$(
    curl_gitlab /projects/${project_name_with_namespace}/triggers \
      | clconf --pipe jsonpath '$[?(@.description == "CascadingCI")].token' --first)"

  echo "curl --form 'token=${trigger_token}' --form 'ref=${ref}' --request post https://gitlab.mitre.org/api/v4/projects/${project_name_with_namespace}/trigger/pipeline"
  curl \
    --fail \
    --form "ref=${ref}" \
    --form "token=${trigger_token}" \
    --request POST \
    --silent \
    "${curl_args[@]}" \
    "https://gitlab.mitre.org/api/v4/projects/${project_name_with_namespace}/trigger/pipeline"
}

function main {
  if [[ "$(type -t "$1")" == 'function' ]]; then
    "$1" "${@:2}"
    return
  fi

  curl_gitlab "$@"
}

main "$@"
