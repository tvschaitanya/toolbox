#!/usr/bin/env bash
set -euo pipefail

echo "⚠️  This will permanently delete all AWS credentials and config."
read -rp "Are you sure? (y/N): " CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo "Cancelled."
  exit 0
fi

# ── Remove ~/.aws ─────────────────────────────────────────
if [ -d "$HOME/.aws" ]; then
  echo "Removing ~/.aws directory..."
  rm -rf "$HOME/.aws"
fi

# ── Remove cache ──────────────────────────────────────────
CACHE_PATH="$HOME/Library/Caches/awscli"
if [ -d "$CACHE_PATH" ]; then
  echo "Removing AWS CLI cache..."
  rm -rf "$CACHE_PATH"
fi

# ── Remove history ────────────────────────────────────────
if [ -f "$HOME/.awscli/history" ]; then
  echo "Removing AWS CLI history..."
  rm -f "$HOME/.awscli/history"
fi

# ── Unset env variables ───────────────────────────────────
echo "Unsetting AWS environment variables..."
unset AWS_ACCESS_KEY_ID        || true
unset AWS_SECRET_ACCESS_KEY    || true
unset AWS_SESSION_TOKEN        || true
unset AWS_SECURITY_TOKEN       || true
unset AWS_SESSION_EXPIRATION   || true
unset AWS_DEFAULT_REGION       || true
unset AWS_REGION               || true
unset AWS_PROFILE              || true
unset AWS_CONFIG_FILE          || true
unset AWS_SHARED_CREDENTIALS_FILE || true
unset AWS_CA_BUNDLE            || true
unset AWS_METADATA_SERVICE_TIMEOUT || true
unset AWS_METADATA_SERVICE_NUM_ATTEMPTS || true

# ── Strip from shell profiles ─────────────────────────────
AWS_VARS=(
  AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY
  AWS_SESSION_TOKEN
  AWS_SECURITY_TOKEN
  AWS_SESSION_EXPIRATION
  AWS_DEFAULT_REGION
  AWS_REGION
  AWS_PROFILE
  AWS_CONFIG_FILE
  AWS_SHARED_CREDENTIALS_FILE
  AWS_CA_BUNDLE
  AWS_METADATA_SERVICE_TIMEOUT
  AWS_METADATA_SERVICE_NUM_ATTEMPTS
)

SHELL_FILES=(~/.zshrc ~/.bash_profile ~/.bashrc ~/.profile)
echo "Stripping AWS variables from shell config files..."
for file in "${SHELL_FILES[@]}"; do
  if [ -f "$file" ]; then
    for var in "${AWS_VARS[@]}"; do
      sed -i '' "/$var/d" "$file"
    done
  fi
done

echo ""
echo "✅ Done. All AWS credentials, config, cache and env vars removed."
echo "👉 Restart your terminal or run: source ~/.zshrc"