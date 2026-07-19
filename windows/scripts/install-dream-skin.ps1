[CmdletBinding()]
param(
  [int]$Port = 9335,
  [switch]$NoShortcuts,
  [string]$Nickname
)

$ErrorActionPreference = 'Stop'
$PortExplicit = $PSBoundParameters.ContainsKey('Port')
$SkillRoot = Split-Path -Parent $PSScriptRoot
. (Join-Path $PSScriptRoot 'common-windows.ps1')

$operationLock = Enter-DreamSkinOperationLock
try {
  Assert-DreamSkinPort -Port $Port
  $node = Get-DreamSkinNodeRuntime
  $registeredInstalls = @(Get-DreamSkinRegisteredCodexInstalls)
  if ($registeredInstalls.Count -eq 0) {
    throw 'The official OpenAI.Codex Store package is not installed or its identity cannot be validated.'
  }
  foreach ($registeredCodex in $registeredInstalls) {
    if ((Get-DreamSkinCodexProcesses -Codex $registeredCodex).Count -gt 0) {
      throw 'Close Codex before installing Dream Skin so config.toml cannot change during the transaction.'
    }
  }

  $StateRoot = Join-Path $env:LOCALAPPDATA 'CodexDreamSkin'
  $StatePath = Join-Path $StateRoot 'state.json'
  $existingState = Read-DreamSkinState -Path $StatePath
  $savedPathCandidate = Get-DreamSkinCodexStatePathCandidate -State $existingState
  $savedCodex = Resolve-DreamSkinCodexInstallFromState -State $existingState -RegisteredInstalls $registeredInstalls
  if ($null -ne $savedPathCandidate -and $null -eq $savedCodex -and
    (Get-DreamSkinCodexProcesses -Codex $savedPathCandidate).Count -gt 0) {
    throw 'The saved Codex path is still running but no longer matches a registered Store package. Close it manually before installing.'
  }
  New-Item -ItemType Directory -Force -Path $StateRoot | Out-Null
  if (-not $Nickname) { $Nickname = $env:CODEX_DREAM_NICKNAME }
  if (-not $Nickname) {
    $Nickname = if (Test-Path -LiteralPath $DreamSkinPreferencesPath) { $null } else { '李嘉图' }
  }
  if ($Nickname) {
    & $node.Path (Join-Path $PSScriptRoot 'preferences.mjs') set-nickname `
      --path $DreamSkinPreferencesPath --nickname $Nickname *> $null
    if ($LASTEXITCODE -ne 0) { throw 'Could not save the Dream Skin nickname.' }
  }
  $ConfigPath = Join-Path $HOME '.codex\config.toml'
  $BackupPath = Join-Path $StateRoot 'config.before-dream-skin.toml'
  Install-DreamSkinBaseTheme -ConfigPath $ConfigPath -BackupPath $BackupPath

  if (-not $NoShortcuts) {
    $shell = New-Object -ComObject WScript.Shell
    $desktop = [Environment]::GetFolderPath('Desktop')
    $startMenu = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs'
    $usePowerShell7 = $PSVersionTable.PSVersion.Major -ge 7
    $powershell = if ($usePowerShell7) {
      (Get-Command pwsh.exe -ErrorAction Stop).Source
    } else {
      (Get-Command powershell.exe -ErrorAction Stop).Source
    }
    $startScript = Join-Path $PSScriptRoot $(if ($usePowerShell7) { 'start-dream-skin-pwsh7.ps1' } else { 'start-dream-skin.ps1' })
    $restoreScript = Join-Path $PSScriptRoot $(if ($usePowerShell7) { 'restore-dream-skin-pwsh7.ps1' } else { 'restore-dream-skin.ps1' })
    $portArgument = if ($PortExplicit) { " -Port $Port" } else { '' }

    foreach ($folder in @($desktop, $startMenu)) {
      $shortcut = $shell.CreateShortcut((Join-Path $folder '启动小龙女皮肤.lnk'))
      $shortcut.TargetPath = $powershell
      $shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$startScript`"$portArgument -RestartExisting"
      $shortcut.WorkingDirectory = $SkillRoot
      $shortcut.Description = 'Launch the official Codex app with Codex Dream Skin'
      $shortcut.Save()
    }

    $restore = $shell.CreateShortcut((Join-Path $desktop '恢复官方 Codex 外观.lnk'))
    $restore.TargetPath = $powershell
    $restore.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$restoreScript`"$portArgument -RestoreBaseTheme -PromptRestart"
    $restore.WorkingDirectory = $SkillRoot
    $restore.Description = 'Restore the official Codex appearance and close the CDP session'
    $restore.Save()
  }

  if ($NoShortcuts) {
    Write-Host 'Codex Dream Skin base theme installed. Run start-dream-skin.ps1 to launch it.'
  } else {
    Write-Host 'Codex Dream Skin installed. The launch shortcut asks before restarting an open Codex window.'
  }
} finally {
  Exit-DreamSkinOperationLock -Mutex $operationLock
}
