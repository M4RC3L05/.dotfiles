{
  config,
  pkgs,
  internal,
}:
[
  internal.pkgs.denotag
  internal.pkgs.theOfficeQuote

  pkgs.act
  pkgs.bitwarden-cli
  pkgs.cascadia-code
  pkgs.curl
  pkgs.dive
  pkgs.docker
  pkgs.docker-credential-helpers
  pkgs.ffmpeg-full
  pkgs.hyperfine
  pkgs.kubectl
  pkgs.lsof
  pkgs.nil
  pkgs.nixfmt-rfc-style
  pkgs.q
  pkgs.rsync
  pkgs.tldr
  pkgs.tokei
  pkgs.wget
  pkgs.wrk
  pkgs.zip

  (config.lib.nixGL.wrappers.mesa pkgs.bitwarden-desktop
    # Enabling wayland will break resizing
    # (utils.wrap pkgs.bitwarden-desktop {
    #   env = {
    #     NIXOS_OZONE_WL = "1";
    #   };
    # })
  )

  (config.lib.nixGL.wrappers.nvidia pkgs.nvtopPackages.full)

  (config.lib.nixGL.wrappers.mesa pkgs.youtube-music
    # Enabling wayland will break resizing
    # (utils.wrap pkgs.youtube-music {
    #   env = {
    #     NIXOS_OZONE_WL = "1";
    #   };
    # })
  )
]
