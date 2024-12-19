{
  enable = true;
  addKeysToAgent = "no";
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
}
