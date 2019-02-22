{ pkgs
, devlib
, pythonPackages
}:

{
  tex = pkgs.stdenv.mkDerivation rec {
    name = "uarray-docs-tex";

    src = devlib.devSrc {
       inherit name;
       url = https://github.com/Quansight-Labs/uarray-docs;
       branch = "master";
       localPath = ../../../uarray-docs;
    };

    buildInputs = [ pkgs.texlive.combined.scheme-full ];

    buildPhase = ''
      make
    '';

    installPhase = ''
      mkdir -p $out
      cp build/*.pdf $out
    '';
  };

  html = pkgs.stdenv.mkDerivation rec {
    name = "uarray-docs-tex";

    src = devlib.devSrc {
       inherit name;
       url = https://github.com/Quansight-Labs/uarray-docs;
       branch = "master";
       localPath = ../../../uarray-docs;
    };

    buildInputs = [
      pythonPackages.sphinx_rtd_theme pythonPackages.sphinx
    ];

    buildPhase = ''
      cd docs
      sphinx-build -b html . build/html
    '';

    installPhase = ''
      mkdir -p $out
      cp -r build/html/* $out
    '';
  };
}
