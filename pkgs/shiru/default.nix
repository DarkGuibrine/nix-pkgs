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
      mkdir -p $out/share/applications
      cp ${contents}/${pname}.desktop $out/share/applications/${pname}.desktop
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=helium %U' 'Exec=helium' \
        --replace 'Exec=helium --incognito' 'Exec=helium --incognito' \
        --replace 'Exec=AppRun %U' 'Exec=helium' \
        --replace 'Exec=AppRun' 'Exec=helium'
      if [ -d "${contents}/usr/share/icons" ]; then
        mkdir -p $out/share/icons
        cp -r ${contents}/usr/share/icons/* $out/share/icons/
      fi
    '';

  # garante integração correta com desktop
  extraWrapProgramArgs = ''
    --set DESKTOP_FILE_NAME helium.desktop
  '';
}
