{ stdenv
, pythonPackages
, xndframes
}:

stdenv.mkDerivation {
  name = "xndtools-docs";

  src = xndframes.src;

  buildInputs = [
    pythonPackages.sphinx_rtd_theme pythonPackages.sphinx
    xndframes
  ];

  buildPhase = ''
    cd doc
    make html
  '';

  installPhase = ''
    mkdir -p $out
    cp -r build/html/* $out
  '';

}
