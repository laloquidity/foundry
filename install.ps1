# Foundry Install Script (PowerShell)
# Installs the Foundry project-bootstrap framework into your current directory.
# Does NOT touch your README, .gitignore, git history, or any existing files.
#
# Usage:
#   Invoke-Expression (Invoke-WebRequest -Uri https://raw.githubusercontent.com/laloquidity/foundry/main/install.ps1 -UseBasicParsing).Content
#
# Options:
#   --update    Overwrite existing .foundry/ files with latest version

param(
    [switch]$update,
    [switch]$force,
    [switch]$help
)

$REPO = "laloquidity/foundry"
$BRANCH = "main"
$FORCE = $update -or $force

if ($help) {
    Write-Host "Foundry Install Script"
    Write-Host ""
    Write-Host "Installs the Foundry project-bootstrap framework into your current directory."
    Write-Host "Creates .foundry/ and .agents/workflows/ -- nothing else."
    Write-Host ""
    Write-Host "Usage:"
    Write-Host "  install.ps1           Install (won't overwrite existing)"
    Write-Host "  install.ps1 --update  Update to latest version"
    Write-Host ""
    exit 0
}

# Check for existing installation
if ((Test-Path ".foundry/prompts") -and -not $FORCE) {
    Write-Host "WARNING: Foundry is already installed in this directory."
    Write-Host "   Run with --update to pull the latest version."
    exit 1
}

Write-Host "Installing Foundry..."

# Download to temp directory
$TMP = Join-Path $env:TEMP ("foundry-" + [System.Guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $TMP | Out-Null

try {
    $TARBALL = Join-Path $TMP "foundry.tar.gz"
    Invoke-WebRequest -Uri "https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz" -OutFile $TARBALL -UseBasicParsing

    # Extract (requires tar, available on Windows 10 1803+)
    tar xzf $TARBALL -C $TMP
    $SRC = Join-Path $TMP "foundry-$BRANCH"

    # Install framework files
    if (-not (Test-Path ".foundry")) { New-Item -ItemType Directory -Path ".foundry" | Out-Null }
    Copy-Item -Path "$SRC/.foundry/*" -Destination ".foundry/" -Recurse -Force
    Write-Host "  OK .foundry/ installed (SKILL.md, prompts, templates, scripts)"

    # Install workflows (additive -- won't remove user's existing workflows)
    if (-not (Test-Path ".agents/workflows")) { New-Item -ItemType Directory -Path ".agents/workflows" -Force | Out-Null }
    Get-ChildItem "$SRC/.agents/workflows/" | ForEach-Object {
        $dest = ".agents/workflows/$($_.Name)"
        if ((Test-Path $dest) -and -not $FORCE) {
            Write-Host "  . $dest exists, skipping (use --update to overwrite)"
        } else {
            Copy-Item $_.FullName -Destination $dest -Force
        }
    }
    Write-Host "  OK .agents/workflows/ installed (foundry-start, curate, qa, etc.)"

    Write-Host ""
    Write-Host "Foundry installed. Run /foundry-start to begin."
    Write-Host ""
    Write-Host "Structure created:"
    Write-Host "  .foundry/SKILL.md          -- master orchestrator"
    Write-Host "  .foundry/prompts/          -- review & consultation prompts"
    Write-Host "  .foundry/templates/        -- workflow template, interview guide"
    Write-Host "  .foundry/scripts/          -- section extraction"
    Write-Host "  .agents/workflows/         -- slash command workflows"
}
finally {
    Remove-Item -Recurse -Force $TMP -ErrorAction SilentlyContinue
}
