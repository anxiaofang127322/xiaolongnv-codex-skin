#requires -Version 7.0
[CmdletBinding()]
param(
  [int]$Port = 9335,
  [switch]$RestartExisting,
  [switch]$PromptRestart,
  [string]$ProfilePath,
  [switch]$ForegroundInjector
)

$arguments = @{}
foreach ($entry in $PSBoundParameters.GetEnumerator()) { $arguments[$entry.Key] = $entry.Value }
& (Join-Path $PSScriptRoot 'start-dream-skin.ps1') @arguments
exit $LASTEXITCODE
