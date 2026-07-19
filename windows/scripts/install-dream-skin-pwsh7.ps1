#requires -Version 7.0
[CmdletBinding()]
param(
  [int]$Port = 9335,
  [switch]$NoShortcuts
)

$arguments = @{}
foreach ($entry in $PSBoundParameters.GetEnumerator()) { $arguments[$entry.Key] = $entry.Value }
& (Join-Path $PSScriptRoot 'install-dream-skin.ps1') @arguments
exit $LASTEXITCODE
