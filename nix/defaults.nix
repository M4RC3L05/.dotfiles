{
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
    QT_QPA_PLATFORM = "wayland;xcb";
    CLUTTER_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland,x11";

    # bitwarden
    # Home dir for now: https://github.com/bitwarden/clients/issues/12417
    BITWARDEN_SSH_AUTH_SOCK = "$HOME/bitwarden-ssh-agent.sock";
    SSH_AUTH_SOCK = "$HOME/bitwarden-ssh-agent.sock";
  };

  shellAliases = {
    cat = "bat --plain";
    ls = "eza --color=auto --header --git --icons";
    code = "codium";
  };
}