# Network Engine 🛜

Dynamic Kernel Level Network Optimization for Rooted Android

---

## Overview

Network Engine is a Magisk module that enhances the Linux TCP networking stack on Android devices using adaptive, capability based tuning.

All adjustments are performed within kernel limits.
No unsupported features are forced.

The objective is stable latency, consistent throughput and sustained real world performance across WiFi and mobile networks.

---

## Core Architecture

### Congestion Control Selection

Automatically selects the best available algorithm in this order:

• bbr
• cubic
• reno

Selection is based on actual kernel availability.

---

### Queue Discipline Optimization

Automatically selects:

• fq when supported
• pfifo_fast as fallback

Applied globally and to active interfaces.

---

## Dynamic Network Engine

### Adaptive Buffer Scaling

Network Engine dynamically adjusts:

• tcp_rmem
• tcp_wmem
• rmem_max
• wmem_max
• netdev_max_backlog

Based on:

• WiFi or mobile data
• Metered state
• Mobile signal strength

Weak signal environments use conservative buffers for stability.
Strong signal environments scale higher for throughput.

A built in safety cap prevents excessive allocation.

---

### Safe Initial Window Enhancement

When supported by the kernel, Network Engine safely applies:

initcwnd 16
initrwnd 16

This improves connection startup performance without extreme or unsafe values.

Applied only when supported.

---

### Stability Layer

Enhances TCP reliability through controlled activation of:

• tcp_sack
• tcp_window_scaling
• tcp_tw_reuse
• tcp_syn_retries refinement

Values are adjusted only when necessary to avoid unnecessary overrides.

---

## Runtime Engine

Lightweight background monitor that:

• Maintains congestion control
• Maintains queue discipline
• Reapplies parameters if modified
• Adapts to network state changes
• Avoids excessive logging or polling

Designed for minimal overhead and stable long term operation.

---

## Network Awareness

Detects automatically:

• WiFi
• Mobile data
• Metered networks
• Signal quality (mobile)

Optimized for modern 4G and 5G networks without hardcoded radio tuning.

---

## Safe Handling

On first run the module stores:

• Original congestion control
• Original default qdisc

On uninstall, original values are restored automatically.

No permanent kernel modification.

---

## Compatibility

• Android 10 and above
• Latest stable Magisk recommended
• Kernels exposing TCP controls via /proc/sys

Supports Snapdragon, MediaTek, Exynos and other Linux based Android kernels.

Automatic fallback is used when features are unavailable.

---

## Installation

Flash through Magisk.
Reboot.

Network Engine activates automatically.

---

## Uninstall

Remove the module from Magisk.
Reboot.

Original networking values are restored.

---

## Design Philosophy

Network performance should be stable, predictable and adaptive.

Network Engine follows these principles:

Capability based tuning  
All adjustments depend on real kernel support.

Balanced scaling  
Buffers scale according to network conditions, not fixed extreme presets.

Controlled enhancement  
Performance is improved without pushing unsafe limits.

Self healing behavior  
Critical parameters remain consistent without aggressive overhead.

The goal is long term stability under real usage conditions.

---

## Author

Razal (Razal1_1)
Independent Developer

Email: razalrazal759@gmail.com

---
## License

This project is licensed under the GNU General Public License v3 (GPLv3).

You are free to use, modify, and redistribute this project under the terms of the GPLv3.
See the `LICENSE` file for full details.
