{ stdenv
, pythonPackages
, xnd
, ndtypes
}:

stdenv.mkDerivation {
  name = "xnd-docs";

  src = xnd.src;

  buildInputs = with pythonPackages; [
    pythonPackages.sphinx_rtd_theme pythonPackages.sphinx
    ndtypes xnd
  ];

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
}
