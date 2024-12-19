{
  enable = true;
  addKeysToAgent = "no";
  forwardAgent = false;
  matchBlocks = {
    "mainserver" = {
      hostname = "192.168.1.200";
      forwardAgent = false;
      user = "main";
    };
  };
}
