{ pkgs }:
{
  enable = true;
  settings = {
    policy = {
      default = [
        {
          type = "insecureAcceptAnything";
        }
      ];
    };
    registries = {
      search = [ "docker.io" ];
    };
  };
}
