{
  pkgs ? import <nixpkgs> { },
  lib,
}:
pkgs.stdenv.mkDerivation rec {
  binName = "denotag";
  pname = "@m4rc3l05/${binName}";
  version = "4.6.8";

  src = pkgs.fetchurl {
    url = "https://github.com/M4RC3L05/denotag/releases/download/v${version}/denotag-x86_64-unknown-linux-gnu.tar.gz";
    sha256 = "sha256-Hxy/TtUbX/AJgxulq3SJVMI+ytfnGjGWP9sRja2jqKE=";
  };

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"/bin
    cp ./${binName} "$out"/bin/${binName}
    chmod +x "$out"/bin/${binName}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Deno audio Tag editor";
    mainProgram = "${binName}";
    homepage = "https://github.com/M4RC3L05/denotag";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
