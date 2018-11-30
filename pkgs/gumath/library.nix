{ devlib
, stdenv
, libndtypes
, libxnd
}:

stdenv.mkDerivation rec {
  name = "libgumath";

  src = devlib.devSrc {
     inherit name;
     url = https://github.com/plures/gumath/;
     branch = "master";
     localPath = ../../../gumath;
  };

  buildInputs = [ libndtypes libxnd ];

  # Override linker with cc (symlink to either gcc or clang)
  # Library expects to use cc for linking
  configureFlags = [
    "LD=${stdenv.cc.targetPrefix}cc"
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Library supporting function dispatch on general data containers. C base and Python wrapper";
    homepage = https://xnd.io/;
    license = licenses.bsd3;
  };
}
