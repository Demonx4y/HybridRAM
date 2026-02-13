# 🚀 HybridRAM

HybridRAM is a system-level Magisk module that configures a
hybrid virtual memory setup using:

• Compressed ZRAM (RAM-based swap)  
• UFS-backed swapfile (storage-based fallback)  

The module is designed to improve memory stability and consistency during
real-world usage such as multitasking, gaming, and long sessions.

The focus is sustained behavior, not short benchmark spikes.

---

## What HybridRAM Does

HybridRAM establishes a ZRAM-first memory flow:

• Enables compressed ZRAM as the primary reclaim layer  
• Uses storage-backed swap only as a fallback  
• Ensures ZRAM is preferred whenever possible  
• Applies safe VM tuning commonly reset by Android  
• Smooths writeback behavior under sustained load  
• Applies kernel-safe I/O read-ahead tuning  
• Reasserts critical parameters only when Android resets them  

---

## Hybrid Memory Architecture

HybridRAM does not rely on a single memory technique.

It combines two layers with different responsibilities:

### ZRAM (Compressed RAM)

• Very fast  
• Low latency  
• Handles frequent reclaim  
• Preferred during memory pressure  

### Swapfile (UFS-backed storage)

• Larger capacity  
• Higher latency  
• Used only when RAM and ZRAM are saturated  

HybridRAM maintains a ZRAM-first, swap-second order so storage I/O is reduced
and latency spikes are minimized.

This results in smoother multitasking and more predictable long-term behavior.

---

## Memory Layout

By default, HybridRAM configures:

• 4 GB ZRAM (primary reclaim layer)  
• 4 GB swapfile (secondary fallback layer)  

If a kernel does not support swap priority, the module falls back gracefully
using standard kernel behavior.

Nothing is forced beyond hardware or kernel limits.

---

## Design Philosophy

Android memory management is dynamic and aggressive.
Many one-time tweaks are silently reverted after boot.

HybridRAM is designed to:

• Apply safe baseline tuning  
• Reassert only parameters Android commonly resets  
• Avoid constant or aggressive forcing  
• Respect kernel and hardware limits  

The goal is consistent performance over time, not temporary boosts.

---

## Gaming and Multitasking

HybridRAM is tuned for gaming and heavy multitasking:

• Reduces sudden memory pressure spikes  
• Helps mitigate aggressive background app kills  
• Avoids large swap bursts that cause frame drops  
• Improves app switching under load  
• Maintains stable foreground performance  

The module works with Android’s memory system rather than against it.

---

## Transparency

HybridRAM does not increase physical RAM or change hardware capabilities.

It optimizes how existing RAM and storage are used and improves reclaim behavior
under memory pressure.

Results depend on device, kernel, storage speed, ROM configuration, and workload.

---

## Installation

1. Flash the module via Magisk  
2. Reboot  

HybridRAM activates automatically at boot.
No manual configuration is required.

---

## Uninstall

• Disable or remove the module in Magisk  
• Reboot  

The system returns to stock memory behavior automatically.

---

## Status

• Tested on multiple devices and ROMs  
• Used under gaming and heavy multitasking scenarios  
• Designed to be kernel-safe and ROM-tolerant  

Future updates may include:

• Minor tuning refinements  
• Optional profiles  
• Clearly labeled experimental features  

---

## Author

Razal (Razal1_1)  
Independent developer  

Email: razalrazal759@gmail.com

---

## License

This project is **open source** and distributed under a custom license.

You are free to:
• Use the software  
• Study how it works  
• Modify it for personal or educational purposes  

Conditions:
• Proper attribution to the original author is required  
• Redistribution must include this README and the LICENSE file  
• Commercial use, paid redistribution, or bundling in paid products
  is **not permitted** without explicit permission  

See the `LICENSE` file for full terms.
