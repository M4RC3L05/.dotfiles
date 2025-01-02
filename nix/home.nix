{
  config,
  pkgs,
  lib,
  ...
}:
let

  nixgl = import <nixgl> {
    inherit pkgs;
  };

  utils = import ./utils/mod.nix {
    inherit
      pkgs
      lib
      ;
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
      inherit
        config
        pkgs
        utils
        ;
    };

    file = import ./home/file.nix;

    sessionVariables = defaults.sessionVariables;
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
        ;
    };

    bat = import ./programs/bat.nix {
      inherit pkgs;
    };

    btop = import ./programs/btop.nix {
      inherit pkgs;
    };

    eza = import ./programs/eza.nix {
      inherit pkgs;
    };

    fastfetch = import ./programs/fastfetch.nix {
      inherit pkgs;
    };

    firefox = import ./programs/firefox.nix {
      inherit
        pkgs
        config
        ;
    };

    fish = import ./programs/fish.nix {
      inherit
        defaults
        pkgs
        ;
    };

    git = import ./programs/git.nix {
      inherit pkgs;
    };

    ghostty = import ./programs/ghostty.nix {
      inherit
        config
        pkgs
        ;
    };

    home-manager = {
      enable = true;
    };

    jq = import ./programs/jq.nix {
      inherit pkgs;
    };

    k9s = import ./programs/k9s.nix {
      inherit pkgs;
    };

    kubecolor = import ./programs/kubecolor.nix {
      inherit pkgs;
    };

    micro = import ./programs/micro.nix {
      inherit pkgs;
    };

    mise = import ./programs/mise.nix {
      inherit pkgs;
    };

    mpv = import ./programs/mpv.nix {
      inherit
        config
        pkgs
        ;
    };

    nix-your-shell = import ./programs/nix-your-shell.nix;

    readline = import ./programs/readline.nix;

    ssh = import ./programs/ssh.nix;

    vscode = import ./programs/vscode.nix {
      inherit
        config
        utils
        pkgs
        ;
    };

    yt-dlp = import ./programs/yt-dlp.nix {
      inherit pkgs;
    };
  };

  services = {
    syncthing = import ./services/syncthing.nix {
      inherit pkgs;
    };

    podman = import ./services/podman.nix {
      inherit pkgs;
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
      desktopFileUtilsPackage = pkgs.desktop-file-utils;
      sharedMimeInfoPackage = pkgs.shared-mime-info;
    };
  };
}
