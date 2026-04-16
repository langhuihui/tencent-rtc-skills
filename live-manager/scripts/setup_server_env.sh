#!/usr/bin/env bash
# TUILiveKit Manager - Modify SDK_APP_ID and SECRET_KEY in server .env
# Usage: bash setup_server_env.sh <project_root> <sdk_app_id> <secret_key>

set -euo pipefail

PROJECT_ROOT="${1:?Error: project root path is required}"
SDK_APP_ID="${2:?Error: SDK_APP_ID is required}"
SECRET_KEY="${3:?Error: SECRET_KEY is required}"

ENV_FILE="${PROJECT_ROOT}/packages/server/config/.env"

if [ ! -f "$ENV_FILE" ]; then
  echo "❌ .env file not found: ${ENV_FILE}"
  exit 1
fi

# Use sed to replace the first two config lines in-place
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' "s/^SDK_APP_ID=.*/SDK_APP_ID=${SDK_APP_ID}/" "$ENV_FILE"
  sed -i '' "s/^SECRET_KEY=.*/SECRET_KEY=${SECRET_KEY}/" "$ENV_FILE"
else
  sed -i "s/^SDK_APP_ID=.*/SDK_APP_ID=${SDK_APP_ID}/" "$ENV_FILE"
  sed -i "s/^SECRET_KEY=.*/SECRET_KEY=${SECRET_KEY}/" "$ENV_FILE"
fi

echo "✅ Server .env updated: SDK_APP_ID and SECRET_KEY configured"
echo "   File: ${ENV_FILE}"
