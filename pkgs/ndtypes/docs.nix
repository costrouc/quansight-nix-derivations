{ stdenv
, devlib
, pythonPackages
, ndtypes
}:

stdenv.mkDerivation rec {
  name = "ndtypes-docs";

  src = devlib.devSrc {
     inherit name;
     url = https://github.com/plures/ndtypes/;
     branch = "master";
     localPath = ../../../ndtypes;
  };

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
