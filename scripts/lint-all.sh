#!/usr/bin/env bash
# Lint every Dockerfile in the repository with Hadolint (runs in Docker).
set -euo pipefail

cd "$(dirname "$0")/.."

status=0
while IFS= read -r file; do
  echo "==> $file"
  if ! docker run --rm -i \
      -v "$(pwd)/.hadolint.yaml:/.config/hadolint.yaml:ro" \
      hadolint/hadolint < "$file"; then
    status=1
  fi
done < <(find . -name Dockerfile -not -path "./.git/*" | sort)

if [ "$status" -eq 0 ]; then
  echo "All Dockerfiles passed."
fi

exit "$status"
