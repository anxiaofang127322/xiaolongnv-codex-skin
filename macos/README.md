# 小龙女 Codex 皮肤：macOS

这是小龙女 Codex 皮肤的 macOS 运行端，支持 Intel 和 Apple Silicon 的官方 Codex 桌面客户端。

## 安装

1. 正常打开一次 Codex，然后完全退出。
2. 回到项目根目录，双击 `Mac用户点这里.command`。
3. 如果 macOS 首次阻止打开，请右键选择“打开”。

安装器会把运行端复制到 `~/.codex/codex-dream-skin-studio`。默认安装完成后立即启动皮肤，不会在桌面创建额外文件。

## 使用入口

以下入口保留在当前 `macos` 文件夹内：

- `Start Codex Dream Skin.command`：启动或重新应用皮肤。
- `Customize Codex Dream Skin.command`：选择另一张背景图。
- `Verify Codex Dream Skin.command`：验证注入并生成截图。
- `Restore Codex Dream Skin.command`：恢复官方外观。

## 测试

```bash
./tests/run-tests.sh
```

真实客户端验收：

```bash
./scripts/doctor-macos.sh --require-live
```

皮肤通过本机回环 CDP 注入，不修改官方 `.app`、`app.asar` 或代码签名。运行时使用 Codex 自带且经过签名与架构校验的 Node.js。
