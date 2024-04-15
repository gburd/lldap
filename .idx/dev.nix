# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: 
let
  moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
  nixpkgs = import <nixpkgs> {
    overlays = [ moz_overlay ];
}; 
in
  with nixpkgs;
  stdenv.mkDerivation {
    name = "rust";
    buildInputs = [ rustup ruststable ];
  }
{
  # Which nixpkgs channel to use.
  channel = "stable-23.11"; # or "unstable"
  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.cargo
    pkgs.rustc
    pkgs.rustfmt
    pkgs.stdenv.cc

    pkgs.pkg-config
    pkgs.nvi
  ];
  # Sets environment variables in the workspace
  env = {
    RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
  };
  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      "rust-lang.rust-analyzer"
      "tamasfe.even-better-toml"
      "serayuzgur.crates"
      "vadimcn.vscode-lldb"
    ];
    # Enable previews and customize configuration
    previews = {};
  };
}
