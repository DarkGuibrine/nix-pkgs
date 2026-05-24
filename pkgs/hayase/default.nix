{ lib, pkgs, ... }:

pkgs.appimageTools.wrapType2 rec {
  pname = "hayase";
  version = "6.4.67";

  src = pkgs.fetchurl {
    url = "https://api.hayase.watch/files/linux-hayase-${version}-linux.AppImage";
    hash = "sha256-npUSNtiCKTcAK2nOta225W9+07Rsm235vsiAAAALVFU=";
  };

  makeWrapperArgs = [
    "--add-flags"
    "--ozone-platform=wayland"
  ];

  extraInstallCommands =
    let
      contents = pkgs.appimageTools.extract { inherit pname version src; };
    in
    ''
      mkdir -p "$out/share/applications"
      mkdir -p "$out/share/lib/hayase"

      if [ -d ${contents}/resources ]; then
        cp -r ${contents}/resources "$out/share/lib/hayase/"
      fi

      if [ -d ${contents}/locales ]; then
        cp -r ${contents}/locales "$out/share/lib/hayase/"
      fi

      if [ -d ${contents}/usr/share ]; then
        cp -r ${contents}/usr/share/* "$out/share/"
      fi

      if [ -f ${contents}/*.desktop ]; then
        install -Dm444 ${contents}/*.desktop "$out/share/applications/hayase.desktop"
        substituteInPlace "$out/share/applications/hayase.desktop" \
          --replace-fail 'Exec=AppRun' 'Exec=hayase'
      fi
    '';

  meta = {
    description = "Hayase - Torrent streaming made simple";
    homepage = "https://hayase.watch";
    changelog = "https://hayase.watch/changelog";
    license = lib.licenses.bsl11;
    mainProgram = "hayase";
  };
}
