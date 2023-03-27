#!/bin/bash

set -e

for proj in asias avsvsrp facility; do
  for env in dev qa beta prod; do
    host="$(pd config "/${proj}/${env}/_meta/deployment/docker_host_hostname")"
    . <(
      clconf \
        --ignore-env \
        --yaml <(ssh "${host}" <<'EOF'
printf '{"current":"%s","latest":"%s"}' \
  "$(uname -r)" \
  "$(ls -1 /boot/vmlinuz-*.x86_64 | sort | tail -n 1 | sed 's/.*vmlinuz-//')"
EOF
          ) \
        getv / \
        --template <(cat <<'EOF'
current={{getv "/current"}}
latest={{getv "/latest"}}
EOF
          )
      )

    if [[ "${current}" == "${latest}" ]]; then
      echo "${host}: up to date"
    else
      echo "${host}: needs update ${current} -> ${latest}"
    fi
  done
done
