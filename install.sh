#!/bin/bash
set -e

# Foundry Install Script
# Installs the Foundry project-bootstrap framework into your current directory.
# Does NOT touch your README, .gitignore, git history, or any existing files.
#
# Usage:
#   bash <(curl -sL https://raw.githubusercontent.com/laloquidity/foundry/main/install.sh)
#
# Options:
#   --update    Overwrite existing .foundry/ files with latest version
#   --help      Show this help message

REPO="laloquidity/foundry"
BRANCH="main"
FORCE=false

for arg in "$@"; do
  case $arg in
    --update|--force) FORCE=true ;;
    --help)
      echo "Foundry Install Script"
      echo ""
      echo "Installs the Foundry project-bootstrap framework into your current directory."
      echo "Creates .foundry/ and .agents/workflows/ — nothing else."
      echo ""
      echo "Usage:"
      echo "  bash install.sh           Install (won't overwrite existing)"
      echo "  bash install.sh --update  Update to latest version"
      echo ""
      exit 0
      ;;
  esac
done

# Check for existing installation
if [ -d ".foundry/prompts" ] && [ "$FORCE" = false ]; then
  echo "⚠️  Foundry is already installed in this directory."
  echo "   Run with --update to pull the latest version."
  exit 1
fi

echo "Installing Foundry..."

# Download to temp directory
TMP=$(mktemp -d)
trap "rm -rf $TMP" EXIT

curl -sL "https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz" | tar xz -C "$TMP"
SRC="$TMP/foundry-$BRANCH"

# Install framework files
mkdir -p .foundry
cp -r "$SRC/.foundry/"* .foundry/
echo "  ✓ .foundry/ installed (SKILL.md, prompts, templates, scripts)"

# Install workflows (additive — won't remove user's existing workflows)
mkdir -p .agents/workflows
for f in "$SRC/.agents/workflows/"*; do
  fname=$(basename "$f")
  if [ -f ".agents/workflows/$fname" ] && [ "$FORCE" = false ]; then
    echo "  · .agents/workflows/$fname exists, skipping (use --update to overwrite)"
  else
    cp "$f" ".agents/workflows/$fname"
  fi
done
echo "  ✓ .agents/workflows/ installed (foundry-start, curate, qa, etc.)"

echo ""
echo "Foundry installed. Run /foundry-start to begin."
echo ""
echo "Structure created:"
echo "  .foundry/SKILL.md          — master orchestrator"
echo "  .foundry/prompts/          — 16 review & consultation prompts"
echo "  .foundry/templates/        — workflow template, interview guide"
echo "  .foundry/scripts/          — section extraction"
echo "  .agents/workflows/         — slash command workflows"
