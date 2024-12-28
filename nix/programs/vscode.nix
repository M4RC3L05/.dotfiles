{
  config,
  utils,
  nixpkgsUnstable,
}:
{
  enable = true;
  package = (
    config.lib.nixGL.wrappers.mesa (
      utils.wrap nixpkgsUnstable.vscodium {
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
