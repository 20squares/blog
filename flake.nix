{
  description = "Simple Ruby + Jekyll devshell";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        exists = builtins.pathExists (/. + "${currentDir}/gemset.nix");

        currentDir = builtins.getEnv "PWD";
        
        jekyllEnv = if exists then pkgs.bundlerEnv {
          name = "jekyll-env";
          ruby = pkgs.ruby;
          # We use /. + path to turn the string into a valid Nix path
          gemfile = /. + "${currentDir}/Gemfile";
          lockfile = /. + "${currentDir}/Gemfile.lock";
          gemset = /. + "${currentDir}/gemset.nix";
        } else null;

        myInputs = if exists 
          then [ jekyllEnv pkgs.bundix ] 
          else [ pkgs.ruby pkgs.bundix pkgs.git ];

        myHook = if exists then "" else ''
          echo "Generating gemset.nix..."
          if [ ! -f Gemfile.lock ]; then bundle lock; fi
          bundix

          echo "Done. Restart nix develop."
          exit 1
        '';

      in {
        devShells.default = pkgs.mkShell {
          buildInputs = myInputs;
          shellHook = myHook;
        };
      });
}