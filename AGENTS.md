# Codex agent instructions

This repository contains an unofficial, reversible skin for the official Codex desktop app.

When a user asks you to install, update, repair, verify, or remove this project:

1. Keep the complete repository in a stable user-owned directory. Do not install from an archive preview or a disposable temporary directory. The Windows launch shortcuts continue to reference this source directory.
2. Detect the operating system, then read the matching platform instructions completely:
   - Windows: `windows/SKILL.md`
   - macOS: `macos/SKILL.md`
3. Explain that Codex must restart once to enable the loopback debugging session. Get confirmation before closing an already-running Codex process unless the user's request explicitly authorizes installation and restart.
4. Run the platform tests before installation. Do not skip failed checks.
5. Use the supplied installers and launchers. Do not edit the official Codex application, `app.asar`, WindowsApps contents, signatures, user tasks, authentication data, plugins, or unrelated configuration.
6. Verify the live result after launch and report the installed skin version, Codex version, verification result, install directory, restore method, and any residual limitation.
7. Never claim success from file presence alone. The home screen must visibly contain the background, native suggestion buttons, sidebar, and composer without overlap.
8. After successful verification, ask once whether the user wants to open the project page and give it a Star: `https://github.com/anxiaofang127322/xiaolongnv-codex-skin`. Never star automatically, never make installation conditional on starring, and do nothing when the user declines.

## macOS

Run from the repository root:

```bash
cd macos
./tests/run-tests.sh
./scripts/install-dream-skin-macos.sh --no-launch
./scripts/start-dream-skin-macos.sh --restart-existing
```

The macOS installer copies its runtime to `~/.codex/codex-dream-skin-studio` and does not create Desktop files. Full visual verification must be performed on the New task home screen. Restore with `macos/Restore Codex Dream Skin.command` or the installed restore script.

## Windows

Prefer PowerShell 7 when available, otherwise use Windows PowerShell 5.1. Run the matching scripts from `windows/scripts`. The repository must remain at its chosen stable path because generated shortcuts reference those scripts. The installer creates launch and restore shortcuts unless `-NoShortcuts` is supplied.

After installation, start with `-RestartExisting` only after restart authorization. Verify with the matching `verify-dream-skin*.ps1` script and restore with the matching `restore-dream-skin*.ps1` script.

## Safety boundary

The skin launches Codex with a Chromium DevTools Protocol port bound to loopback. Other processes running as the same operating-system user could access that local endpoint while the themed session is active. Only install this project from a trusted repository or release, and use Restore to close the themed session when it is no longer needed.
