#!/usr/bin/env bash
# Install Oligarchy bar extras: gold logo + gold focused workspace.
# Safe to re-run. Does not overwrite unrelated bar widgets.

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
THEME_DIR=$(cd -- "$SCRIPT_DIR/.." && pwd)
SRC_PLUGINS="$SCRIPT_DIR/plugins"
DEST_PLUGINS="${XDG_CONFIG_HOME:-$HOME/.config}/omarchy/plugins"
SHELL_JSON="${XDG_CONFIG_HOME:-$HOME/.config}/omarchy/shell.json"

fail() {
  echo "oligarchy extras: $*" >&2
  exit 1
}

[[ -d $SRC_PLUGINS/oligarchy.menu ]] || fail "missing $SRC_PLUGINS/oligarchy.menu"
[[ -d $SRC_PLUGINS/oligarchy.workspaces ]] || fail "missing $SRC_PLUGINS/oligarchy.workspaces"

mkdir -p "$DEST_PLUGINS"

echo "Installing plugins to $DEST_PLUGINS ..."
rm -rf "$DEST_PLUGINS/oligarchy.menu" "$DEST_PLUGINS/oligarchy.workspaces"
cp -a "$SRC_PLUGINS/oligarchy.menu" "$DEST_PLUGINS/oligarchy.menu"
cp -a "$SRC_PLUGINS/oligarchy.workspaces" "$DEST_PLUGINS/oligarchy.workspaces"

# Drop username-prefixed clones if present from earlier local testing.
rm -rf "$DEST_PLUGINS/fo.menu" "$DEST_PLUGINS/fo.workspaces"

if [[ -f $SHELL_JSON ]]; then
  echo "Updating $SHELL_JSON bar layout ..."
  tmp=$(mktemp)
  jq '
    .bar.layout.left |= map(
      if (.id == "omarchy.menu" or .id == "fo.menu") then .id = "oligarchy.menu"
      elif (.id == "omarchy.workspaces" or .id == "fo.workspaces") then .id = "oligarchy.workspaces"
      else . end
    )
    | .disabledPlugins = (
        ((.disabledPlugins // [])
          + ["omarchy.menu", "omarchy.workspaces", "fo.menu", "fo.workspaces"]
          | unique)
        - ["oligarchy.menu", "oligarchy.workspaces"]
      )
    | .cloneSourceRestores = (
        (.cloneSourceRestores // [])
        | map(select(. != "fo.menu" and . != "fo.workspaces"
              and . != "oligarchy.menu" and . != "oligarchy.workspaces"))
      )
  ' "$SHELL_JSON" >"$tmp"
  mv "$tmp" "$SHELL_JSON"
else
  echo "No shell.json yet; creating minimal left-bar layout ..."
  mkdir -p "$(dirname "$SHELL_JSON")"
  cat >"$SHELL_JSON" <<'EOF'
{
  "version": 1,
  "bar": {
    "layout": {
      "left": [
        { "id": "oligarchy.menu" },
        { "id": "oligarchy.workspaces" }
      ],
      "center": [],
      "right": []
    }
  },
  "disabledPlugins": ["omarchy.menu", "omarchy.workspaces"],
  "plugins": [],
  "cloneSourceRestores": []
}
EOF
fi

if command -v omarchy-shell >/dev/null 2>&1; then
  omarchy-shell shell rescanPlugins >/dev/null 2>&1 || true
fi

echo
echo "Oligarchy bar extras installed."
echo "  plugins: oligarchy.menu, oligarchy.workspaces"
echo "  theme:   $THEME_DIR"
echo
echo "If the bar does not refresh: omarchy restart shell"
echo "Then apply the theme (if needed): omarchy theme set oligarchy"
