# GitHub 发布清单

## 发布前

1. 确认 `macos/assets/dream-reference.png` 和 `windows/assets/dream-reference.png` 的生成来源及公开再分发权。MIT License 只自动覆盖代码，不自动覆盖人物图片或商标素材。
2. 在 Windows 和 macOS 各使用一个全新解压目录完成安装、首页截图、恢复官方外观测试。
3. 确认仓库中没有日志、状态文件、配置备份、私人任务截图、`.DS_Store` 或密钥。

## 仓库建议

- 仓库名称：`xiaolongnv-codex-skin`
- 简介：`A reversible Xiaolongnv-inspired skin for the official Codex desktop app on Windows and macOS.`
- Topics：`codex`、`codex-desktop`、`theme`、`macos`、`windows`
- 默认分支：`main`
- License：MIT（代码）；视觉素材按 `NOTICE.md` 和素材来源说明单独处理

## Release

创建标签和 Release：`v1.2.2`。

上传：

- `xiaolongnv-codex-skin-1.2.2.zip`
- `xiaolongnv-codex-skin-1.2.2.zip.sha256`

推荐 Release 文案：

```markdown
## 小龙女 Codex 皮肤 1.2.2

支持 Windows 和 macOS 的非官方 Codex 桌面主题。

### 安装

下载 ZIP 并完整解压，然后运行：

- Windows：`Windows用户点这里.cmd`
- macOS：`Mac用户点这里.command`

也可以把仓库地址发给 Codex，并说：“请安装这个 Codex 皮肤，阅读根目录 AGENTS.md 后按当前系统完成测试、安装和验证。”

### 说明

- 不修改官方 Codex 安装包、`app.asar` 或应用签名。
- 安装和恢复可能需要重启 Codex。
- 完整视觉显示在“新建任务”首页。
- 主题通过本机回环 CDP 工作，只应从可信来源安装。
```

## 发布后验证

1. 从 GitHub Release 下载 ZIP，不使用本地源码目录。
2. 核对 SHA-256。
3. 完整解压后测试 Windows 与 macOS 入口。
4. 把公开仓库地址发给一个新的 Codex 任务，使用 [CODEX_INSTALL.md](CODEX_INSTALL.md) 中的提示词测试自动安装。
