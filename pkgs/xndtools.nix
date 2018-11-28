{ pkgs ? import <nixpkgs> { }, pythonPackages ? pkgs.python3Packages }:

let xndtoolsSrc = with builtins; filterSource
          (path: _:
             !elem (baseNameOf path) [".git"])
          ../../xndtools;

    ndtypesBuild = import ./ndtypes.nix { };
    xndBuild = import ./xnd.nix { };
    gumathBuild = import ./gumath.nix { };
in rec {
  xndtools = pythonPackages.buildPythonPackage rec {
    name = "xndtools";

    src = xndtoolsSrc;

    buildInputs = with pythonPackages; [ pytestrunner ];
    checkInputs = with pythonPackages; [ pytest ];
    propagatedBuildInputs = [ ndtypesBuild.ndtypes xndBuild.xnd gumathBuild.gumath ];

    meta = with pkgs.lib; {
      description = "Development tools for the XND project";
      homepage = https://github.com/plures/xndtools;
      license = licenses.bsd3;
      broken = true;
    };
  };

  xndtools-docs = pkgs.stdenv.mkDerivation {
    name = "xndtools-docs";

    src = xndtoolsSrc;

    buildInputs = with pythonPackages; [ sphinx_rtd_theme sphinx ];

    buildPhase = ''
      cd doc
      make doctest
      # output.txt gets added to html from doctest
      rm build/html/output.txt
      make html
    '';

    installPhase = ''
      mkdir -p $out
      cp -r build/html/* $out
    '';
  };

}
