{ config, pkgs }:
{
  enable = true;
  package = config.lib.nixGL.wrappers.nvidia (config.lib.nixGL.wrappers.mesa pkgs.mpv);
  config = {
    keepaspect = "no";
    force-window = "yes";
    profile = "gpu-hq";
    gpu-api = "auto";
    gpu-context = "auto";
    vo = "gpu-next";
    hwdec = "auto";
    hwdec-codecs = "all";
    ytdl-format = "bestvideo+bestaudio";
  };
}
