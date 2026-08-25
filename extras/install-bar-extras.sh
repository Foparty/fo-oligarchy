#!/usr/bin/env bash
# Install Fo Oligarchy bar extras: gold logo + gold focused workspace.
# Safe to re-run. Does not overwrite unrelated bar widgets.

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
THEME_DIR=$(cd -- "$SCRIPT_DIR/.." && pwd)
SRC_PLUGINS="$SCRIPT_DIR/plugins"
DEST_PLUGINS="${XDG_CONFIG_HOME:-$HOME/.config}/omarchy/plugins"
SHELL_JSON="${XDG_CONFIG_HOME:-$HOME/.config}/omarchy/shell.json"

MENU_ID="fo-oligarchy.menu"
WORKSPACES_ID="fo-oligarchy.workspaces"

fail() {
  echo "fo-oligarchy extras: $*" >&2
  exit 1
}

[[ -d $SRC_PLUGINS/$MENU_ID ]] || fail "missing $SRC_PLUGINS/$MENU_ID"
[[ -d $SRC_PLUGINS/$WORKSPACES_ID ]] || fail "missing $SRC_PLUGINS/$WORKSPACES_ID"

mkdir -p "$DEST_PLUGINS"

echo "Installing plugins to $DEST_PLUGINS ..."
rm -rf "$DEST_PLUGINS/$MENU_ID" "$DEST_PLUGINS/$WORKSPACES_ID"
cp -a "$SRC_PLUGINS/$MENU_ID" "$DEST_PLUGINS/$MENU_ID"
cp -a "$SRC_PLUGINS/$WORKSPACES_ID" "$DEST_PLUGINS/$WORKSPACES_ID"

# Drop older local clone names if present.
rm -rf \
  "$DEST_PLUGINS/fo.menu" \
  "$DEST_PLUGINS/fo.workspaces" \
  "$DEST_PLUGINS/oligarchy.menu" \
  "$DEST_PLUGINS/oligarchy.workspaces"

if [[ -f $SHELL_JSON ]]; then
  echo "Updating $SHELL_JSON bar layout ..."
  tmp=$(mktemp)
  jq \
    --arg menu "$MENU_ID" \
    --arg workspaces "$WORKSPACES_ID" '
    .bar.layout.left |= map(
      if (.id == "omarchy.menu" or .id == "fo.menu" or .id == "oligarchy.menu") then .id = $menu
      elif (.id == "omarchy.workspaces" or .id == "fo.workspaces" or .id == "oligarchy.workspaces") then .id = $workspaces
      else . end
    )
    | .disabledPlugins = (
        ((.disabledPlugins // [])
          + ["omarchy.menu", "omarchy.workspaces", "fo.menu", "fo.workspaces", "oligarchy.menu", "oligarchy.workspaces"]
          | unique)
        - [$menu, $workspaces]
      )
    | .cloneSourceRestores = (
        (.cloneSourceRestores // [])
        | map(select(
            . != "fo.menu" and . != "fo.workspaces"
            and . != "oligarchy.menu" and . != "oligarchy.workspaces"
            and . != $menu and . != $workspaces
          ))
      )
  ' "$SHELL_JSON" >"$tmp"
  mv "$tmp" "$SHELL_JSON"
else
  echo "No shell.json yet; creating minimal left-bar layout ..."
  mkdir -p "$(dirname "$SHELL_JSON")"
  cat >"$SHELL_JSON" <<EOF
{
  "version": 1,
  "bar": {
    "layout": {
      "left": [
        { "id": "$MENU_ID" },
        { "id": "$WORKSPACES_ID" }
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
echo "Fo Oligarchy bar extras installed."
echo "  plugins: $MENU_ID, $WORKSPACES_ID"
echo "  theme:   $THEME_DIR"
echo
echo "If the bar does not refresh: omarchy restart shell"
echo "Then apply the theme (if needed): omarchy theme set fo-oligarchy"
