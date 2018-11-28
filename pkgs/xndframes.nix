{ pkgs ? import <nixpkgs> { }, pythonPackages ? pkgs.python3Packages }:

let xndframesSrc = with builtins; filterSource
          (path: _:
             !elem (baseNameOf path) [".git"])
          ../../xndframes;

    xndBuild = import ./xnd.nix { };
in rec {
  xndframes = pythonPackages.buildPythonPackage rec {
    name = "xndframes";

    src = xndframesSrc;

    buildInputs = with pythonPackages; [ pytestrunner ];
    checkInputs = with pythonPackages; [ pytest flake8 ];
    propagatedBuildInputs = with pythonPackages; [ xndBuild.xnd pandas ];

    meta = with pkgs.lib; {
      description = "Pandas ExtensionDType/Array backed by xnd";
      homepage = https://github.com/Quansight-Labs/xndframes;
      license = licenses.bsd3;
      broken = true;
    };
  };

  xndframes-docs = pkgs.stdenv.mkDerivation {
    name = "xndtools-docs";

    src = xndframesSrc;

    buildInputs = with pythonPackages; [ sphinx_rtd_theme sphinx xndframes ];

    buildPhase = ''
      cd doc
      make html
    '';

    installPhase = ''
      mkdir -p $out
      cp -r build/html/* $out
    '';
  };

}
