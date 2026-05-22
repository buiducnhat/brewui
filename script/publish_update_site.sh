#!/usr/bin/env bash
set -euo pipefail

require_env() {
  local name="$1"
  if [[ -z "${!name:-}" ]]; then
    echo "missing required environment variable: $name" >&2
    exit 1
  fi
}

require_env APP_VERSION
require_env RELEASE_ZIP
require_env RELEASE_NOTES_FILE
require_env SPARKLE_PRIVATE_ED_KEY

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PAGES_DIR="${PAGES_DIR:-$ROOT_DIR/build/gh-pages}"
APPCAST_BASE_URL="${APPCAST_BASE_URL:-https://buiducnhat.github.io/brewui}"
RELEASE_TAG="${RELEASE_TAG:-v$APP_VERSION}"
REPOSITORY_URL="$(git -C "$ROOT_DIR" remote get-url origin)"

rm -rf "$PAGES_DIR"
git clone "$REPOSITORY_URL" "$PAGES_DIR" >/dev/null 2>&1

if git -C "$PAGES_DIR" ls-remote --exit-code --heads origin gh-pages >/dev/null 2>&1; then
  git -C "$PAGES_DIR" checkout gh-pages >/dev/null 2>&1
else
  git -C "$PAGES_DIR" checkout --orphan gh-pages >/dev/null 2>&1
  git -C "$PAGES_DIR" rm -rf . >/dev/null 2>&1 || true
fi

git -C "$PAGES_DIR" config user.name "${GIT_AUTHOR_NAME:-github-actions[bot]}"
git -C "$PAGES_DIR" config user.email "${GIT_AUTHOR_EMAIL:-41898282+github-actions[bot]@users.noreply.github.com}"

cp "$RELEASE_ZIP" "$PAGES_DIR/"
cp "$RELEASE_NOTES_FILE" "$PAGES_DIR/$(basename "${RELEASE_ZIP%.zip}").md"
touch "$PAGES_DIR/.nojekyll"

PRIVATE_KEY_FILE="$PAGES_DIR/.sparkle-private-key"
printf '%s' "$SPARKLE_PRIVATE_ED_KEY" >"$PRIVATE_KEY_FILE"
chmod 600 "$PRIVATE_KEY_FILE"

GENERATE_APPCAST_BIN="$(find "$ROOT_DIR/.build" -path '*/bin/generate_appcast' -print -quit)"
if [[ -z "$GENERATE_APPCAST_BIN" ]]; then
  echo "unable to locate Sparkle generate_appcast tool in .build artifacts" >&2
  exit 1
fi

"$GENERATE_APPCAST_BIN" \
  --ed-key-file "$PRIVATE_KEY_FILE" \
  --link "https://github.com/${GITHUB_REPOSITORY:-buiducnhat/brewui}/releases/tag/$RELEASE_TAG" \
  --download-url-prefix "$APPCAST_BASE_URL" \
  --release-notes-url-prefix "$APPCAST_BASE_URL" \
  "$PAGES_DIR"

rm -f "$PRIVATE_KEY_FILE"

git -C "$PAGES_DIR" add .
if git -C "$PAGES_DIR" diff --cached --quiet; then
  exit 0
fi

git -C "$PAGES_DIR" commit -m "docs(updates): publish $APP_VERSION" >/dev/null
git -C "$PAGES_DIR" push origin gh-pages >/dev/null
