#!/usr/bin/env bash
set -euo pipefail

# Dev-only. Symlinks every skill in this repo into ~/.agents/skills, so edits
# here are live immediately. Re-run after adding, renaming, or removing a skill.
#
# This is not an installer. Anywhere else, use:
#   npx skills@latest add adrian-patterson/skills
#
# Do not use both on one machine: npx skills copies files into the same
# directory this script symlinks into, and the two will fight.

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$HOME/.agents/skills"

if [ -L "$DEST" ] && [[ "$(readlink -f "$DEST")" == "$REPO"* ]]; then
  echo "error: $DEST is a symlink into this repo. Remove it and re-run." >&2
  exit 1
fi

mkdir -p "$DEST"

linked=0
while IFS= read -r -d '' skill_md; do
  src="$(dirname "$skill_md")"
  name="$(basename "$src")"
  target="$DEST/$name"

  # Refuse to clobber anything that is not already our own symlink. Another
  # skill set installed into this directory would otherwise vanish silently.
  if [ -e "$target" ] || [ -L "$target" ]; then
    current="$(readlink "$target" 2>/dev/null || true)"
    if [ "$current" != "$src" ]; then
      echo "error: $target already exists and is not a link to $src." >&2
      echo "       Rename this repo's '$name' skill, or remove the existing entry." >&2
      exit 1
    fi
  fi

  ln -sfn "$src" "$target"
  echo "linked $name -> $src"
  linked=$((linked + 1))
done < <(find "$REPO/skills" -name SKILL.md -not -path '*/deprecated/*' -print0)

echo "$linked skill(s) linked into $DEST"
