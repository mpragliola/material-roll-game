#!/usr/bin/env bash
# One-off helper: creates the public repo, pushes, waits for the first deploy and switches GitHub Pages to the gh-pages branch.
set -euo pipefail
OWNER="${1:-mpragliola}"; REPO=material-roll
gh repo create "$OWNER/$REPO" --public --source . --remote origin --push \
  --description "Material Roll: a 3D physics cannon puzzle game (Three.js + Rapier) with a level editor"
echo "Waiting for the first deploy to create the gh-pages branch..."
for i in $(seq 1 40); do gh api "repos/$OWNER/$REPO/branches/gh-pages" >/dev/null 2>&1 && break; sleep 6; done
gh api -X POST "repos/$OWNER/$REPO/pages" -f "source[branch]=gh-pages" -f "source[path]=/" >/dev/null 2>&1 \
  || gh api -X PUT "repos/$OWNER/$REPO/pages" -f "source[branch]=gh-pages" -f "source[path]=/"
gh repo edit "$OWNER/$REPO" --homepage "https://$OWNER.github.io/$REPO/"
echo "Done: https://$OWNER.github.io/$REPO/"
