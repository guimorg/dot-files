#!/usr/bin/env sh
PAGE_SIZE=$(vm_stat | head -1 | awk '{print $8}')
PAGES_ACTIVE=$(vm_stat | awk '/Pages active/ {gsub("\\.", "", $3); print $3}')
PAGES_INACTIVE=$(vm_stat | awk '/Pages inactive/ {gsub("\\.", "", $3); print $3}')
PAGES_SPECULATIVE=$(vm_stat | awk '/Pages speculative/ {gsub("\\.", "", $3); print $3}')
PAGES_WIRED=$(vm_stat | awk '/Pages wired/ {gsub("\\.", "", $4); print $4}')
USED=$(( (PAGES_ACTIVE + PAGES_INACTIVE + PAGES_SPECULATIVE + PAGES_WIRED) * PAGE_SIZE ))
TOTAL=$(sysctl -n hw.memsize)
PERCENT=$(( USED * 100 / TOTAL ))
sketchybar --set "$NAME" label="${PERCENT}%"
