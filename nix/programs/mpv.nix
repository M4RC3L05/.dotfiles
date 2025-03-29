{ config, pkgs }:
{
  enable = true;
  package = config.lib.nixGL.wrappers.nvidia (config.lib.nixGL.wrappers.mesa pkgs.mpv);
  config = {
    force-window = true;
    profile = "gpu-hq";
    gpu-api = "auto";
    vo = "gpu-next";
    hwdec = "auto";
    hwdec-codecs = "all";
    ytdl-format = "bestvideo+bestaudio";
  };
}
