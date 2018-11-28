{ pkgs ? import <nixpkgs> { }, pythonPackages ? pkgs.python3Packages }:

let mtypesSrc = with builtins; filterSource
        (path: _:
           !elem (baseNameOf path) [".git"])
        ../../mtypes;
in {
  mtypes = pythonPackages.buildPythonPackage rec {
    name = "mtypes";

    src = mtypesSrc;

    meta = with pkgs.lib; {
      description = "Memory Types for Python";
      homepage = https://github.com/Quansight-Labs/mtypes;
      license = licenses.bsd3;
      broken = true;
    };
  };
}
