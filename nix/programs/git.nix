{ nixpkgsUnstable }:
{
  enable = true;
  package = nixpkgsUnstable.git;
  userName = "m4rc3l05";
  userEmail = "15786310+M4RC3L05@users.noreply.github.com";
  extraConfig = {
    user = {
      useConfigOnly = true;
    };
    init = {
      defaultBranch = "main";
    };
    core = {
      editor = "micro";
    };
  };

  lfs = {
    enable = true;
  };
}
