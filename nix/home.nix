{
  config,
  pkgs,
  lib,
  ...
}:
let
  nixgl = import <nixgl> { inherit pkgs; };
  utils = import ./utils/mod.nix { inherit pkgs lib; };
  defaults = import ./defaults.nix;
  internal = import ./_internal/mod.nix { inherit pkgs; };
in
{
  home = {
    inherit (defaults) sessionVariables;

    username = "main";
    homeDirectory = "/home/main";
    stateVersion = "24.11";

    activation = {
      copyFonts = import ./home/activation/copy-fonts.nix { inherit lib; };
    };

    packages = import ./home/packages.nix {
      inherit
        config
        pkgs
        utils
        internal
        ;
    };

    file = import ./home/file.nix;
  };

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [
          "Cascadia Code"
          "monospace"
        ];
      };
    };
  };

  nix = {
    gc = {
      automatic = true;
      frequency = "daily";
      options = "-d";
    };
  };

  nixGL = {
    packages = nixgl;
    vulkan = {
      enable = true;
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  programs = {
    bash = import ./programs/bash.nix {
      inherit
        defaults
        pkgs
        internal
        lib
        ;
    };

    bat = import ./programs/bat.nix { inherit pkgs; };

    btop = import ./programs/btop.nix;

    eza = import ./programs/eza.nix;

    fastfetch = import ./programs/fastfetch.nix;

    firefox = import ./programs/firefox.nix { inherit pkgs config; };

    fish = import ./programs/fish.nix {
      inherit
        defaults
        pkgs
        internal
        lib
        ;
    };

    ghostty = import ./programs/ghostty.nix { inherit config pkgs; };

    git = import ./programs/git.nix;

    home-manager = {
      enable = true;
    };

    jq = import ./programs/jq.nix;

    k9s = import ./programs/k9s.nix;

    kubecolor = import ./programs/kubecolor.nix;

    micro = import ./programs/micro.nix { inherit pkgs; };

    mise = import ./programs/mise.nix;

    mpv = import ./programs/mpv.nix { inherit config pkgs; };

    nix-your-shell = import ./programs/nix-your-shell.nix;

    readline = import ./programs/readline.nix;

    ssh = import ./programs/ssh.nix;

    vscode = import ./programs/vscode.nix { inherit config utils pkgs; };

    yt-dlp = import ./programs/yt-dlp.nix;
  };

  services = {
    podman = import ./services/podman.nix;

    syncthing = import ./services/syncthing.nix;
  };

  systemd = {
    user = {
      inherit (defaults) sessionVariables;

      services = {
        dump-packages = import ./systemd/user/services/dump-packages.nix;
      };
      timers = {
        dump-packages = import ./systemd/user/timers/dump-packages.nix;
      };
    };
  };

  targets = {
    genericLinux = {
      enable = true;
    };
  };

  xdg = {
    mime = {
      enable = true;
    };
  };
}
