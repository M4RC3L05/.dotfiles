{
  config,
  nixpkgsUnstable,
  utils,
}:
[
  nixpkgsUnstable.act
  nixpkgsUnstable.btop
  nixpkgsUnstable.cascadia-code
  nixpkgsUnstable.curl
  nixpkgsUnstable.dive
  nixpkgsUnstable.docker-credential-helpers
  nixpkgsUnstable.eget
  nixpkgsUnstable.eza
  nixpkgsUnstable.fastfetch
  nixpkgsUnstable.ffmpeg_7-full
  nixpkgsUnstable.jq
  nixpkgsUnstable.k9s
  nixpkgsUnstable.kubectl
  nixpkgsUnstable.lsof
  nixpkgsUnstable.nil
  nixpkgsUnstable.nixfmt-rfc-style
  nixpkgsUnstable.podman
  nixpkgsUnstable.q
  nixpkgsUnstable.rsync
  nixpkgsUnstable.tldr
  nixpkgsUnstable.tokei
  nixpkgsUnstable.tree
  nixpkgsUnstable.micro-full
  nixpkgsUnstable.wget
  nixpkgsUnstable.yt-dlp
  nixpkgsUnstable.procps
  nixpkgsUnstable.hyperfine
  nixpkgsUnstable.wrk
  nixpkgsUnstable.zip
  (config.lib.nixGL.wrappers.nvidia nixpkgsUnstable.nvtopPackages.full)

  (config.lib.nixGL.wrappers.mesa (
    utils.wrap nixpkgsUnstable.youtube-music {
      env = {
        NIXOS_OZONE_WL = "1";
      };
      flags = [ "--disable-gpu" ];
    }
  ))
]
