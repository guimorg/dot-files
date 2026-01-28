#!/usr/bin/env sh
IFACE=$(route -n get default 2>/dev/null | awk '/interface:/{print $2}')
if [ -z "$IFACE" ]; then
  sketchybar --set "$NAME" label="--"
  exit 0
fi
RX1=$(netstat -ib -I "$IFACE" | awk 'NR==2 {print $7}')
TX1=$(netstat -ib -I "$IFACE" | awk 'NR==2 {print $10}')
sleep 1
RX2=$(netstat -ib -I "$IFACE" | awk 'NR==2 {print $7}')
TX2=$(netstat -ib -I "$IFACE" | awk 'NR==2 {print $10}')
RX=$((RX2 - RX1))
TX=$((TX2 - TX1))
format() {
  awk -v b="$1" 'BEGIN {
    split("B/s KB/s MB/s GB/s", u)
    i=1
    while (b >= 1024 && i < 4) { b /= 1024; i++ }
    printf "%.1f%s", b, u[i]
  }'
}
RX_H=$(format "$RX")
TX_H=$(format "$TX")
sketchybar --set "$NAME" label="${RX_H} ${TX_H}"
