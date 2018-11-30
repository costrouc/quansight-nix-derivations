{ pkgs
, devlib
}:

pkgs.stdenv.mkDerivation rec {
  name = "uarray-docs";

  src = devlib.devSrc {
     inherit name;
     url = https://github.com/Quansight-Labs/uarray;
     branch = "master";
     localPath = ../../../uarray;
  };

  buildInputs = [ pkgs.texlive.combined.scheme-full ];

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out
    cp build/*.pdf $out
  '';
}
