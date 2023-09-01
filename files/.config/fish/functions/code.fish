function code --description 'Launches codium with wayland flags'
  __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only code-oss --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto $argv >/dev/null 2>&1 &
  disown
end
