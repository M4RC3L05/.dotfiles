#!/usr/bin/env sh

set -e

log_info "Setup graphics packages"
(set -x; sudo pacman -S --needed --noconfirm intel-media-driver vulkan-intel libvpl vpl-gpu-rt)
(set -x; sudo pacman -S --needed --noconfirm nvidia-open nvidia-utils)
(set -x; sudo pacman -S --needed --noconfirm libva-utils vdpauinfo vulkan-tools intel-gpu-tools nvtop)
(set -x; sudo pacman -S --needed --noconfirm gst-libav gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly gst-plugin-va)
