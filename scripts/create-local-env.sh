#!/usr/bin/env bash
# Creates a local .env for this lab without printing or committing secrets.
set -euo pipefail

readonly TEMPLATE_FILE=".env.example"
readonly ENV_FILE=".env"

if [[ ! -f "$TEMPLATE_FILE" ]]; then
  echo "Error: run this script from the repository root containing $TEMPLATE_FILE." >&2
  exit 1
fi

if [[ -e "$ENV_FILE" ]]; then
  placeholders=(
    "ELASTIC_PASSWORD=replace-with-a-strong-local-password"
    "KIBANA_SYSTEM_PASSWORD=replace-with-a-strong-local-password"
    "LOGSTASH_INTERNAL_PASSWORD=replace-with-a-strong-local-password"
    "KIBANA_ENCRYPTED_SAVED_OBJECTS_KEY=replace-with-at-least-32-random-characters"
  )

  for value in "${placeholders[@]}"; do
    if ! grep -Fxq "$value" "$ENV_FILE"; then
      echo "Error: .env already contains custom values. It will not be overwritten." >&2
      exit 1
    fi
  done
fi

elastic_password="$(openssl rand -hex 32)"
kibana_password="$(openssl rand -hex 32)"
logstash_password="$(openssl rand -hex 32)"
kibana_encryption_key="$(openssl rand -hex 32)"

temporary_env="$(mktemp)"
trap 'rm -f "$temporary_env"' EXIT

sed \
  -e "s/^ELASTIC_PASSWORD=.*/ELASTIC_PASSWORD=$elastic_password/" \
  -e "s/^KIBANA_SYSTEM_PASSWORD=.*/KIBANA_SYSTEM_PASSWORD=$kibana_password/" \
  -e "s/^LOGSTASH_INTERNAL_PASSWORD=.*/LOGSTASH_INTERNAL_PASSWORD=$logstash_password/" \
  -e "s/^KIBANA_ENCRYPTED_SAVED_OBJECTS_KEY=.*/KIBANA_ENCRYPTED_SAVED_OBJECTS_KEY=$kibana_encryption_key/" \
  "$TEMPLATE_FILE" > "$temporary_env"

chmod 600 "$temporary_env"
mv "$temporary_env" "$ENV_FILE"
trap - EXIT

echo "Created .env with four unique local secrets (not displayed)."
echo "Next: sudo docker compose --env-file .env -f docker/compose.yml config --quiet"
