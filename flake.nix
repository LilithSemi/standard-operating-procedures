{
  description = "Engineering procedures for coding agents";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs =
    { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.runCommand "standard-operating-procedures" { } ''
            mkdir -p $out/share/agent-skills
            cp -r ${./skills}/. $out/share/agent-skills/
          '';
        }
      );
    };
}
