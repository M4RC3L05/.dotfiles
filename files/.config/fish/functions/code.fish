function code --description 'Launches codium with wayland flags'
  codium --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto --disable-gpu $argv >/dev/null 2>&1 &; disown
end