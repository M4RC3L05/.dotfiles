{ pkgs }:
{
  enable = true;
  package = pkgs.podman;
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
