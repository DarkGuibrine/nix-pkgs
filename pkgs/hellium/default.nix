{
  lib,
  pkgs,
  ...
}:
pkgs.appimageTools.wrapType2 rec {
  pname = "helium";
  version = "0.12.4.1";

  src = pkgs.fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    hash = "sha256-OgS8HkLBseFrEhNFJxMwp1bg0gzPdfY1VaySAAp7vq0=";
  };

  nativeBuildInputs = with pkgs; [
    makeWrapper
  ];

  extraInstallCommands =
    let
      contents = pkgs.appimageTools.extractType2 { inherit pname version src; };
    in
    ''
      install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
      cp -r ${contents}/usr/share/icons $out/share
    '';

  meta = {
    description = "helium navegador";
    homepage = "https://github.com/imputnet/helium";
    changelog = "https://github.com/imputnet/helium/releases";
    license = lib.licenses.bsl11;
    mainProgram = "helium";
  };
}
