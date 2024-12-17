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

  # https://nixos.wiki/wiki/Nix_Cookbook#Wrapping_packages
  wrap =
    pkg: options:
    let
      bins = options.bins or [ pkg.meta.mainProgram ];
      concatFlags = lib.concatStringsSep " " (
        lib.map (val: "--add-flags \"${val}\"") (options.flags or [ ])
      );
      concatEnvs = lib.concatStringsSep " " (
        lib.attrsets.mapAttrsToList (var: val: "--set \"${var}\" \"${val}\"") (options.env or [ ])
      );
      wrappingByBin = lib.listToAttrs (
        lib.map (bin: {
          name = bin;
          value = lib.concatStringsSep " " (
            lib.filter (item: item != "") [
              "makeWrapper \"${pkg}/bin/${bin}\" \"$out/bin/${bin}\""
              concatFlags
              concatEnvs
            ]
          );
        }) bins
      );
      mergedRunEnvironment = lib.attrsets.mergeAttrsList [
        (options.environment or { })
        ({ buildInputs = [ pkgs.makeWrapper ]; })
      ];
    in
    pkgs.runCommand "${pkg.name}-custom-wrapper" mergedRunEnvironment ''
      mkdir $out
      ln -s ${pkg}/* $out
      rm $out/bin
      mkdir $out/bin
      ln -s ${pkg}/bin/* $out/bin

      ${lib.concatStringsSep "\n" (
        lib.map (
          bin:
          let
            wrap = lib.getAttr bin wrappingByBin;
          in
          ''
            echo "=> Wrapping \"${bin}\""
            echo '==> ${wrap}'

            rm -rf "$out/bin/${bin}"
            ${wrap}
          ''
        ) bins
      )}
    '';

  baseSessionVariables = {
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

    # bitwarden
    # Home dir for now: https://github.com/bitwarden/clients/issues/12417
    BITWARDEN_SSH_AUTH_SOCK = "$HOME/bitwarden-ssh-agent.sock";
    SSH_AUTH_SOCK = "$HOME/bitwarden-ssh-agent.sock";
  };

  baseShellAlias = {
    cat = "bat --plain";
    ls = "eza --color=auto --header --git --icons";
    code = "codium";
  };
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
    nixpkgsUnstable.hyperfine
    nixpkgsUnstable.wrk
    nixpkgsUnstable.zip
    (config.lib.nixGL.wrappers.nvidia nixpkgsUnstable.nvtopPackages.full)
    (config.lib.nixGL.wrappers.mesa nixpkgsUnstable.zed-editor)

    (config.lib.nixGL.wrappers.mesa (
      wrap nixpkgsUnstable.youtube-music {
        env = {
          NIXOS_OZONE_WL = "1";
        };
        flags = [ "--disable-gpu" ];
      }
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
    ".eget.toml" = {
      source = ~/.dotfiles/home/.eget.toml;
    };
  };

  home.sessionVariables = baseSessionVariables;

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
      shellAliases = baseShellAlias;
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
        . ${nixpkgsUnstable.git}/share/git/contrib/completion/git-prompt.sh

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

    firefox = {
      enable = true;
      package = config.lib.nixGL.wrappers.mesa (
        nixpkgsUnstable.wrapFirefox nixpkgsUnstable.firefox-unwrapped {
          extraPolicies = {
            UserMessaging = {
              SkipOnboarding = true;
            };
            ExtensionSettings = {
              "*" = {
                installation_mode = "blocked";
              };
              "uBlock0@raymondhill.net" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
                installation_mode = "force_installed";
                default_area = "navbar";
                updates_disabled = false;
              };
              "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
                installation_mode = "force_installed";
                default_area = "navbar";
                updates_disabled = false;
              };
            };
            "3rdparty" = {
              Extensions = {
                "uBlock0@raymondhill.net" = {
                  adminSettings = {
                    dynamicFilteringString = "* * 3p-frame block";
                    userSettings = {
                      advancedUserEnabled = true;
                      cloudStorageEnabled = false;
                      dynamicFilteringEnabled = true;
                    };
                  };
                  toOverwrite = {
                    filters = [
                      "www.twitch.tv##.consent-banner.kclbMN.Layout-sc-1xcs6mc-0"
                      "www.twitch.tv##.ceAbGI.Layout-sc-1xcs6mc-0"
                    ];
                    filterLists = [
                      "user-filters"
                      "ublock-filters"
                      "ublock-badware"
                      "ublock-privacy"
                      "ublock-quick-fixes"
                      "ublock-abuse"
                      "ublock-unbreak"
                      "easylist"
                      "easyprivacy"
                      "urlhaus-1"
                      "plowe-0"

                      "adguard-spyware-url"
                      "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/LegitimateURLShortener.txt"
                    ];
                  };
                };
                "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
                  environment = {
                    base = "https://vaultwarden.gufu.duckdns.org";
                  };
                };
              };
            };
          };
        }
      );
      profiles = {
        main = {
          id = 0;
          isDefault = true;
          bookmarks = [
            {
              name = "Toolbar";
              toolbar = true;
              bookmarks = [
                {
                  name = "Home";
                  url = "https://home.gufu.duckdns.org";
                }
                {
                  name = "Syncthing";
                  url = "http://127.0.0.1:8384";
                }
              ];
            }
          ];
          search = {
            default = "DuckDuckGo";
            force = true;
            privateDefault = "DuckDuckGo";
          };
          settings = {
            # Home
            ## New Windows and Tabs
            "browser.startup.page" = 1;
            "browser.startup.homepage" = "about:home";
            "browser.newtabpage.enabled" = true;

            ## Firefox Home Content
            "browser.newtabpage.activity-stream.showSearch" = true;

            "browser.newtabpage.activity-stream.feeds.topsites" = false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

            "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
            "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
            "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
            "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
            "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;

            # Search
            ## Search suggestions
            "browser.search.suggest.enabled" = false;
            "browser.search.suggest.enabled.private" = false;
            "browser.urlbar.trending.featureGate" = false;
            "browser.urlbar.recentsearches.featureGate" = false;

            ## Address Bar
            "browser.urlbar.suggest.history" = false;
            "browser.urlbar.suggest.bookmark" = true;
            "browser.urlbar.suggest.openpage" = false;
            "browser.urlbar.suggest.topsites" = false;
            "browser.urlbar.suggest.engines" = false;

            # Privacy & Security
            ## Enhanced Tracking Protection
            "browser.contentblocking.category" = "strict";

            ## Cookies and Site Data
            "privacy.clearSiteData.cache" = true;
            "privacy.clearSiteData.cookiesAndStorage" = false;
            "privacy.clearSiteData.historyFormDataAndDownloads" = true;
            "privacy.clearSiteData.siteSettings" = true;

            ## Passwords
            "signon.rememberSignons" = false;
            "signon.autofillForms" = false;

            ## Autofill
            "extensions.formautofill.addresses.enabled" = false;
            "extensions.formautofill.creditCards.enabled" = false;

            ## History
            "browser.formfill.enable" = false;
            "places.history.enabled" = false;
            "privacy.sanitize.sanitizeOnShutdown" = true;
            "privacy.clearOnShutdown.cache" = true;
            "privacy.clearOnShutdown_v2.cache" = true;
            "privacy.clearOnShutdown.downloads" = true;
            "privacy.clearOnShutdown.formdata" = true;
            "privacy.clearOnShutdown.history" = true;
            "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = true;
            "privacy.clearOnShutdown.siteSettings" = true;
            "privacy.clearOnShutdown_v2.siteSettings" = true;

            ## Firefox data collection and use
            "datareporting.healthreport.uploadEnabled" = false;
            "app.shield.optoutstudies.enabled" = false;
            "browser.discovery.enabled" = false;
            "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;

            ## Website advertising preferences
            "dom.private-attribution.submission.enabled" = false;

            ## HTTPS-Only Mode
            "dom.security.https_only_mode" = true;

            ## DNS over HTTPS
            "network.trr.mode" = 3;
            "network.trr.uri" = "https://doh.gufu.duckdns.org/dns-query";
            "network.trr.excluded-domains" = "gufu.duckdns.org";

            # Extra
            "browser.toolbars.bookmarks.visibility" = "always";
          };
        };
      };
    };

    fish = {
      enable = true;
      package = nixpkgsUnstable.fish;
      shellAliases = baseShellAlias;
      functions = {
        fish_greeting = "the-office-quote; echo";
      };
      interactiveShellInit = ''
        set -g hydro_color_pwd green
        set -g hydro_color_prompt magenta
        set -g hydro_color_duration yellow
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

    kubecolor = {
      enable = true;
      package = nixpkgsUnstable.kubecolor;
    };

    mise = {
      enable = true;
      package = nixpkgsUnstable.mise;
      enableBashIntegration = true;
      enableFishIntegration = true;
      globalConfig = {
        tools = {
          usage = "latest";
        };
      };
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

    nix-your-shell = {
      enable = true;
      enableFishIntegration = true;
    };

    readline = {
      enable = true;
      includeSystemConfig = true;
      bindings = {
        "\\e[A" = "history-search-backward";
        "\\e[B" = "history-search-forward";
        "\\e[1;5D" = "backward-word";
        "\\e[1;5C" = "forward-word";
        TAB = "menu-complete";
        "\\e[Z" = "menu-complete-backward";
      };
      variables = {
        "bell-style" = "none";
        "colored-stats" = "on";
        "visible-stats" = "on";
        "mark-symlinked-directories" = "on";
        "colored-completion-prefix" = "on";
        "menu-complete-display-prefix" = "on";
        "show-all-if-ambiguous" = "on";
        "completion-ignore-case" = "on";
        "completion-map-case" = "on";
        "skip-completed-text" = "on";
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
          wrap nixpkgsUnstable.vscodium {
            env = {
              NIXOS_OZONE_WL = "1";
            };
            environment = {
              pname = nixpkgsUnstable.vscodium.pname;
              version = nixpkgsUnstable.vscodium.version;
              meta = nixpkgsUnstable.vscodium.meta;
            };
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
      sessionVariables = baseSessionVariables;
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
