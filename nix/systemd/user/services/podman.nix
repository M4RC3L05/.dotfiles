# Based on:  https://github.com/MaeIsBad/home-manager/blob/04f424bb147e62c1ed6fb4811f41054d3608ea6e/modules/virtualisation/podman/podman.nix

{ pkgs }:
{
  Unit = {
    Description = "Podman API Service";
    Requires = [ "podman.socket" ];
    After = [ "podman.socket" ];
    Documentation = "man:podman-system-service(1)";
    StartLimitIntervalSec = 0;
  };

  Service = {
    Type = "exec";
    KillMode = "process";
    Environment = ''LOGGING=" --log-level=info"'';
    ExecStart = [
      ""
      "${pkgs.podman}/bin/podman $LOGGING system service"
    ];
  };

  Install = {
    WantedBy = [ "default.target" ];
  };
}
