{
  config,
  utils,
  pkgs,
}:
{
  enable = true;
  package = config.lib.nixGL.wrappers.mesa (
    utils.wrap pkgs.vscode {
      env = {
        NIXOS_OZONE_WL = "1";
      };
      environment = { inherit (pkgs.vscode) pname version meta; };
    }
  );
  extensions = [
    pkgs.vscode-extensions.denoland.vscode-deno
    pkgs.vscode-extensions.tamasfe.even-better-toml
    pkgs.vscode-extensions.skyapps.fish-vscode
    pkgs.vscode-extensions.jnoortheen.nix-ide
    pkgs.vscode-extensions.mads-hartmann.bash-ide-vscode
  ];
  enableUpdateCheck = false;
  enableExtensionUpdateCheck = true;
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
    "terminal.integrated.defaultProfile.linux" = "fish";
    "terminal.integrated.fontFamily" = "'Cascadia Code NF', 'monospace', monospace";
    "terminal.integrated.smoothScrolling" = true;
    "window.autoDetectColorScheme" = true;
    "window.dialogStyle" = "custom";
    "window.titleBarStyle" = "custom";
    "workbench.list.smoothScrolling" = true;
    "workbench.preferredDarkColorTheme" = "Default Dark Modern";
    "workbench.preferredLightColorTheme" = "Default Light Modern";
  };
}
