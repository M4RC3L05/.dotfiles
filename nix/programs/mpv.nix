{ config, nixpkgsUnstable }:
{
  enable = true;
  package = (config.lib.nixGL.wrappers.mesa nixpkgsUnstable.mpv);
  config = {
    force-window = true;
    profile = "gpu-hq";
    gpu-api = "auto";
    vo = "gpu-next";
    hwdec = "auto";
    ytdl-format = "bestvideo+bestaudio";
  };
}
