{ stdenv
, pythonPackages
, ndtypes
, xnd
, gumath
}:

stdenv.mkDerivation {
  name = "gumath-docs";

  src = gumath.src;

  buildInputs = [
    pythonPackages.sphinx_rtd_theme pythonPackages.sphinx
    ndtypes xnd gumath
  ];

  buildPhase = ''
    cd doc
    sphinx-build -b doctest -d build/doctrees . build/html
    # output.txt gets added to html from doctest
    rm build/html/output.txt
    sphinx-build -b html -d build/doctrees . build/html
  '';

  installPhase = ''
    mkdir -p $out
    cp -r build/html/* $out
  '';
}
