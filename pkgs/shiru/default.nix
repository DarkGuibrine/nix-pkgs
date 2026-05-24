{ lib, pkgs, ... }:

pkgs.appimageTools.wrapType2 rec {
  pname = "shiru";
  version = "v6.6.0";

  src = pkgs.fetchurl {
    url = "https://github.com/RockinChaos/Shiru/releases/download/${version}/linux-Shiru-${version}.AppImage";
    hash = "sha256-Y7R8gKsPm7NmzKXC0C24KqY1s7boWal3w5Lin35eswk=";
  };

  extraInstallCommands =
    let
      contents = pkgs.appimageTools.extract { inherit pname version src; };
    in
    ''
      mkdir -p "$out/share/applications"
      mkdir -p "$out/share/lib/shiru"

      if [ -d ${contents}/resources ]; then
        cp -r ${contents}/resources "$out/share/lib/shiru/"
      fi

      if [ -d ${contents}/locales ]; then
        cp -r ${contents}/locales "$out/share/lib/shiru/"
      fi

      if [ -d ${contents}/usr/share ]; then
        cp -r ${contents}/usr/share/* "$out/share/"
      fi

      if [ -f ${contents}/*.desktop ]; then
        install -Dm444 ${contents}/*.desktop "$out/share/applications/shiru.desktop"
        substituteInPlace "$out/share/applications/shiru.desktop" \
          --replace-fail 'Exec=AppRun' 'Exec=shiru'
      fi
    '';

  meta = {
    description = "Shiru - Torrent streaming made simple";
    homepage = "https://github.com/RockinChaos/Shiru";
    changelog = "https://github.com/RockinChaos/Shiru/releases";
    license = lib.licenses.bsl11;
    mainProgram = "shiru";
  };
}
