{
  lib,
  pkgs,
  ...
}:

let
  pname = "helium";
  version = "0.12.4.1";

  src = pkgs.fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    hash = "sha256-OgS8HkLBseFrEhNFJxMwp1bg0gzPdfY1VaySAAp7vq0=";
  };

  contents = pkgs.appimageTools.extractType2 {
    inherit pname version src;
  };
in
pkgs.appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs =
    pkgs: with pkgs; [
      gtk3
      nss
      nspr
      libdrm
      mesa

      libx11
      libxcb
      libxcomposite
      libxdamage
      libxext
      libxfixes
      libxrandr
      libxi
      libxtst
      libxscrnsaver

      atk
      at-spi2-atk
      cairo
      pango
      expat
      alsa-lib
    ];

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons
    mkdir -p $out/share/pixmaps

    cp ${contents}/*.desktop \
      $out/share/applications/${pname}.desktop

    desktop_file="$out/share/applications/${pname}.desktop"

    sed -i "s|^Exec=.*|Exec=$out/bin/${pname}|g" "$desktop_file"

    if [ -d "${contents}/usr/share/icons" ]; then
      cp -r ${contents}/usr/share/icons/* \
        $out/share/icons/
    fi

    find ${contents} -iname "*.png" -exec cp {} $out/share/pixmaps/${pname}.png \; | head -n 1
  '';

  meta = with lib; {
    description = "Helium Browser";
    homepage = "https://github.com/imputnet/helium";
    changelog = "https://github.com/imputnet/helium/releases";
    license = licenses.bsl11;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
