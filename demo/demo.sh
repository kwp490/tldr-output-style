#!/usr/bin/env bash
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
# restore runs from an EXIT trap, so it happens even on Ctrl-C or an error.
#
# Usage:  bash demo/demo.sh

set -euo pipefail

demo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(dirname "$demo_dir")"
plugin_dir="$repo_root/plugins/tldr"
prompt_path="$demo_dir/prompt.md"

[ -f "$prompt_path" ] || { echo "missing $prompt_path" >&2; exit 1; }
[ -d "$plugin_dir" ]  || { echo "missing $plugin_dir" >&2; exit 1; }

prompt="$(cat "$prompt_path")"

rule() {
  echo
  printf '=%.0s' {1..78}; echo
  echo "  $1"
  printf '=%.0s' {1..78}; echo
  echo
}

# Was the plugin enabled before we started? Restore exactly this state at the end.
was_enabled=0
if listing="$(claude plugin list 2>/dev/null)"; then
  if printf '%s' "$listing" | grep -q 'tldr@tldr-plugins'; then
    # The status line follows the plugin name in the listing.
    if printf '%s' "$listing" | sed -n '/tldr@tldr-plugins/,$p' | grep -qi 'enabled'; then
      was_enabled=1
    fi
  fi
fi

restore() {
  if [ "$was_enabled" -eq 1 ]; then
    echo "Restoring tldr@tldr-plugins to enabled..."
    claude plugin enable tldr@tldr-plugins >/dev/null 2>&1 || true
  fi
}
trap restore EXIT

if [ "$was_enabled" -eq 1 ]; then
  echo "Temporarily disabling tldr@tldr-plugins so the OFF arm is really off..."
  claude plugin disable tldr@tldr-plugins >/dev/null 2>&1 || true
fi

rule 'WITHOUT TLDR  (default Claude)'
claude -p "$prompt"

rule 'WITH TLDR  (loaded from this repo, nothing installed)'
claude --plugin-dir "$plugin_dir" -p "$prompt"

rule 'Done'
echo 'Look for: does the first line tell you what to DO, or does it warm up first?'
echo 'Are the action items numbered? Are the three deadlines called out?'
echo 'Did the dashboard tangent get parked instead of expanded?'
echo
