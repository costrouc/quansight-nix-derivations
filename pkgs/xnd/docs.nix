{ stdenv
, devlib
, pythonPackages
, xnd
, ndtypes
}:

stdenv.mkDerivation rec {
  name = "xnd-docs";

  src = devlib.devSrc {
     inherit name;
     url = https://github.com/plures/xnd/;
     branch = "master";
     localPath = ../../../xnd;
  };

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
