{ pkgs ? import <nixpkgs> { }, pythonPackages ? pkgs.python3Packages }:

let ndtypesBuild = import ./ndtypes.nix { };
    xndBuild = import ./xnd.nix { };
    gumathBuild = import ./gumath.nix { };
in rec {
  xndtools = pythonPackages.buildPythonPackage rec {
    name = "xndtools";

    src = with builtins; filterSource
          (path: _:
             !elem (baseNameOf path) [".git"])
          ../../xndtools;

    buildInputs = with pythonPackages; [ pytestrunner ];
    checkInputs = with pythonPackages; [ pytest ];
    propagatedBuildInputs = [ ndtypesBuild.ndtypes xndBuild.xnd gumathBuild.gumath ];

    meta = with pkgs.lib; {
      description = "Development tools for the XND project";
      homepage = https://github.com/plures/xndtools;
      license = licenses.bsd3;
    };
  };
}
