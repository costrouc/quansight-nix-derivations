{ stdenv
, pythonPackages
, ndtypes
}:

stdenv.mkDerivation {
  name = "ndtypes-docs";

  src = ndtypes.src;

  buildInputs = with pythonPackages; [ sphinx_rtd_theme sphinx ndtypes ];

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
