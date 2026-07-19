#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd -P)"
"$ROOT/macos/Install Codex Dream Skin.command"

CHOICE="$(/usr/bin/osascript <<'APPLESCRIPT' 2>/dev/null || true
button returned of (display dialog "小龙女 Codex 皮肤已经安装完成。要打开 GitHub 项目页，给这个开源项目点一颗 Star 吗？" buttons {"不用了", "打开项目页"} default button "打开项目页" with title "安装完成")
APPLESCRIPT
)"
if [ "$CHOICE" = "打开项目页" ]; then
  /usr/bin/open "https://github.com/anxiaofang127322/xiaolongnv-codex-skin"
fi
