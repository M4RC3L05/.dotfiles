let
  nixgl = import <nixgl> { };
  nixpkgs = import <nixpkgs-unstable> { };

  # https://nixos.wiki/wiki/Nix_Cookbook#Wrapping_packages
  wrap =
    { this, using }:
    let
      thisEnv = this.env or [ ];
      thisEnvNormalized = if thisEnv == [ ] then thisEnv else (thisEnv ++ [ "" ]);

      thisFlags = this.flags or [ ];
      thisFlagsNormalized = if thisFlags == [ ] then thisFlags else ([ "" ] ++ thisFlags);
    in
    nixpkgs.runCommand "${this.pkg.name}-${using.pkg.name}-wrapper" { } ''
      mkdir $out

      ln -s ${this.pkg}/* $out

      rm $out/bin

      mkdir $out/bin

      ln -s ${this.pkg}/bin/* $out/bin

      ${nixpkgs.lib.concatStringsSep " " (
        nixpkgs.lib.map (bin: ''
          echo "=> Wrapping ${bin} using ${using.pkg.name}"

          wrapped_source_path="${this.pkg}/bin/${bin}"
          wrapped_destination_path="$out/bin/${bin}"
          rm "$wrapped_destination_path"

          ${
            if this.pkg.drvPath == using.pkg.drvPath then
              ''
                printf "#!${nixpkgs.stdenv.shell}\n\n%sexec ${nixpkgs.lib.getExe using.pkg}%s \"\$@\"" "${nixpkgs.lib.concatStringsSep " " thisEnvNormalized}" "${nixpkgs.lib.concatStringsSep " " thisFlagsNormalized}" > $wrapped_destination_path
                chmod +x $wrapped_destination_path
              ''
            else
              ''
                printf "#!${nixpkgs.stdenv.shell}\n\n%sexec ${nixpkgs.lib.getExe using.pkg}%s%s \"\$@\"" "${nixpkgs.lib.concatStringsSep " " thisEnvNormalized}" " $wrapped_source_path" "${nixpkgs.lib.concatStringsSep " " thisFlagsNormalized}" > $wrapped_destination_path
                chmod +x $wrapped_destination_path
              ''
          }
        '') this.bins or [ this.pkg.meta.mainProgram ]
      )}
    '';
in
{
  allowUnfree = true;

  packageOverrides =
    nixpkgs: with nixpkgs; {
      mainPackages = nixpkgs.buildEnv {
        name = "main-packages";
        paths = [
          nixpkgs.nix
          nixpkgs.cacert

          nixgl.auto.nixGLNvidia
          nixgl.nixGLIntel
          nixgl.auto.nixVulkanNvidia
          nixgl.nixVulkanIntel

          (wrap {
            this = {
              pkg = nixpkgs.vscode;
              flags = [
                "--enable-features=UseOzonePlatform,WaylandWindowDecorations"
                "--ozone-platform-hint=wayland"
              ];
            };
            using = {
              pkg = nixgl.nixGLIntel;
            };
          })
          nixpkgs.ffmpeg_7-full
          nixpkgs.bat
          nixpkgs.btop
          nixpkgs.curl
          nixpkgs.podman
          nixpkgs.q
          nixpkgs.eza
          nixpkgs.fastfetch
          nixpkgs.git
          nixpkgs.git-lfs
          nixpkgs.jq
          nixpkgs.k9s
          nixpkgs.kubectl
          nixpkgs.lsof
          nixpkgs.vim
          (wrap {
            this = {
              pkg = nixpkgs.nvtopPackages.full;
            };
            using = {
              pkg = nixgl.auto.nixGLNvidia;
            };
          })
          nixpkgs.rsync
          nixpkgs.stow
          nixpkgs.tldr
          nixpkgs.tokei
          nixpkgs.tree
          nixpkgs.yt-dlp
          (wrap {
            this = {
              pkg = nixpkgs.mpv;
              bins = [
                "mpv"
                "umpv"
              ];
            };
            using = {
              pkg = nixgl.nixGLIntel;
            };
          })
          nixpkgs.cascadia-code
          nixpkgs.syncthing
          (wrap {
            this = {
              pkg = nixpkgs.zed-editor;
            };
            using = {
              pkg = nixgl.nixVulkanIntel;
            };
          })
          nixpkgs.oha
          nixpkgs.docker-credential-helpers
          (wrap {
            this = {
              pkg = nixpkgs.youtube-music;
              flags = [
                "--enable-features=UseOzonePlatform,WaylandWindowDecorations"
                "--ozone-platform-hint=wayland"
                "--disable-gpu"
              ];
            };
            using = {
              pkg = nixpkgs.youtube-music;
            };
          })
          nixpkgs.wget
          (wrap {
            this = {
              pkg = nixpkgs.act;
              env = [
                ''DOCKER_HOST=\"unix://\$XDG_RUNTIME_DIR/podman/podman.sock\"''
              ];
            };
            using = {
              pkg = nixpkgs.act;
            };
          })
          nixpkgs.eget
          nixpkgs.dive
          nixpkgs.bash-completion
          nixpkgs.nix-bash-completions
          nixpkgs.nil
          nixpkgs.nixfmt-rfc-style

          (writeScriptBin "nix-rebuild" ''
            #!${nixpkgs.stdenv.shell}

            exec nix-env -iAr nixpkgs.mainPackages "$@"
          '')
        ];
      };
    };
}
