{ pkgs, ... }:

pkgs.appimageTools.wrapType2 rec {
  pname = "helium";
  version = "0.12.4.1";

  src = pkgs.fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/${pname}-${version}-x86_64.AppImage";
    sha256 = "sha256-OgS8HkLBseFrEhNFJxMwp1bg0gzPdfY1VaySAAp7vq0=";
  };

  extraInstallCommands =
    let
      contents = pkgs.appimageTools.extract { inherit pname version src; };
    in
    ''
      if [ -f ${contents}/*.desktop ]; then
        install -Dm444 ${contents}/*.desktop -t $out/share/applications
      fi

      if [ -d ${contents}/usr/share/icons ]; then
        cp -r ${contents}/usr/share/icons $out/share
      fi
    '';
}
