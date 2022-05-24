{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }: let
    # Maps the nixpkgs systems to Zig targets.
    systemToZigTarget = {
      "aarch64-linux" = "aarch64-linux";
      "aarch64-darwin" = "aarch64-macos";
      "x86_64-linux" = "x86_64-linux";
      "x86_64-darwin" = "x86_64-macos";
    };

    # The list of nixpkgs systems this flake supports.
    supportedSystems = builtins.attrNames systemToZigTarget;

    # The download index from the Zig website.
    index = builtins.fromJSON (builtins.readFile ./index.json);

    # The current version of Zig provided by this flake.
    zigVersion = index.master.version;
  in
    # Build the outputs for each supported system.
    flake-utils.lib.eachSystem supportedSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};

      # Map the current nixpkgs system to the corresponding Zig target.
      zigTarget = systemToZigTarget.${system};

      # Build the derivation's source information.
      zigTargetIndex = index.master.${zigTarget};
      zigTarball = {
        url = zigTargetIndex.tarball;
        sha256 = zigTargetIndex.shasum;
      };
    in rec {
      # nix build
      packages.zig = pkgs.stdenv.mkDerivation {
        pname = "zig";
        version = zigVersion;

        src = pkgs.fetchurl zigTarball;

        phases = ["unpackPhase" "installPhase"];
        installPhase = ''
          mkdir -p $out/bin $out/lib/zig
          cp zig $out/bin
          cp -r -T lib/ $out/lib/zig
        '';
      };
      packages.default = packages.zig;

      # nix run
      apps.zig = flake-utils.lib.mkApp {
        drv = packages.zig;
      };
      apps.default = apps.zig;

      # nix fmt
      formatter = pkgs.alejandra;
    });
}
