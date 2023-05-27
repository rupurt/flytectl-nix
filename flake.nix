{
  description = "Nix flake to manage flytectl. A cross platform CLI for Flyte";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    ...
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    outputs = flake-utils.lib.eachSystem systems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [self.overlay];
      };
    in rec {
      # packages exported by the flake
      packages.default = pkgs.flytectl {};

      # nix run
      apps = {
        flytectl = flake-utils.lib.mkApp {drv = packages.default;};
        default = apps.flytectl;
      };

      # nix fmt
      formatter = pkgs.alejandra;

      # nix develop -c $SHELL
      devShells.default = pkgs.mkShell {
        packages = [
          packages.default
        ];
      };
    });
  in
    outputs
    // {
      # Overlay that can be imported so you can access the packages
      # using flytectl.overlay
      overlay = final: prev: {
        flytectl = prev.pkgs.callPackage ./default.nix {};
      };
    };
}
