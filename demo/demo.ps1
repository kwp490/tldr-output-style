# Show TLDR working and not working, side by side, on the same prompt.
#
# Both arms run against the same email in demo/prompt.md. The only difference
# is whether the output style is loaded.
#
#   OFF arm : plain `claude -p`
#   ON  arm : `claude --plugin-dir plugins/tldr -p`, which loads the style for
#             that one call without installing anything
#
# If you already have the plugin installed and enabled, the script disables it
# for the duration so the OFF arm is genuinely off, then restores it. The
# restore runs in a finally block, so it happens even on Ctrl-C or an error.
#
# Usage:  powershell -ExecutionPolicy Bypass -File demo\demo.ps1

$ErrorActionPreference = 'Stop'

$demoDir   = $PSScriptRoot
$repoRoot  = Split-Path -Parent $demoDir
$pluginDir = Join-Path $repoRoot 'plugins\tldr'
$promptPath = Join-Path $demoDir 'prompt.md'

if (-not (Test-Path $promptPath)) { throw "missing $promptPath" }
if (-not (Test-Path $pluginDir))  { throw "missing $pluginDir" }

$prompt = Get-Content $promptPath -Raw

function Write-Rule($text) {
    Write-Host ''
    Write-Host ('=' * 78) -ForegroundColor DarkGray
    Write-Host "  $text"
    Write-Host ('=' * 78) -ForegroundColor DarkGray
    Write-Host ''
}

# Was the plugin enabled before we started? Restore exactly this state at the end.
$wasEnabled = $false
try {
    $listing = (claude plugin list 2>&1 | Out-String)
    if ($listing -match 'tldr@tldr-plugins') {
        # The status line follows the plugin name in the listing.
        $block = ($listing -split 'tldr@tldr-plugins')[1]
        if ($block -match 'enabled') { $wasEnabled = $true }
    }
} catch {
    Write-Host 'Could not read plugin list; assuming the plugin is not installed.' -ForegroundColor Yellow
}

try {
    if ($wasEnabled) {
        Write-Host 'Temporarily disabling tldr@tldr-plugins so the OFF arm is really off...' -ForegroundColor DarkGray
        claude plugin disable tldr@tldr-plugins | Out-Null
    }

    Write-Rule 'WITHOUT TLDR  (default Claude)'
    claude -p $prompt

    Write-Rule 'WITH TLDR  (loaded from this repo, nothing installed)'
    claude --plugin-dir $pluginDir -p $prompt

    Write-Rule 'Done'
    Write-Host 'Look for: does the first line tell you what to DO, or does it warm up first?'
    Write-Host 'Are the action items numbered? Are the three deadlines called out?'
    Write-Host 'Did the dashboard tangent get parked instead of expanded?'
    Write-Host ''
}
finally {
    if ($wasEnabled) {
        Write-Host 'Restoring tldr@tldr-plugins to enabled...' -ForegroundColor DarkGray
        claude plugin enable tldr@tldr-plugins | Out-Null
    }
}
