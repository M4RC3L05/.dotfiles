{ config, pkgs }:
{
  enable = true;
  package = config.lib.nixGL.wrappers.mesa pkgs.mpv;
  config = {
    force-window = true;
    profile = "gpu-hq";
    gpu-api = "auto";
    vo = "gpu-next";
    hwdec = "auto";
    ytdl-format = "bestvideo+bestaudio";
  };
}
