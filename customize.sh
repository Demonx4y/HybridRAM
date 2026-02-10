#!/sbin/sh

SKIPUNZIP=0
REPLACE=""

ui_print " "
ui_print "================================================"
ui_print "        🚀HybridRAM – ZRAM + Swapfile"
ui_print "================================================"
ui_print " "

ui_print " Preparing HybridRAM module files..."
ui_print " Setting up runtime environment"
ui_print " "

ui_print " Module overview:"
ui_print " • ZRAM-based compressed swap (RAM-backed)"
ui_print " • Optional UFS-backed swapfile as overflow"
ui_print " • Priority-based swap ordering (ZRAM first)"
ui_print " • VM parameter tuning applied at boot"
ui_print " "

ui_print " Runtime behavior (applied after boot):"
ui_print " • ZRAM handles memory pressure first"
ui_print " • Swapfile is used only as fallback"
ui_print " • No swap protocol spoofing or hardware unlocks"
ui_print " • No permanent kernel or system modifications"
ui_print " "

ui_print " Performance & stability goals:"
ui_print " • Improved multitasking consistency"
ui_print " • Reduced memory reclaim stalls"
ui_print " • Safe behavior under sustained load"
ui_print " "

ui_print " Compatibility & safety:"
ui_print " • Designed for stock and custom kernels"
ui_print " • Uses kernel-supported interfaces only"
ui_print " • Graceful fallback if features are unsupported"
ui_print " • Fully reversible on module removal"
ui_print " "

ui_print " Diagnostics:"
ui_print " • Swap status: /proc/swaps"
ui_print " • VM parameters: /proc/sys/vm/*"
ui_print " • Service log: /data/HybridRAM/hybrid.log"
ui_print " "

ui_print " Registering boot-time service..."
ui_print " HybridRAM will activate after reboot"
ui_print " "

ui_print "================================================"
ui_print " HybridRAM module installed successfully"
ui_print " Reboot required to activate"
ui_print "================================================"
ui_print " "

# --------------------------------------------------
# All runtime logic is handled by service.sh
# No kernel patching or system partition changes
# Settings are applied dynamically after boot🔁
# --------------------------------------------------
