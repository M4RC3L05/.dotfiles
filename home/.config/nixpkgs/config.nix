{
  allowUnfree = true;

  nixpkgs = import <nixpkgs-unstable> {};

  packageOverrides = pkgs: with pkgs; {
    mainPackages = pkgs.buildEnv {
      name = "main-packages";
      paths = [
        vscode
        ffmpeg_7-full
        bat
        btop
        curl
        dive
        podman
        fish
        doggo
        eza
        fastfetch
        git
        git-lfs
        jq
        k9s
        kubectl
        lsof
        vim
        nvtopPackages.full
        rsync
        stow
        tldr
        tokei
        tree
        yt-dlp
        mpv
        cascadia-code
        syncthing
        zed-editor
        wrk
        mise
      ];
    };
  };
}
