{ nixpkgsUnstable }:
{
  enable = true;
  package = nixpkgsUnstable.syncthing;
  guiAddress = "127.0.0.1:8384";
  overrideDevices = true;
  overrideFolders = true;
  settings = {
    devices = {
      mainphone = {
        id = "SE33S73-MJNXF4Q-LNXD5PU-FBWQIGR-H3AQKTI-2673GBO-DWH6ONJ-5R7VZQY";
      };
      maintablet = {
        id = "HQRTVSH-5BRZQ2M-X5FJEYL-V2E3BZU-LO47TRO-ICLA3SJ-3MCHKIU-YGX3EAG";
      };
    };
    folders = {
      "~/Music" = {
        enable = true;
        label = "music";
        type = "sendonly";
        devices = [
          "mainphone"
          "maintablet"
        ];
      };
      "~/notes" = {
        enable = true;
        label = "notes";
        type = "sendonly";
        devices = [ "maintablet" ];
      };
    };
    gui = {
      theme = "dark";
    };
    options = {
      relaysEnabled = false;
      localAnnounceEnabled = true;
      globalAnnounceEnabled = false;
      natEnabled = false;
      urAccepted = -1;
    };
  };
}
