{
  config,
  pkgs,
  lib,
  ...
}:
let
  nixgl = import <nixgl> { };

  nixpkgsUnstable = import <nixpkgs-unstable> {
    config.allowUnfree = true;
  };

  utils = import ./utils/mod.nix {
    inherit pkgs;
    inherit lib;
  };

  defaults = import ./defaults.nix;
in
{
  home = {
    username = "main";
    homeDirectory = "/home/main";
    stateVersion = "24.11";

    activation = {
      copyFonts = import ./home/activation/copy-fonts.nix {
        inherit lib;
      };
    };

    packages = import ./home/packages.nix {
      inherit config;
      inherit nixpkgsUnstable;
      inherit utils;
    };

    file = import ./home/file.nix;

    sessionVariables = defaults.sessionVariables;
  };

  fonts = {
    fontconfig = {
      enable = true;
    };
  };

  nixGL = {
    packages = nixgl;
    vulkan = {
      enable = true;
    };
  };

  programs = {
    bash = import ./programs/bash.nix {
      inherit defaults;
      inherit nixpkgsUnstable;
    };

    bat = import ./programs/bat.nix {
      inherit nixpkgsUnstable;
    };

    btop = import ./programs/btop.nix {
      inherit nixpkgsUnstable;
    };

    eza = import ./programs/eza.nix {
      inherit nixpkgsUnstable;
    };

    fastfetch = import ./programs/fastfetch.nix {
      inherit nixpkgsUnstable;
    };

    firefox = import ./programs/firefox.nix {
      inherit config;
      inherit nixpkgsUnstable;
    };

    fish = import ./programs/fish.nix {
      inherit defaults;
      inherit nixpkgsUnstable;
    };

    git = import ./programs/git.nix {
      inherit nixpkgsUnstable;
    };

    home-manager = {
      enable = true;
    };

    jq = import ./programs/jq.nix {
      inherit nixpkgsUnstable;
    };

    k9s = import ./programs/k9s.nix {
      inherit nixpkgsUnstable;
    };

    kubecolor = import ./programs/kubecolor.nix {
      inherit nixpkgsUnstable;
    };

    micro = import ./programs/micro.nix {
      inherit nixpkgsUnstable;
    };

    mise = import ./programs/mise.nix {
      inherit nixpkgsUnstable;
    };

    mpv = import ./programs/mpv.nix {
      inherit config;
      inherit nixpkgsUnstable;
    };

    nix-your-shell = import ./programs/nix-your-shell.nix;

    readline = import ./programs/readline.nix;

    ssh = import ./programs/ssh.nix;

    vscode = import ./programs/vscode.nix {
      inherit config;
      inherit utils;
      inherit nixpkgsUnstable;
    };

    yt-dlp = import ./programs/yt-dlp.nix {
      inherit nixpkgsUnstable;
    };
  };

  services = {
    syncthing = import ./services/syncthing.nix {
      inherit nixpkgsUnstable;
    };

    podman = import ./services/podman.nix {
      inherit nixpkgsUnstable;
    };
  };

  systemd = {
    user = {
      services = {
        dump-packages = import ./systemd/user/services/dump-packages.nix;
      };
      sessionVariables = defaults.sessionVariables;
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
