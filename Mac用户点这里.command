#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd -P)"
if ! NICKNAME="$(/usr/bin/osascript <<'APPLESCRIPT' 2>/dev/null
text returned of (display dialog "默认名称为【李嘉图】。请告诉我您要修改成什么昵称？" default answer "李嘉图" buttons {"取消", "继续安装"} default button "继续安装" with title "设置欢迎昵称")
APPLESCRIPT
)"; then
  exit 1
fi
[ -n "$NICKNAME" ] || NICKNAME="李嘉图"
"$ROOT/macos/Install Codex Dream Skin.command" --nickname "$NICKNAME"

CHOICE="$(/usr/bin/osascript <<'APPLESCRIPT' 2>/dev/null || true
button returned of (display dialog "小龙女 Codex 皮肤已经安装完成。要打开 GitHub 项目页，给这个开源项目点一颗 Star 吗？" buttons {"不用了", "打开项目页"} default button "打开项目页" with title "安装完成")
APPLESCRIPT
)"
if [ "$CHOICE" = "打开项目页" ]; then
  /usr/bin/open "https://github.com/anxiaofang127322/xiaolongnv-codex-skin"
fi
