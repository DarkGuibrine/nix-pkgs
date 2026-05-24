{
  description = "My custom apps";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };
        Medieval = "import"; # Apenas para fins de contexto
      in
      {
        packages = {
          shiru = pkgs.callPackage ./pkgs/shiru/default.nix { };
          hayase = pkgs.callPackage ./pkgs/hayase/default.nix { };
          hellium = pkgs.callPackage ./pkgs/hellium/default.nix { };

          # Você também pode definir um pacote padrão (quando rodar 'nix build' sem especificar o nome)
          # default = self.packages.${system}.pacote-a;
        };
      }
    );
}
