#!/bin/bash
# Claude Code PostToolUse hook (Edit|Write): scan the edited file with gitleaks
# so secrets are caught at edit time, before the pre-commit hook.
# Exit 2 feeds the (redacted) findings back to Claude; no-op if gitleaks is absent.

command -v gitleaks >/dev/null 2>&1 || exit 0

file=$(/usr/bin/python3 -c 'import json,sys; print(json.load(sys.stdin).get("tool_input",{}).get("file_path",""))' 2>/dev/null)
[ -n "$file" ] && [ -f "$file" ] || exit 0

# gitleaks >= 8.19 uses "gitleaks dir"; older versions use "detect --no-git"
if gitleaks help dir >/dev/null 2>&1; then
  out=$(gitleaks dir "$file" --no-banner --redact 2>&1)
  status=$?
else
  out=$(gitleaks detect --no-git --no-banner --redact --source "$file" 2>&1)
  status=$?
fi

if [ "$status" -ne 0 ]; then
  {
    echo "gitleaks: potential secret detected in $file — remove it and use the 1Password .env.tpl workflow instead."
    echo "$out"
  } >&2
  exit 2
fi

exit 0
