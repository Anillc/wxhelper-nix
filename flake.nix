{
  outputs = inputs@{
    self, nixpkgs, flake-parts,
  }: flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    perSystem = { config, pkgs, lib, ... }: {
      imports = map (x: ./modules/${x}) (lib.attrNames (builtins.readDir ./modules));
      packages.default = config.wxhelper.wxhelper;
      devShells.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [];
      };
    };
  };
}
