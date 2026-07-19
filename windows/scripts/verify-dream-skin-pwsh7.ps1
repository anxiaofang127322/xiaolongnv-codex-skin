#requires -Version 7.0
[CmdletBinding()]
param(
  [int]$Port = 9335,
  [string]$ScreenshotPath
)

$arguments = @{}
foreach ($entry in $PSBoundParameters.GetEnumerator()) { $arguments[$entry.Key] = $entry.Value }
& (Join-Path $PSScriptRoot 'verify-dream-skin.ps1') @arguments
exit $LASTEXITCODE
