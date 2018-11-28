{ pkgs ? import <nixpkgs> { }, pythonPackages ? pkgs.python3Packages }:

let packageMeta = with pkgs.lib; {
      description = "C library for typing memory blocks and Python module";
      homepage = https://xnd.io/;
      license = licenses.bsd3;
    };

    ndtypesSrc = with builtins; filterSource
        (path: _:
           !elem (baseNameOf path) [".git"])
        ../../ndtypes;
in
rec {
  libndtypes = pkgs.stdenv.mkDerivation {
    name = "libndtypes";

    src = ndtypesSrc;

    # Override linker with cc (symlink to either gcc or clang)
    # Library expects to use cc for linking
    configureFlags = [ "LD=${pkgs.stdenv.cc.targetPrefix}cc" ];

    doCheck = true;

    meta = packageMeta;
  };

  ndtypes = pythonPackages.buildPythonPackage {
    name = "ndtypes";

    src = ndtypesSrc;

    propagatedBuildInputs = [ pythonPackages.numpy ];

    postPatch = ''
      substituteInPlace setup.py \
        --replace 'include_dirs = ["libndtypes"]' \
                  'include_dirs = ["${libndtypes}/include"]' \
        --replace 'library_dirs = ["libndtypes"]' \
                  'library_dirs = ["${libndtypes}/lib"]' \
        --replace 'runtime_library_dirs = ["$ORIGIN"]' \
                  'runtime_library_dirs = ["${libndtypes}/lib"]'
    '';

    postInstall = ''
      mkdir $out/include
      cp python/ndtypes/*.h $out/include
    '';

    meta = packageMeta;
  };

  ndtypes-docs = pkgs.stdenv.mkDerivation {
    name = "ndtypes-docs";

    src = ndtypesSrc;

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
  };

}
