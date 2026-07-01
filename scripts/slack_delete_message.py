#!/usr/bin/env python3
"""Delete a Slack message or file given its permalink and a bot token."""

import re
import sys
import urllib.request
import json


def parse_slack_permalink(url: str) -> tuple[str, str]:
    """Return (channel_id, message_ts) from a Slack message permalink."""
    # e.g. https://wandercom.slack.com/archives/C08FJ0P4GMT/p1779714291594269
    m = re.search(r"/archives/([A-Z0-9]+)/p(\d+)", url)
    if not m:
        raise ValueError(f"Cannot parse Slack permalink: {url}")
    channel = m.group(1)
    raw = m.group(2)
    ts = raw[:-6] + "." + raw[-6:]
    return channel, ts


def parse_slack_file_url(url: str) -> str:
    """Return file_id from a Slack file URL."""
    # e.g. https://wandercom.slack.com/files/U07CP5XPY81/F0B7CAGSNKX/filename.csv
    m = re.search(r"/files/[A-Z0-9]+/([A-Z0-9]+)/", url)
    if not m:
        raise ValueError(f"Cannot parse Slack file URL: {url}")
    return m.group(1)


def _post(endpoint: str, payload: dict, token: str) -> dict:
    data = json.dumps(payload).encode()
    req = urllib.request.Request(
        f"https://slack.com/api/{endpoint}",
        data=data,
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
        },
        method="POST",
    )
    with urllib.request.urlopen(req) as resp:
        return json.load(resp)


def delete_slack_message(permalink: str, token: str) -> None:
    channel, ts = parse_slack_permalink(permalink)
    result = _post("chat.delete", {"channel": channel, "ts": ts}, token)
    if not result.get("ok"):
        raise RuntimeError(f"Slack API error: {result.get('error')}")
    print(f"Deleted message {ts} in {channel}")


def delete_slack_file(url: str, token: str) -> None:
    file_id = parse_slack_file_url(url)
    result = _post("files.delete", {"file": file_id}, token)
    if not result.get("ok"):
        raise RuntimeError(f"Slack API error: {result.get('error')}")
    print(f"Deleted file {file_id}")


def dispatch(url: str, token: str) -> None:
    if "/files/" in url:
        delete_slack_file(url, token)
    else:
        delete_slack_message(url, token)


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print(f"Usage: {sys.argv[0]} <url> [<url> ...] <token>")
        sys.exit(1)
    *urls, token = sys.argv[1:]
    errors = 0
    for url in urls:
        try:
            dispatch(url, token)
        except Exception as e:
            print(f"ERROR {url}: {e}", file=sys.stderr)
            errors += 1
    sys.exit(1 if errors else 0)
