{
  enable = true;
  guiAddress = "127.0.0.1:8384";
  overrideDevices = true;
  overrideFolders = true;
  settings = {
    devices = {
      mainphone = {
        id = "QWCBKVJ-W5VN4QW-XLLS2AY-T2ZX6P2-CA4ILTN-FHOLCOJ-EQKJJ4F-R5PYKAO";
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
