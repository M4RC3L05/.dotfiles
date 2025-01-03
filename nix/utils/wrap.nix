{ lib, pkgs }:
# https://nixos.wiki/wiki/Nix_Cookbook#Wrapping_packages
(
  pkg: options:
  let
    bins = options.bins or [ pkg.meta.mainProgram ];
    concatFlags = lib.concatStringsSep " " (
      lib.map (val: "--add-flags \"${val}\"") (options.flags or [ ])
    );
    concatEnvs = lib.concatStringsSep " " (
      lib.attrsets.mapAttrsToList (var: val: "--set \"${var}\" \"${val}\"") (options.env or [ ])
    );
    wrappingByBin = lib.listToAttrs (
      lib.map (bin: {
        name = bin;
        value = lib.concatStringsSep " " (
          lib.filter (item: item != "") [
            "makeWrapper \"${pkg}/bin/${bin}\" \"$out/bin/${bin}\""
            concatFlags
            concatEnvs
          ]
        );
      }) bins
    );
    mergedRunEnvironment = lib.attrsets.mergeAttrsList [
      (options.environment or { })
      { buildInputs = [ pkgs.makeWrapper ]; }
    ];
  in
  pkgs.runCommand "${pkg.name}-custom-wrapper" mergedRunEnvironment ''
    mkdir $out
    ln -s ${pkg}/* $out
    rm $out/bin
    mkdir $out/bin
    ln -s ${pkg}/bin/* $out/bin

    ${lib.concatStringsSep "\n" (
      lib.map (
        bin:
        let
          wrap = lib.getAttr bin wrappingByBin;
        in
        ''
          echo "=> Wrapping \"${bin}\""
          echo '==> ${wrap}'

          rm -rf "$out/bin/${bin}"
          ${wrap}
        ''
      ) bins
    )}
  ''
)
