#!/usr/bin/env bash
# Prints the latest upstream Amazon Linux 2 cloud-image version on stdout.
#
# AL2 is past AWS standard support (EOL 2025-06-30) but AWS continues to
# publish images for clients on extended support. URL pattern:
#   https://cdn.amazonlinux.com/os-images/<version>/kvm/amzn2-kvm-<version>-x86_64.xfs.gpt.qcow2
# The CDN exposes a `/latest/` symlink that 302-redirects to the current
# directory; we follow the redirect and extract the version segment.
# Format: 2.0.YYYYMMDD.N.
#
# Runs in the upstream-watch reusable workflow (no KVM needed) — keep
# it portable bash + curl only.

set -euo pipefail

URL='https://cdn.amazonlinux.com/os-images/latest/'

location=$(curl -fsI "$URL" | awk -F': ' 'tolower($1)=="location"{sub(/\r$/,"",$2); print $2; exit}')
if [[ -z "${location:-}" ]]; then
  echo "::error::no Location header on $URL — upstream may have changed the layout" >&2
  exit 1
fi

# Expected: https://cdn.amazonlinux.com/os-images/<VERSION>/
version=$(printf '%s' "$location" | sed -E 's|.*/os-images/([^/]+)/.*|\1|')
if [[ -z "$version" || "$version" == "$location" ]]; then
  echo "::error::could not extract version from redirect target: $location" >&2
  exit 1
fi

printf '%s\n' "$version"
