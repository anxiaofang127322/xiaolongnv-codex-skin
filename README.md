# 小龙女 Codex 皮肤

适用于官方 Codex 桌面客户端的可交互主题，支持 Windows 和 macOS。背景、欢迎区、Codex logo、原生建议按钮和连接线统一设计，侧栏、输入框、按钮和任务内容仍使用 Codex 原生控件。

![小龙女 Codex 皮肤预览](docs/images/xiaolongnv-preview.png)

> 非 OpenAI 官方项目。皮肤通过仅绑定本机回环地址的 Chromium DevTools Protocol 注入，不修改官方 Codex 安装包、`app.asar` 或应用签名。

## 让 Codex 自动安装

把下面这句话发给 Codex，将地址换成你的仓库地址：

```text
请安装这个 Codex 皮肤：<GitHub 仓库地址>。请下载完整仓库，阅读根目录 AGENTS.md，按当前系统完成测试、安装和首页验证，重启前先告诉我，并说明使用方法、注意事项和恢复方式。
```

更完整的提示词和更新方式见 [CODEX_INSTALL.md](CODEX_INSTALL.md)。仅发送裸链接不能保证 Codex 理解为安装请求，建议至少附带“请安装这个皮肤”。

## 手动安装

先从 GitHub Releases 下载 ZIP 并完整解压，不要直接在压缩包预览窗口中运行。

### Windows

1. 完全退出 Codex。
2. 双击 `Windows用户点这里.cmd`。
3. 安装器优先使用 PowerShell 7；没有 PowerShell 7 时自动使用系统 PowerShell 5.1。
4. 安装完成后，通过桌面的“启动小龙女皮肤”打开主题版 Codex。
5. 通过桌面的“恢复官方 Codex 外观”结束主题会话并恢复。

Windows 源码目录必须保留在稳定位置，不能安装后删除，因为快捷方式会继续调用其中的脚本。

### macOS

1. 正常打开一次官方 Codex，然后完全退出。
2. 双击 `Mac用户点这里.command`。
3. 如果 macOS 首次阻止打开，请右键该文件并选择“打开”。
4. 安装完成后会立即启动皮肤，不会在桌面创建额外文件。
5. 以后可再次运行 `Mac用户点这里.command`，或者使用 `macos` 文件夹中的启动、换图、验证和恢复入口。

Mac 版使用 Codex 自带且经过签名校验的 Node.js，不要求额外安装 Node.js。

## 支持状态

| 系统 | 入口 | 状态 |
| --- | --- | --- |
| Windows + PowerShell 7 | `Windows用户点这里.cmd` | 已通过测试 |
| Windows + PowerShell 5.1 | `Windows用户点这里.cmd` | 已通过测试 |
| macOS Intel / Apple Silicon | `Mac用户点这里.command` | 已在 Codex `26.715.31925` 实机验收 |

Codex 更新可能改变首页 DOM。更新后如果皮肤失效，请更新本仓库并重新运行安装入口；不要尝试修改官方应用文件。

## 使用和注意事项

- 完整皮肤显示在“新建任务”首页；普通任务页保留较克制的主题配色。
- 建议按钮来自当前 Codex 原生界面，数量会随客户端版本和窗口宽度变化，通常为 2 至 4 个。
- 固定欢迎语为“欢迎回来，李嘉图”。Mac 版支持使用 `macos/Customize Codex Dream Skin.command` 更换背景。
- 主题会话会在本机开启一个回环 CDP 端口。它不会暴露到局域网，但同一系统用户下的其他进程可能访问该端口。只运行可信本地软件，不使用时可执行恢复入口关闭主题会话。
- 安装、更新或恢复可能需要重启 Codex；任务和登录状态不会被安装器删除。
- 安装完成后可能询问是否打开 GitHub 项目页支持一个 Star。该操作完全自愿，安装器不会自动点赞，拒绝也不会影响使用。
- 提交问题时不要上传包含私人任务内容的截图、日志、状态文件或配置备份。

更多安全说明见 [SECURITY.md](SECURITY.md)。

## 恢复官方外观

- Windows：双击桌面的“恢复官方 Codex 外观”。
- macOS：双击 `macos/Restore Codex Dream Skin.command`。

恢复会停止本项目验证过的注入进程并正常启动官方 Codex，不会删除用户任务。

## 开发和发布

Windows 测试：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File windows\tests\run-tests.ps1
pwsh.exe -NoProfile -ExecutionPolicy Bypass -File windows\tests\run-tests.ps1
```

macOS 测试：

```bash
cd macos
./tests/run-tests.sh
```

在 macOS 生成跨平台发布包：

```bash
./scripts/build-release.sh
```

## 许可证与素材

项目代码基于 [Fei-Away/Codex-Dream-Skin](https://github.com/Fei-Away/Codex-Dream-Skin) 修改，代码继续采用 MIT License，详见 [LICENSE](LICENSE) 与 [NOTICE.md](NOTICE.md)。

默认人物背景、Codex 标志和其他视觉素材不自动获得 MIT 代码许可证。发布者必须确认自己拥有这些素材的再分发权，并在仓库中保留清晰的素材来源和授权说明。本项目不是 OpenAI 官方产品，相关商标归各自权利人所有。
