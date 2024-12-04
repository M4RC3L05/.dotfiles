{
  config,
  pkgs,
  lib,
  ...
}:
let
  nixgl = import <nixgl> { };
  nixpkgsUnstable = import <nixpkgs-unstable> { };

  # https://nixos.wiki/wiki/Nix_Cookbook#Wrapping_packages
  wrap =
    pkg: env: flags: environment:
    pkgs.runCommand "${pkg.name}-custom-wrapper"
      (lib.attrsets.mergeAttrsList [
        (environment)
        ({ buildInputs = [ pkgs.makeWrapper ]; })
      ])
      ''
        mkdir $out
        ln -s ${pkg}/* $out
        rm $out/bin
        mkdir $out/bin
        ln -s ${pkg}/bin/* $out/bin

        for file in ${pkg}/bin/*; do
          prog="$(basename "$file")"
          rm "$out/bin/$prog"

          makeWrapper "${lib.getExe pkg}" "$out/bin/$prog" --add-flags "$file" ${
            lib.concatStringsSep " " (lib.map (val: ''--add-flags "${val}"'') (flags))
          } ${
            lib.concatStringsSep " " (lib.attrsets.mapAttrsToList (var: val: ''--set "${var}" "${val}"'') env)
          }
        done
      '';
in
{
  home.username = "main";
  home.homeDirectory = "/home/main";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.activation = {
    copyFonts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -d "$HOME/.nix-profile/share/fonts" ]; then
        run mkdir -p $HOME/.local/share/fonts

        if [ -d "$HOME/.local/share/fonts/nix" ]; then
          run rm -r $HOME/.local/share/fonts/nix
        fi

        run mkdir -p $HOME/.local/share/fonts/nix
        run cp -rL $HOME/.nix-profile/share/fonts/* $HOME/.local/share/fonts/nix
        run chmod -R u+rw,g+rw $HOME/.local/share/fonts/nix
      fi
    '';
  };

  home.packages = [
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
    nixpkgsUnstable.nix-your-shell
    nixpkgsUnstable.hyperfine
    nixpkgsUnstable.wrk
    (config.lib.nixGL.wrappers.nvidia nixpkgsUnstable.nvtopPackages.full)
    (config.lib.nixGL.wrappers.mesa nixpkgsUnstable.zed-editor)

    (config.lib.nixGL.wrappers.mesa (
      wrap nixpkgsUnstable.youtube-music {
        NIXOS_OZONE_WL = "1";
      } [ "--disable-gpu" ] { }
    ))
  ];

  home.file = {
    ".config" = {
      source = ~/.dotfiles/home/.config;
      recursive = true;
    };
    ".local" = {
      source = ~/.dotfiles/home/.local;
      recursive = true;
    };
    ".inputrc" = {
      source = ~/.dotfiles/home/.inputrc;
    };
    ".eget.toml" = {
      source = ~/.dotfiles/home/.eget.toml;
    };
  };

  home.sessionVariables = {
    # misc
    EDITOR = "micro";

    # docker
    DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/podman/podman.sock";

    #firefox
    MOZ_ENABLE_WAYLAND = 1;

    # bin paths
    PATH = "$PATH:$HOME/AppImages:$HOME/.local/bin";

    # locale stuff
    # LOCALE_ARCHIVE = "/usr/lib/locale/locale-archive"

    # prefer wayland
    QT_QPA_PLATFORM = "wayland;xcb";
    CLUTTER_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland,x11";
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
    bash = {
      enable = true;
      shellAliases = {
        cat = "bat --plain";
        ls = "eza --color=auto --header --git --icons";
      };
      bashrcExtra = ''
        export TERM="xterm-256color";

        eval "$(${nixpkgsUnstable.lib.getExe nixpkgsUnstable.bat-extras.batman} --export-env)"
      '';
      initExtra = ''
        if [[ $(${nixpkgsUnstable.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${nixpkgsUnstable.fish}/bin/fish $LOGIN_OPTION
        fi

        # Git prompt
        . ~/.nix-profile/share/git/contrib/completion/git-prompt.sh

        # Prompt
        prompt() {
          local color_red="\001\e[31m\002"
          local color_green='\001\e[32m\002'
          local color_grey='\001\e[37m\002'
          local color_reset='\001\e[0m\002'

          local error="no"
          local exit_statuses=("$@")
          local username="''${USER:-$(whoami)}"
          local hostname="''${HOSTNAME:-$(hostname)}"
          local home="''${HOME:-$(echo ~)}"
          local path="''${PWD:-$(pwd)}"
          path="''${path/#$home/'~'}"
          path="$(echo "$path" | awk -F'/' '{for(i=1;i<NF;i++) printf "%s/", substr($i,1,1); print $NF}')"
          local git_branch="$(__git_ps1 " $color_grey%s$color_reset")"

          echo -en "$color_green$path$color_reset"
          echo -en "$git_branch"

          if [[ -n "$git_branch" ]] && [[ -n "$(git status --porcelain)" ]]; then
            echo -en "*"
          fi

          echo -en " "

          for exit_status in "''${exit_statuses[@]}"; do
            if [[ "$exit_status" != "0" ]]; then
              error="yes"
              break
            fi
          done

          if [[ "$error" == "yes" ]]; then
            local exit_statuses_joined="''${exit_statuses[*]}"
            echo -en "$color_red[''${exit_statuses_joined// / | }]❱$color_reset"
          else
            echo -en "❱"
          fi
        }

        PS1='$(prompt "''${PIPESTATUS[@]}") '

        eval "$(~/.local/bin/mise activate bash)"

        # Greeting
        the-office-quote
        echo
      '';
    };

    bat = {
      enable = true;
      package = nixpkgsUnstable.bat;
      extraPackages = [ nixpkgsUnstable.bat-extras.batman ];
    };

    fish = {
      enable = true;
      package = nixpkgsUnstable.fish;
      shellAliases = {
        cat = "bat --plain";
        ls = "eza --color=auto --header --git --icons";
      };
      functions = {
        fish_greeting = "the-office-quote; echo";
      };
      interactiveShellInit = ''
        set -g hydro_color_pwd green
        set -g hydro_color_prompt magenta
        set -g hydro_color_duration yellow

        ${nixpkgsUnstable.lib.getExe nixpkgsUnstable.nix-your-shell} fish | source

        ~/.local/bin/mise activate fish | source
      '';
      plugins = [
        {
          name = "hydro";
          src = nixpkgsUnstable.fishPlugins.hydro.src;
        }
      ];
    };

    git = {
      enable = true;
      package = nixpkgsUnstable.git;
      userName = "m4rc3l05";
      userEmail = "15786310+M4RC3L05@users.noreply.github.com";
      extraConfig = {
        user = {
          useConfigOnly = true;
        };
        init = {
          defaultBranch = "main";
        };
        core = {
          editor = "micro";
        };
      };

      lfs = {
        enable = true;
      };
    };

    home-manager = {
      enable = true;
    };

    mpv = {
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
    };

    ssh = {
      enable = true;
      addKeysToAgent = "yes";
      matchBlocks = {
        "github.com" = {
          identityFile = "~/.ssh/github";
          identitiesOnly = true;
        };

        "mainserver" = {
          hostname = "192.168.1.200";
          identityFile = "~/.ssh/main";
          identitiesOnly = true;
          forwardAgent = true;
          user = "main";
        };
      };
    };

    vscode = {
      enable = true;
      package = (
        config.lib.nixGL.wrappers.mesa (
          wrap nixpkgsUnstable.vscode
            {
              NIXOS_OZONE_WL = "1";
            }
            [ ]
            {
              pname = nixpkgsUnstable.vscode.pname;
              version = nixpkgsUnstable.vscode.version;
              meta = nixpkgsUnstable.vscode.meta;
            }
        )
      );
      extensions = [
        nixpkgsUnstable.vscode-extensions.denoland.vscode-deno
        nixpkgsUnstable.vscode-extensions.tamasfe.even-better-toml
        nixpkgsUnstable.vscode-extensions.skyapps.fish-vscode
        nixpkgsUnstable.vscode-extensions.jnoortheen.nix-ide
      ];
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      userSettings = {
        "diffEditor.ignoreTrimWhitespace" = true;
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.fontFamily" = "'Cascadia Code', 'monospace', monospace";
        "editor.fontLigatures" = true;
        "editor.fontSize" = 13;
        "editor.formatOnSave" = true;
        "editor.smoothScrolling" = true;
        "editor.tabSize" = 2;
        "extensions.ignoreRecommendations" = true;
        "files.autoSave" = "onFocusChange";
        "telemetry.telemetryLevel" = "off";
        "terminal.integrated.fontFamily" = "'Cascadia Code NF', 'monospace', monospace";
        "terminal.integrated.smoothScrolling" = true;
        "window.autoDetectColorScheme" = true;
        "window.dialogStyle" = "custom";
        "window.titleBarStyle" = "custom";
        "workbench.list.smoothScrolling" = true;
        "workbench.preferredDarkColorTheme" = "Default Dark Modern";
        "workbench.preferredLightColorTheme" = "Default Light Modern";
      };
    };
  };

  services = {
    syncthing = {
      enable = true;
    };
  };

  systemd = {
    user = {
      services = {
        dump-packages = {
          Unit = {
            Description = "Dump packages to a file";
          };
          Service = {
            Type = "oneshot";
            ExecStart = "/home/main/.local/bin/dump-packages";
          };
          Install = {
            WantedBy = [ "default.target" ];
          };
        };
      };
      sessionVariables = {
        # misc
        EDITOR = "micro";

        # docker
        DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/podman/podman.sock";

        #firefox
        MOZ_ENABLE_WAYLAND = 1;

        # bin paths
        PATH = "$PATH:$HOME/AppImages:$HOME/.local/bin";

        # locale stuff
        # LOCALE_ARCHIVE = "/usr/lib/locale/locale-archive"

        # prefer wayland
        QT_QPA_PLATFORM = ''"wayland;xcb"'';
        CLUTTER_BACKEND = "wayland";
        SDL_VIDEODRIVER = ''"wayland,x11"'';
      };
      timers = {
        dump-packages = {
          Unit = {
            Description = "Timer for dump-packages service";
          };
          Timer = {
            OnCalendar = "*:0/1";
          };
          Install = {
            WantedBy = [ "timers.target" ];
          };
        };
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
