{ pkgs
, devlib
}:

let # set compiler
    stdenv = pkgs.overrideCC pkgs.stdenv pkgs.gcc8;
in
stdenv.mkDerivation rec {
  name = "psi-compiler";

  src = builtins.fetchGit {
    url = "https://github.com/saulshanabrook/psi-compiler";
    rev = "4a9217e0f4fa7d9e16e13bdcf7a2d996d643f2e4";
  };

  # format not a string literal and no format arguments [-Werror=format-security]
  # errors in gcc build
  hardeningDisable = [ "format" ];

  postConfigure = ''
    cd v0.4
    substituteInPlace makefile \
       --replace "CFLAGS=-g -L." "CFLAGS=-g -L. -w -DDEBUG=0"
  '';

  buildPhase = ''
    make
  '';

  meta = with stdenv.lib; {
    description = "Mathematics of Arrays PSI compiler";
    homepage = https://github.com/saulshanabrook/psi-compiler;
    license = licenses.unfree;
  };
}
