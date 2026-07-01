#!/usr/bin/env bash
# Usage: slack-delete-message <permalink> <token>
# e.g.   slack-delete-message https://wandercom.slack.com/archives/C08FJ0P4GMT/p1779714291594269 xoxb-...
set -euo pipefail

PERMALINK="${1:?permalink required}"
TOKEN="${2:?token required}"

# Parse channel and timestamp from permalink
# p1779714291594269 -> 1779714291.594269
if [[ "$PERMALINK" =~ /archives/([A-Z0-9]+)/p([0-9]{10})([0-9]{6}) ]]; then
  CHANNEL="${BASH_REMATCH[1]}"
  TS="${BASH_REMATCH[2]}.${BASH_REMATCH[3]}"
else
  echo "Cannot parse permalink: $PERMALINK" >&2
  exit 1
fi

RESPONSE=$(curl -s -X POST https://slack.com/api/chat.delete \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"channel\":\"$CHANNEL\",\"ts\":\"$TS\"}")

if echo "$RESPONSE" | grep -q '"ok":true'; then
  echo "Deleted $TS in $CHANNEL"
else
  ERROR=$(echo "$RESPONSE" | grep -o '"error":"[^"]*"' || echo "$RESPONSE")
  echo "Slack API error: $ERROR" >&2
  exit 1
fi
