{
  description = "devshell";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in
      with pkgs; {
        devShell = mkShell {
          buildInputs = [
            selene
            stylua
            sumneko-lua-language-server
          ];
        };
      });
}
