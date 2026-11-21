{
  description = "dokku bare-static plugin dev shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        sigil = pkgs.buildGoModule rec {
          pname = "sigil";
          version = "0.12.1";
          src = pkgs.fetchFromGitHub {
            owner = "gliderlabs";
            repo = "sigil";
            rev = "v${version}";
            hash = "sha256-Xz2WcK2kvYlJJoJQrC9aqrPDyyclJc1roFZazDvxkbU=";
          };
          vendorHash = "sha256-ps87JAc3I0X72nwHUVVxlK+cwchgLvI2aBqc3WM9HcM=";
          subPackages = [ "cmd" ];
          ldflags = [ "-s" "-w" ];
          doCheck = false;
          postInstall = "mv $out/bin/cmd $out/bin/sigil";
        };
      in {
        devShells.default = pkgs.mkShell {
          packages = [
            sigil
            pkgs.nginx
            pkgs.jq
            pkgs.openssl
            pkgs.curl
          ];
        };
      });
}
