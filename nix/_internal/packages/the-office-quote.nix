{ pkgs, lib }:
pkgs.stdenv.mkDerivation rec {
  binName = "the-office-quote";
  pname = "@m4rc3l05/${binName}";
  version = "1.0.12";

  src = pkgs.fetchurl {
    url = "https://github.com/M4RC3L05/the-office-quote/releases/download/v${version}/the-office-quote-x86_64-unknown-linux-gnu.tar.gz";
    sha256 = "sha256-7cSV1hqvMVCD7l3g5Kuqom2anxejLqXkCsAmmn8FC7A=";
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
    description = "CLI to display a random The Office US quote";
    mainProgram = "${binName}";
    homepage = "https://github.com/M4RC3L05/the-office-quote";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
