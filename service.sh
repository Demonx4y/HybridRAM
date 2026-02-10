#!/system/bin/sh

LOGDIR="/data/HybridRAM"
LOG="$LOGDIR/hybrid.log"
SWAPFILE="$LOGDIR/swapfile"
ZRAM_DEV="/dev/block/zram0"
ZRAM_SYS="/sys/block/zram0"

mkdir -p "$LOGDIR"
chmod 755 "$LOGDIR"
exec >> "$LOG" 2>&1

echo "==============================="
echo "HybridRAM Service Started"
date
echo "==============================="

# wait for Android to fully boot
while [ "$(getprop sys.boot_completed)" != "1" ]; do
  sleep 5
done
sleep 20
echo "[BOOT] Android boot completed"

set_page_cluster() {
  for VAL in 0 1 2; do
    echo "$VAL" > /proc/sys/vm/page-cluster 2>/dev/null
    CUR=$(cat /proc/sys/vm/page-cluster 2>/dev/null)
    echo "[DEBUG] Tried page-cluster=$VAL → current=$CUR"
    [ "$CUR" = "$VAL" ] && return
  done
}

echo "[ZRAM] Initializing"

swapoff "$ZRAM_DEV" 2>/dev/null
[ -w "$ZRAM_SYS/reset" ] && echo 1 > "$ZRAM_SYS/reset"

if grep -q lz4 "$ZRAM_SYS/comp_algorithm"; then
  echo lz4 > "$ZRAM_SYS/comp_algorithm"
  echo "[ZRAM] Compression set to lz4"
fi

[ -f "$ZRAM_SYS/max_comp_streams" ] && echo 4 > "$ZRAM_SYS/max_comp_streams"

echo $((4 * 1024 * 1024 * 1024)) > "$ZRAM_SYS/disksize"
mkswap "$ZRAM_DEV" >/dev/null 2>&1
swapon "$ZRAM_DEV"
echo "[ZRAM] Enabled"

echo "[SWAP] Initializing swapfile"

if [ ! -f "$SWAPFILE" ]; then
  dd if=/dev/zero of="$SWAPFILE" bs=1M count=4096 status=none
  chmod 600 "$SWAPFILE"
  mkswap "$SWAPFILE" >/dev/null 2>&1
fi

swapon "$SWAPFILE"

# enforce ZRAM > swap order
swapoff "$SWAPFILE" 2>/dev/null
swapoff "$ZRAM_DEV" 2>/dev/null
swapon "$ZRAM_DEV"
swapon "$SWAPFILE"
echo "[PRIORITY] ZRAM > Swapfile enforced"

# VM tuning
echo 80  > /proc/sys/vm/swappiness
echo 100 > /proc/sys/vm/vfs_cache_pressure
echo 1500 > /proc/sys/vm/dirty_writeback_centisecs
echo 500  > /proc/sys/vm/dirty_expire_centisecs
echo 1 > /proc/sys/vm/compact_memory

# I/O scheduler (noop only if accepted, else deadline)
for Q in /sys/block/*/queue; do
  [ -d "$Q" ] || continue
  S="$Q/scheduler"
  DEV="$(basename "$(dirname "$Q")")"

  [ -f "$S" ] || continue

  if grep -qw noop "$S"; then
    echo noop > "$S" 2>/dev/null
    if grep -qw noop "$S"; then
      echo "[IO] $DEV → noop"
      continue
    fi
  fi

  if grep -qw deadline "$S"; then
    echo deadline > "$S" 2>/dev/null
    echo "[IO] $DEV → deadline"
  fi

  [ -f "$Q/read_ahead_kb" ] && echo 128 > "$Q/read_ahead_kb"
done

# Android resistance loop (silent & safe)
(
  while true; do
    [ "$(cat /proc/sys/vm/swappiness 2>/dev/null)" != "80" ] && \
      echo 80 > /proc/sys/vm/swappiness

    [ "$(cat /proc/sys/vm/vfs_cache_pressure 2>/dev/null)" != "100" ] && \
      echo 100 > /proc/sys/vm/vfs_cache_pressure

    set_page_cluster >/dev/null 2>&1

    if grep -q "$ZRAM_DEV" /proc/swaps && grep -q "$SWAPFILE" /proc/swaps; then
      ZP=$(awk '/zram0/ {print $NF}' /proc/swaps)
      SP=$(awk '/swapfile/ {print $NF}' /proc/swaps)

      if [ "$ZP" -le "$SP" ]; then
        swapoff "$SWAPFILE"
        swapoff "$ZRAM_DEV"
        swapon "$ZRAM_DEV"
        swapon "$SWAPFILE"
        echo "[FIX] Swap priority corrected"
      fi
    fi

    sleep 10
  done
) >/dev/null 2>&1 &

echo "----------- STATUS ------------"
cat /proc/swaps
echo "Swappiness: $(cat /proc/sys/vm/swappiness)"
echo "VFS cache pressure: $(cat /proc/sys/vm/vfs_cache_pressure)"
echo "Page-cluster: $(cat /proc/sys/vm/page-cluster)"
echo "[HybridRAM] ENFORCED"
echo "--------------------------------
