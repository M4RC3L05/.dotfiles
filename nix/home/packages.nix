{
  config,
  pkgs,
  utils,
}:
[
  pkgs.act
  pkgs.cascadia-code
  pkgs.curl
  pkgs.dive
  pkgs.docker-credential-helpers
  pkgs.eget
  pkgs.ffmpeg_7-full
  pkgs.kubectl
  pkgs.lsof
  pkgs.nil
  pkgs.nixfmt-rfc-style
  pkgs.q
  pkgs.rsync
  pkgs.tldr
  pkgs.tokei
  pkgs.wget
  pkgs.procps
  pkgs.hyperfine
  pkgs.wrk
  pkgs.zip

  (config.lib.nixGL.wrappers.nvidia pkgs.nvtopPackages.full)

  (config.lib.nixGL.wrappers.mesa (
    utils.wrap pkgs.youtube-music {
      env = {
        NIXOS_OZONE_WL = "1";
      };
      flags = [ "--disable-gpu" ];
    }
  ))

  (config.lib.nixGL.wrappers.mesa (
    utils.wrap pkgs.bitwarden-desktop {
      env = {
        NIXOS_OZONE_WL = "1";
      };
    }
  ))
]
