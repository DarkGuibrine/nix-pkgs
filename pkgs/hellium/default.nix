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
      xorg.libX11
      xorg.libxcb
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXrandr
      xorg.libXi
      xorg.libXtst
      xorg.libXScrnSaver
      at-spi2-atk
      atk
      cairo
      pango
      expat
      alsa-lib
    ];

  nativeBuildInputs = with pkgs; [
    makeWrapper
  ];

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons

    install -Dm444 \
      ${contents}/${pname}.desktop \
      $out/share/applications/${pname}.desktop

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=$out/bin/${pname}'

    if [ -d "${contents}/usr/share/icons" ]; then
      cp -r ${contents}/usr/share/icons/* $out/share/icons/
    fi

    if [ -f "${contents}/${pname}.png" ]; then
      install -Dm444 \
        ${contents}/${pname}.png \
        $out/share/pixmaps/${pname}.png
    fi
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
