let
  nixgl = import <nixgl> {};
  nixpkgs = import <nixpkgs-unstable> {};

  # https://github.com/nix-community/nixGL/issues/44#issuecomment-1361524862
  nixGLWrap = (nixGLCommand: pkg: nixpkgs.runCommand "${pkg.name}-${nixGLCommand.name}-wrapper" {} ''
    mkdir $out
    ln -s ${pkg}/* $out
    rm $out/bin
    mkdir $out/bin
    for bin in ${pkg}/bin/*; do
      wrapped_bin="$out/bin/$(basename $bin)"
      printf "#!${nixpkgs.stdenv.shell}\n\nexec ${nixpkgs.lib.getExe nixGLCommand} %s \$@" "$bin" > $wrapped_bin
      chmod +x $wrapped_bin
    done
  '');

  waylandElectronWrapper = { pkg, disableGpu ? "false" }:
    nixpkgs.runCommand "${pkg.name}-wayland-electron-wrapper" {} ''
      mkdir $out
      ln -s ${pkg}/* $out
      rm $out/bin
      mkdir $out/bin
      for bin in ${pkg}/bin/*; do
        wrapped_bin="$out/bin/$(basename $bin)"
        gpuFlag=""
        if [ "${disableGpu}" = "true" ]; then
          gpuFlag="--disable-gpu"
        fi
        printf "#!${nixpkgs.stdenv.shell}\n\nexec %s --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform-hint=wayland %s \$@" "$bin" "$gpuFlag" > $wrapped_bin
        chmod +x $wrapped_bin
      done
    '';
in {
  allowUnfree = true;

  packageOverrides = nixpkgs: with nixpkgs; {
      mainPackages = nixpkgs.buildEnv {
        name = "main-packages";
        paths = [
          nixpkgs.nix
          nixpkgs.cacert

          nixgl.auto.nixGLNvidia
          nixgl.nixGLIntel
          nixgl.auto.nixVulkanNvidia
          nixgl.nixVulkanIntel

          (waylandElectronWrapper { pkg = (nixGLWrap nixgl.nixGLIntel nixpkgs.vscode); })
          nixpkgs.ffmpeg_7-full
          nixpkgs.bat
          nixpkgs.btop
          nixpkgs.curl
          nixpkgs.podman
          nixpkgs.fish
          nixpkgs.doggo
          nixpkgs.eza
          nixpkgs.fastfetch
          nixpkgs.git
          nixpkgs.git-lfs
          nixpkgs.jq
          nixpkgs.k9s
          nixpkgs.kubectl
          nixpkgs.lsof
          nixpkgs.vim
          (nixGLWrap nixgl.auto.nixGLNvidia nixpkgs.nvtopPackages.full)
          nixpkgs.rsync
          nixpkgs.stow
          nixpkgs.tldr
          nixpkgs.tokei
          nixpkgs.tree
          nixpkgs.yt-dlp
          (nixGLWrap nixgl.nixGLIntel nixpkgs.mpv)
          nixpkgs.cascadia-code
          nixpkgs.syncthing
          (nixGLWrap nixgl.nixVulkanIntel nixpkgs.zed-editor)
          nixpkgs.oha
          nixpkgs.any-nix-shell
          nixpkgs.docker-credential-helpers
          (waylandElectronWrapper { pkg = nixpkgs.youtube-music; disableGpu = "true"; })

          (writeScriptBin "nix-rebuild" ''
            #!${stdenv.shell}

            exec nix-env -iAr nixpkgs.mainPackages "$@"
          '')
        ];
      };
    };
}
