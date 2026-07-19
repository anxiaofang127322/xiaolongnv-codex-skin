@echo off
setlocal
chcp 65001 >nul
cd /d "%~dp0"

echo.
echo 小龙女 Codex 皮肤安装程序
echo 请先完全退出 Codex，再继续安装。
echo.
set "NICKNAME="
set /p "NICKNAME=默认名称为【李嘉图】。请告诉我您要修改成什么昵称（直接回车保留默认）："
if not defined NICKNAME set "NICKNAME=李嘉图"
set "CODEX_DREAM_NICKNAME=%NICKNAME%"
echo.

where pwsh.exe >nul 2>nul
if %errorlevel% equ 0 (
  echo 已检测到 PowerShell 7，使用 PowerShell 7 安装。
  pwsh.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0windows\scripts\install-dream-skin-pwsh7.ps1"
  if errorlevel 1 goto :failed
  pwsh.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0windows\scripts\start-dream-skin-pwsh7.ps1"
) else (
  echo 未检测到 PowerShell 7，使用系统 PowerShell 5.1 安装。
  "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "%~dp0windows\scripts\install-dream-skin.ps1"
  if errorlevel 1 goto :failed
  "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "%~dp0windows\scripts\start-dream-skin.ps1"
)

if errorlevel 1 goto :failed
echo.
echo 安装完成。以后请使用桌面的“启动小龙女皮肤”。
choice /C YN /N /M "要打开 GitHub 项目页，给这个开源项目点一颗 Star 吗？[Y/N] "
if errorlevel 2 goto :done
start "" "https://github.com/anxiaofang127322/xiaolongnv-codex-skin"
:done
pause
exit /b 0

:failed
echo.
echo 安装没有完成。请确认 Codex 已完全退出，然后重新双击本文件。
pause
exit /b 1
