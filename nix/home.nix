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
    { this, using }:
    let
      thisEnv = this.env or [ ];
      thisEnvNormalized = if thisEnv == [ ] then thisEnv else (thisEnv ++ [ "" ]);

      thisFlags = this.flags or [ ];
      thisFlagsNormalized = if thisFlags == [ ] then thisFlags else ([ "" ] ++ thisFlags);
    in
    nixpkgsUnstable.runCommand "${this.pkg.name}-${using.pkg.name}-wrapper" this.derivarionEnv or { } ''
       mkdir $out

       ln -s ${this.pkg}/* $out

       rm $out/bin

       mkdir $out/bin

       ln -s ${this.pkg}/bin/* $out/bin

      ${nixpkgsUnstable.lib.concatStringsSep " " (
        nixpkgsUnstable.lib.map (bin: ''
          echo "=> Wrapping ${bin} using ${using.pkg.name}"

          wrapped_source_path="${this.pkg}/bin/${bin}"
          wrapped_destination_path="$out/bin/${bin}"
          rm "$wrapped_destination_path"

          ${
            if this.pkg.drvPath == using.pkg.drvPath then
              ''
                printf "#!${nixpkgsUnstable.stdenv.shell}\n\n%sexec ${nixpkgsUnstable.lib.getExe using.pkg}%s \"\$@\"" "${nixpkgsUnstable.lib.concatStringsSep " " thisEnvNormalized}" "${nixpkgsUnstable.lib.concatStringsSep " " thisFlagsNormalized}" > $wrapped_destination_path
                chmod +x $wrapped_destination_path
              ''
            else
              ''
                printf "#!${nixpkgsUnstable.stdenv.shell}\n\n%sexec ${nixpkgsUnstable.lib.getExe using.pkg}%s%s \"\$@\"" "${nixpkgsUnstable.lib.concatStringsSep " " thisEnvNormalized}" " $wrapped_source_path" "${nixpkgsUnstable.lib.concatStringsSep " " thisFlagsNormalized}" > $wrapped_destination_path
                chmod +x $wrapped_destination_path
              ''
          }
        '') this.bins or [ this.pkg.meta.mainProgram ]
      )}
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
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.activation = {
    copyFonts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p $HOME/.local/share/fonts

      if [ -d "$HOME/.local/share/fonts/nix" ]; then
        rm -r $HOME/.local/share/fonts/nix
      fi

      mkdir -p $HOME/.local/share/fonts/nix
      cp -rL $HOME/.nix-profile/share/fonts/* $HOME/.local/share/fonts/nix
      chmod -R u+rw,g+rw $HOME/.local/share/fonts/nix
    '';
  };

  home.packages = [
    nixgl.auto.nixGLNvidia
    nixgl.auto.nixVulkanNvidia
    nixgl.nixGLIntel
    nixgl.nixVulkanIntel

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
    nixpkgsUnstable.oha
    nixpkgsUnstable.podman
    nixpkgsUnstable.q
    nixpkgsUnstable.rsync
    nixpkgsUnstable.tldr
    nixpkgsUnstable.tokei
    nixpkgsUnstable.tree
    nixpkgsUnstable.vim
    nixpkgsUnstable.wget
    nixpkgsUnstable.yt-dlp

    (wrap {
      this = {
        pkg = nixpkgsUnstable.nvtopPackages.full;
      };
      using = {
        pkg = nixgl.auto.nixGLNvidia;
      };
    })

    (wrap {
      this = {
        pkg = nixpkgsUnstable.zed-editor;
      };
      using = {
        pkg = nixgl.nixVulkanIntel;
      };
    })

    (wrap {
      this = {
        pkg = nixpkgsUnstable.youtube-music;
        flags = [
          "--enable-features=UseOzonePlatform,WaylandWindowDecorations"
          "--ozone-platform-hint=wayland"
          "--disable-gpu"
        ];
      };
      using = {
        pkg = nixpkgsUnstable.youtube-music;
      };
    })
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

  home.sessionVariables = { };

  fonts = {
    fontconfig = {
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
          editor = "vim";
        };
      };

      lfs = {
        enable = true;
      };
    };

    home-manager = {
      enable = true;
    };

    mise = {
      package = nixpkgsUnstable.mise;
      enable = true;
      enableBashIntegration = true;
      globalConfig = {
        settings = {
          experimental = true;
        };
        tools = {
          usage = "latest";
        };
      };
    };

    mpv = {
      enable = true;
      package = (
        wrap {
          this = {
            pkg = nixpkgsUnstable.mpv;
            bins = [
              "mpv"
              "umpv"
            ];
          };
          using = {
            pkg = nixgl.nixGLIntel;
          };
        }
      );
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
        wrap {
          this = {
            derivarionEnv = {
              pname = nixpkgsUnstable.vscode.pname;
              version = nixpkgsUnstable.vscode.version;
              meta = {
                mainProgram = "${nixpkgsUnstable.vscode.name}-${nixgl.nixGLIntel.name}-wrapper";
              };
            };
            pkg = nixpkgsUnstable.vscode;
            flags = [
              "--enable-features=UseOzonePlatform,WaylandWindowDecorations"
              "--ozone-platform-hint=wayland"
            ];
          };
          using = {
            pkg = nixgl.nixGLIntel;
          };
        }
      );
      extensions = [
        nixpkgsUnstable.vscode-extensions.denoland.vscode-deno
        nixpkgsUnstable.vscode-extensions.esbenp.prettier-vscode
        nixpkgsUnstable.vscode-extensions.jnoortheen.nix-ide
        nixpkgsUnstable.vscode-extensions.rust-lang.rust-analyzer
        nixpkgsUnstable.vscode-extensions.tamasfe.even-better-toml
      ];
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
