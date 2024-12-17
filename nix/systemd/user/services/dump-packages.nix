{
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
}
