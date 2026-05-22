#!/usr/bin/env bash
set -euo pipefail

require_env() {
  local name="$1"
  if [[ -z "${!name:-}" ]]; then
    echo "missing required environment variable: $name" >&2
    exit 1
  fi
}

APP_NAME="${APP_NAME:-BrewUI}"
APP_VERSION="${APP_VERSION:-${GITHUB_REF_NAME#v}}"
APP_BUILD="${APP_BUILD:-$APP_VERSION}"
BUNDLE_ID="${BUNDLE_ID:-io.github.buiducnhat.brewui}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RELEASE_ROOT="${RELEASE_ROOT:-$ROOT_DIR/build/release/$APP_VERSION}"
DIST_DIR="$RELEASE_ROOT/dist"
ARTIFACTS_DIR="$RELEASE_ROOT/artifacts"
APP_BUNDLE="$DIST_DIR/$APP_NAME.app"
NOTARY_ZIP="$ARTIFACTS_DIR/$APP_NAME-$APP_VERSION-notary.zip"
RELEASE_ZIP="$ARTIFACTS_DIR/$APP_NAME-$APP_VERSION.zip"
PRIVATE_KEY_FILE="$ARTIFACTS_DIR/sparkle-private-key.txt"

require_env APP_VERSION
require_env APPLE_SIGNING_IDENTITY
require_env SPARKLE_PUBLIC_ED_KEY
require_env SPARKLE_PRIVATE_ED_KEY

mkdir -p "$ARTIFACTS_DIR"

SU_FEED_URL="${SU_FEED_URL:-https://buiducnhat.github.io/brewui/appcast.xml}" \
SU_PUBLIC_ED_KEY="$SPARKLE_PUBLIC_ED_KEY" \
APP_NAME="$APP_NAME" \
APP_VERSION="$APP_VERSION" \
APP_BUILD="$APP_BUILD" \
BUNDLE_ID="$BUNDLE_ID" \
BUILD_CONFIGURATION=release \
DIST_DIR="$DIST_DIR" \
"$ROOT_DIR/script/stage_app.sh" >/dev/null

codesign --force --deep --options runtime --timestamp --sign "$APPLE_SIGNING_IDENTITY" "$APP_BUNDLE"
codesign --verify --deep --strict --verbose=2 "$APP_BUNDLE"

ditto -c -k --keepParent "$APP_BUNDLE" "$NOTARY_ZIP"

if [[ -n "${APPLE_NOTARY_KEY_ID:-}" || -n "${APPLE_NOTARY_ISSUER_ID:-}" || -n "${APPLE_NOTARY_API_KEY_P8_BASE64:-}" ]]; then
  require_env APPLE_NOTARY_KEY_ID
  require_env APPLE_NOTARY_ISSUER_ID
  require_env APPLE_NOTARY_API_KEY_P8_BASE64

  NOTARY_KEY_PATH="$ARTIFACTS_DIR/AuthKey_${APPLE_NOTARY_KEY_ID}.p8"
  printf '%s' "$APPLE_NOTARY_API_KEY_P8_BASE64" | base64 --decode >"$NOTARY_KEY_PATH"
  xcrun notarytool submit "$NOTARY_ZIP" \
    --key "$NOTARY_KEY_PATH" \
    --key-id "$APPLE_NOTARY_KEY_ID" \
    --issuer "$APPLE_NOTARY_ISSUER_ID" \
    --wait
  xcrun stapler staple "$APP_BUNDLE"
  spctl --assess --type execute --verbose "$APP_BUNDLE"
  rm -f "$NOTARY_KEY_PATH"
fi

rm -f "$RELEASE_ZIP"
ditto -c -k --keepParent "$APP_BUNDLE" "$RELEASE_ZIP"

printf '%s' "$SPARKLE_PRIVATE_ED_KEY" >"$PRIVATE_KEY_FILE"
chmod 600 "$PRIVATE_KEY_FILE"

SIGN_UPDATE_BIN="$(find "$ROOT_DIR/.build" -path '*/bin/sign_update' -print -quit)"
if [[ -z "$SIGN_UPDATE_BIN" ]]; then
  echo "unable to locate Sparkle sign_update tool in .build artifacts" >&2
  exit 1
fi

SPARKLE_SIGNATURE="$("$SIGN_UPDATE_BIN" --ed-key-file "$PRIVATE_KEY_FILE" "$RELEASE_ZIP")"
printf '%s\n' "$SPARKLE_SIGNATURE" >"$ARTIFACTS_DIR/sparkle-signature.txt"

rm -f "$PRIVATE_KEY_FILE"

echo "$RELEASE_ZIP"
