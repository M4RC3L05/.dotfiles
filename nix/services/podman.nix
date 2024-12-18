{ nixpkgsUnstable }:
{
  enable = true;
  package = nixpkgsUnstable.podman;
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
