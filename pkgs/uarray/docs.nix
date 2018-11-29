{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "uarray-docs";

  src = with builtins; filterSource
        (path: _:
           !elem (baseNameOf path) [".git"])
        ../../../uarray-docs;

  buildInputs = [ pkgs.texlive.combined.scheme-full ];

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out
    cp build/*.pdf $out
  '';
}
