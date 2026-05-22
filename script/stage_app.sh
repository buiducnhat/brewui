#!/usr/bin/env bash
set -euo pipefail

APP_NAME="${APP_NAME:-BrewUI}"
APP_VERSION="${APP_VERSION:-0.0.3}"
APP_BUILD="${APP_BUILD:-$APP_VERSION}"
BUNDLE_ID="${BUNDLE_ID:-io.github.buiducnhat.brewui}"
MIN_SYSTEM_VERSION="${MIN_SYSTEM_VERSION:-14.0}"
BUILD_CONFIGURATION="${BUILD_CONFIGURATION:-debug}"
SU_FEED_URL="${SU_FEED_URL:-https://buiducnhat.github.io/brewui/appcast.xml}"
SU_PUBLIC_ED_KEY="${SU_PUBLIC_ED_KEY:-}"
SU_ENABLE_AUTOMATIC_CHECKS="${SU_ENABLE_AUTOMATIC_CHECKS:-YES}"
SU_AUTOMATICALLY_UPDATE="${SU_AUTOMATICALLY_UPDATE:-NO}"
SU_ALLOWS_AUTOMATIC_UPDATES="${SU_ALLOWS_AUTOMATIC_UPDATES:-YES}"
SU_SCHEDULED_CHECK_INTERVAL="${SU_SCHEDULED_CHECK_INTERVAL:-86400}"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="${DIST_DIR:-$ROOT_DIR/dist}"
APP_BUNDLE="$DIST_DIR/$APP_NAME.app"
APP_CONTENTS="$APP_BUNDLE/Contents"
APP_MACOS="$APP_CONTENTS/MacOS"
APP_RESOURCES="$APP_CONTENTS/Resources"
APP_FRAMEWORKS="$APP_CONTENTS/Frameworks"
APP_BINARY="$APP_MACOS/$APP_NAME"
INFO_PLIST="$APP_CONTENTS/Info.plist"
APP_ICON_SOURCE="$ROOT_DIR/Assets/BrewUI.icns"
APP_ICON_NAME="BrewUI"

plist_boolean() {
  local normalized
  normalized="$(printf '%s' "$1" | tr '[:lower:]' '[:upper:]')"

  case "$normalized" in
    YES|TRUE|1)
      echo "true"
      ;;
    *)
      echo "false"
      ;;
  esac
}

swift build -c "$BUILD_CONFIGURATION"
BUILD_BIN_DIR="$(swift build -c "$BUILD_CONFIGURATION" --show-bin-path)"
BUILD_BINARY="$BUILD_BIN_DIR/$APP_NAME"

rm -rf "$APP_BUNDLE"
mkdir -p "$APP_MACOS" "$APP_RESOURCES" "$APP_FRAMEWORKS"
cp "$BUILD_BINARY" "$APP_BINARY"
chmod +x "$APP_BINARY"

if otool -l "$APP_BINARY" | grep -A2 "path @loader_path" >/dev/null 2>&1; then
  install_name_tool -rpath "@loader_path" "@executable_path/../Frameworks" "$APP_BINARY"
elif ! otool -l "$APP_BINARY" | grep -A2 "@executable_path/../Frameworks" >/dev/null 2>&1; then
  install_name_tool -add_rpath "@executable_path/../Frameworks" "$APP_BINARY"
fi

if [[ -f "$APP_ICON_SOURCE" ]]; then
  cp "$APP_ICON_SOURCE" "$APP_RESOURCES/$APP_ICON_NAME.icns"
fi

SPARKLE_FRAMEWORK_SOURCE="$(find "$ROOT_DIR/.build" -path '*Sparkle.xcframework/macos-arm64_x86_64/Sparkle.framework' -print -quit)"
if [[ -n "$SPARKLE_FRAMEWORK_SOURCE" ]]; then
  ditto "$SPARKLE_FRAMEWORK_SOURCE" "$APP_FRAMEWORKS/Sparkle.framework"
fi

{
  cat <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleExecutable</key>
  <string>$APP_NAME</string>
  <key>CFBundleIdentifier</key>
  <string>$BUNDLE_ID</string>
  <key>CFBundleName</key>
  <string>$APP_NAME</string>
  <key>CFBundleShortVersionString</key>
  <string>$APP_VERSION</string>
  <key>CFBundleVersion</key>
  <string>$APP_BUILD</string>
  <key>CFBundleIconFile</key>
  <string>$APP_ICON_NAME</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>LSMinimumSystemVersion</key>
  <string>$MIN_SYSTEM_VERSION</string>
  <key>NSPrincipalClass</key>
  <string>NSApplication</string>
  <key>SUFeedURL</key>
  <string>$SU_FEED_URL</string>
  <key>SUEnableAutomaticChecks</key>
  <$(plist_boolean "$SU_ENABLE_AUTOMATIC_CHECKS")/>
  <key>SUAutomaticallyUpdate</key>
  <$(plist_boolean "$SU_AUTOMATICALLY_UPDATE")/>
  <key>SUAllowsAutomaticUpdates</key>
  <$(plist_boolean "$SU_ALLOWS_AUTOMATIC_UPDATES")/>
  <key>SUScheduledCheckInterval</key>
  <integer>$SU_SCHEDULED_CHECK_INTERVAL</integer>
PLIST

  if [[ -n "$SU_PUBLIC_ED_KEY" ]]; then
    cat <<PLIST
  <key>SUPublicEDKey</key>
  <string>$SU_PUBLIC_ED_KEY</string>
PLIST
  fi

  cat <<PLIST
</dict>
</plist>
PLIST
} >"$INFO_PLIST"

codesign --force --deep --sign - "$APP_BUNDLE" >/dev/null 2>&1

echo "$APP_BUNDLE"
