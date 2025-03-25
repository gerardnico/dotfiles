let
  pkgs = import <nixpkgs> {};
  inherit (pkgs) buildEnv;
in buildEnv {
  name = "commitlint";
  paths = [
    pkgs.nodejs
    pkgs.nodePackages."@commitlint/cli"
    pkgs.nodePackages."@commitlint/config-conventional"
  ];
}