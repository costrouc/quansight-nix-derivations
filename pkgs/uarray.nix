{ pkgs ? import <nixpkgs> { }, pythonPackages ? pkgs.python3Packages }:

rec {
  uarray = pythonPackages.buildPythonPackage rec {
    name = "uarray";
    format = "flit";

    src = with builtins; filterSource
        (path: _:
           !elem (baseNameOf path) [".git"])
           ../../uarray;

    checkInputs = with pythonPackages; [
      pytest nbval pytestcov numba mypy
    ];
    propagatedBuildInputs = with pythonPackages; [
      matchpy numpy astunparse typing-extensions black
    ];

    checkPhase = ''
      mypy uarray
      ${pythonPackages.python.interpreter} extract_readme_tests.py
      pytest
    '';

    meta = with pkgs.lib; {
      description = "Universal array library";
      homepage = https://github.com/Quansight-Labs/uarray;
      license = licenses.bsd0;
      maintainers = [ maintainers.costrouc ];
    };
  };

  uarray-docs = pkgs.stdenv.mkDerivation {
    name = "uarray-docs";

    src = with builtins; filterSource
          (path: _:
             !elem (baseNameOf path) [".git"])
          ../../uarray-docs;

    buildInputs = [ pkgs.texlive.combined.scheme-full ];

    buildPhase = ''
      make
    '';

    installPhase = ''
      mkdir -p $out
      cp build/*.pdf $out
    '';
  };

  uarray-notebooks = pkgs.mkShell {
    buildInputs = with pythonPackages; [
      black pylint jupyterlab pudb flake8 perf altair pandas # pandoc pypandoc # dev-requirements.txt
      matchpy numba mypy pytestcov pytest numpy astunparse typing-extensions nbval pytest-mypy flit # requirements.txt
    ];
  };
}
