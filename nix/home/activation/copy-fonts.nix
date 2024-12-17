{ lib }:
(lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  if [ -d "$HOME/.nix-profile/share/fonts" ]; then
    run mkdir -p $HOME/.local/share/fonts

    if [ -d "$HOME/.local/share/fonts/nix" ]; then
      run rm -r $HOME/.local/share/fonts/nix
    fi

    run mkdir -p $HOME/.local/share/fonts/nix
    run cp -rL $HOME/.nix-profile/share/fonts/* $HOME/.local/share/fonts/nix
    run chmod -R u+rw,g+rw $HOME/.local/share/fonts/nix
  fi
'')
