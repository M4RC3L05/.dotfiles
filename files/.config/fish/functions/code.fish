function code --description 'Launches codium with wayland flags'
  code-oss --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto $argv >/dev/null 2>&1 &
  disown
end
