# flytectlnix

Nix [flake](https://nixos.wiki/wiki/Flakes) for [flytectl](https://github.com/flyteorg/flytectl)

## Usage

This `flytectl` `nix` flake assumes you have already [installed nix](https://determinate.systems/posts/determinate-nix-installer)

### Option 1. Use the `flytectl` CLI within your own flake

```nix
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.flytectl.url = "github:rupurt/flytectl";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    flytectl,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            flytectl.overlay
          ];
        };
      in rec
      {
        packages = {
          flytectl = pkgs.flytectl {};
        };

        devShells.default = pkgs.mkShell {
          packages = [
            packages.flytectl
          ];
        };
      }
    );
}
```

The above config will add `flytectl` to your dev shell and also allow you to execute it
through the `nix` CLI utilities.

```sh
# run from devshell
nix develop -c $SHELL
flytectl
```

```sh
# run as application
nix run .#flytectl
```

### Option 2. Run the `flytectl` CLI directly with `nix run`

```nix
nix run github:rupurt/flytectlnix
```

## Authors

- Alex Kwiatkowski - alex+git@fremantle.io

## License

`flytectlnix` is released under the MIT license
