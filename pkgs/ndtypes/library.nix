{ stdenv }:

stdenv.mkDerivation {
  name = "libndtypes";

  src = with builtins; filterSource
        (path: _:
           !elem (baseNameOf path) [".git"])
        ../../../ndtypes;

  # Override linker with cc (symlink to either gcc or clang)
  # Library expects to use cc for linking
  configureFlags = [ "LD=${stdenv.cc.targetPrefix}cc" ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "C library for typing memory blocks and Python module";
    homepage = https://xnd.io/;
    license = licenses.bsd3;
  };
}
