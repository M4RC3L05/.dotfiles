# Based on:  https://github.com/MaeIsBad/home-manager/blob/04f424bb147e62c1ed6fb4811f41054d3608ea6e/modules/virtualisation/podman/podman.nix

{
  Unit = {
    Description = "Podman API Socket";
    Documentation = "man:podman-system-service(1)";
  };
  Socket = {
    ListenStream = "%t/podman/podman.sock";
    SocketMode = 660;
  };
  Install.WantedBy = [ "sockets.target" ];
}
