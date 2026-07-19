#!/bin/bash

set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd -P)"
VERSION="$(tr -d '\r\n' < "$ROOT/VERSION")"
OUTPUT="${1:-$ROOT/release/xiaolongnv-codex-skin-$VERSION.zip}"
TMP="$(/usr/bin/mktemp -d /tmp/xiaolongnv-codex-skin.XXXXXX)"
STAGE="$TMP/xiaolongnv-codex-skin-$VERSION"
trap '/bin/rm -rf "$TMP"' EXIT

"$ROOT/macos/tests/run-tests.sh"
/bin/mkdir -p "$STAGE" "$(dirname "$OUTPUT")"
/usr/bin/rsync -a \
  --exclude '.git/' \
  --exclude '.DS_Store' \
  --exclude '._*' \
  --exclude '*.log' \
  --exclude '*.zip' \
  --exclude 'release/' \
  --exclude 'work/' \
  --exclude 'screenshots/' \
  "$ROOT/" "$STAGE/"
/usr/bin/xattr -cr "$STAGE"
/usr/bin/find "$STAGE" -type f \( -name '.DS_Store' -o -name '._*' \) -delete
/bin/rm -f "$OUTPUT"
COPYFILE_DISABLE=1 /usr/bin/ditto -c -k --keepParent --norsrc --noextattr "$STAGE" "$OUTPUT"
/usr/bin/shasum -a 256 "$OUTPUT"
