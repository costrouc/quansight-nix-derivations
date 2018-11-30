{ stdenv
, devlib
, libndtypes
}:

stdenv.mkDerivation rec {
  name = "libxnd";

  src = devlib.devSrc {
     inherit name;
     url = https://github.com/plures/xnd/;
     branch = "master";
     localPath = ../../../xnd;
  };

  buildInputs = [ libndtypes ];

  configureFlags = [
    # Override linker with cc (symlink to either gcc or clang)
    # Library expects to use cc for linking
    "LD=${stdenv.cc.targetPrefix}cc"
    # needed for tests
    "--with-includes=${libndtypes}/include"
    "--with-libs=${libndtypes}/lib"
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "C library for managing typed memory blocks and Python container module";
    homepage = https://xnd.io/;
    license = licenses.bsd3;
  };
}
